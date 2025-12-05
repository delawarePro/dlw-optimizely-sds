using System.Xml;
using Delaware.Optimizely.Sitemap.Client;
using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Core.Client;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Middleware;
using Delaware.Optimizely.Sitemap.Shared.Models;
using Delaware.Optimizely.Sitemap.Shared.Utilities;
using Delaware.Optimizely.Sitemap.SitemapXml.Output;
using Delaware.Optimizely.Sitemap.SitemapXml.Storage;
using Microsoft.Extensions.Options;

namespace Delaware.Optimizely.Sitemap.SitemapXml;

internal class DefaultSitemapGeneratorService(
    IEmbeddedSiteCatalogClient embeddedSiteCatalogClient,
    ISitemapProcessorRegistry sitemapProcessorRegistry,
    ISitemapXmlWriter sitemapXmlWriter,
    ISitemapXmlStorageProvider? sitemapXmlStorageProvider,
    IOptions<EmbeddedSitemapOptions> options)
    : ISitemapGeneratorService
{
    public async Task<SitemapState?> GenerateAndPersistDeltaAsync(
        IOperationContext context, 
        ISiteCatalog siteCatalog,
        IReadOnlyCollection<SiteCatalogEntry> updates)
    {
        var state = embeddedSiteCatalogClient.GetState(siteCatalog.SiteId);

        if (updates is { Count: > 0 })
        {
            using (new SiteContextSwitcher(siteCatalog.SiteDefinition))
            {

                foreach (var languageGroup in siteCatalog.LanguageGroups)
                {
                    var storedPageCount = state.DeltaPagesPerLanguageGroup.TryGetValue(languageGroup.Key, out var deltaPagesCurrentLanguageGroup)
                        ? new StoredPageCount(deltaPagesCurrentLanguageGroup.Count)
                        : new StoredPageCount(0);

                    var currentDelta = storedPageCount.Value;

                    var sitemapXmlPageUrls =
                        await DoGenerateAndPersistAsync(siteCatalog, languageGroup, updates, storedPageCount, true) ?? [];

                    foreach (var sitemapXmlPageUrl in sitemapXmlPageUrls)
                    {
                        if (!state.DeltaPagesPerLanguageGroup.ContainsKey(languageGroup.Key))
                        {
                            state.DeltaPagesPerLanguageGroup[languageGroup.Key] = new Dictionary<int, string>();
                        }

                        state.DeltaPagesPerLanguageGroup[languageGroup.Key][currentDelta++] = sitemapXmlPageUrl;
                    }
                }
            }
        }

        state.LastDeltaGenerationUtc = DateTime.UtcNow;
        embeddedSiteCatalogClient.SaveState(state);

        return state;
    }

    public async Task<SitemapState?> GenerateAndPersistAsync(IOperationContext context, ISiteCatalog siteCatalog)
    {
        using (new SiteContextSwitcher(siteCatalog.SiteDefinition))
        {
            var siteName = siteCatalog.SiteId;
            var entryCountForSite = embeddedSiteCatalogClient.GetCatalogEntryCount(siteName);
           
            var state = embeddedSiteCatalogClient.GetState(siteName);

            state.FullPagesPerLanguageGroup = new Dictionary<string, IDictionary<int, string>>();

            foreach (var languageGroup in siteCatalog.LanguageGroups)    
            {
                var storedPageCount = new StoredPageCount(0);

                var processedCount = 0;
                var currentEntryBatch = 0;
                var sitemapPageCount = 0;

                while (processedCount < entryCountForSite)
                {
                    var entries = embeddedSiteCatalogClient.GetCatalog(siteName, currentEntryBatch, options.Value.UrlCountPerSitemapPage);

                    if (entries is not { Count: > 0 }) break;

                    var sitemapPageUrlsPerLanguageGroup =
                        await DoGenerateAndPersistAsync(siteCatalog, languageGroup, entries, storedPageCount, false) ?? [];

                    foreach (var sitemapXmlPageUrl in sitemapPageUrlsPerLanguageGroup)
                    {
                        if (!state.FullPagesPerLanguageGroup.ContainsKey(languageGroup.Key))
                        {
                            state.FullPagesPerLanguageGroup[languageGroup.Key] = new Dictionary<int, string>();
                        }

                        state.FullPagesPerLanguageGroup[languageGroup.Key][sitemapPageCount++] = sitemapXmlPageUrl;
                    }

                    processedCount += entries.Count;
                    currentEntryBatch = ++currentEntryBatch;
                }
            }

            state.LastDeltaGenerationUtc = null;
            state.LastFullGenerationUtc = DateTime.UtcNow;
            state.DeltaPagesPerLanguageGroup = new Dictionary<string, IDictionary<int, string>>(0);

            // TODO clean in a new way? siteCatalog.SitemapXmlStorageProvider.Clean(state);

            embeddedSiteCatalogClient.SaveState(state);

            return state;
        }
    }

    private async Task<IReadOnlyCollection<string>?> DoGenerateAndPersistAsync(ISiteCatalog catalog,
        KeyValuePair<string, IReadOnlyCollection<string>> languageGroup,
        IReadOnlyCollection<SiteCatalogEntry> entries,
        StoredPageCount storedPageCount,
        bool isDelta)
    {
        if (sitemapXmlStorageProvider == null)
        {
            throw new Exception("No sitemap storage provider was registered.");
        }

        var mapped =
            entries
                .Select(x => new DefaultSiteResource(x))
                .ToArray();

        var sourceSet = new SourceSet(mapped, new Source(catalog.SiteId), languageGroup);

        var resourceUrls = new List<SiteResourceUrls>();

        foreach (var processor in sitemapProcessorRegistry.Processors.Where(p => p.CanProcess(catalog)))
        {
            var urls = await processor.Process(sourceSet);
            resourceUrls.AddRange(urls);
        }

        if (resourceUrls.Count <= 0)
        {
            return null;
        }

        var storedCount = 0;
        var storedLocations = new List<string>();

        while (storedCount < resourceUrls.Count)
        {
            var batch = resourceUrls
                .Skip(storedCount)
                .Take(options.Value.UrlCountPerSitemapPage)
                .ToList();

            using var memory = new MemoryStream();
            var xmlWriterSettings = sitemapXmlWriter.GetSettings(true);
            await using var xmlWriter = XmlWriter.Create(memory, xmlWriterSettings);

            // Write the XML.
            await sitemapXmlWriter.WriteSitemapHeader(memory, xmlWriter);
            await sitemapXmlWriter.WriteUrls(batch.SelectMany(x => x.Urls), memory, xmlWriter);
            await sitemapXmlWriter.WriteSitemapFooter(memory, xmlWriter);

            // Reset the stream position.
            memory.Seek(0, SeekOrigin.Begin);

            storedLocations.Add(sitemapXmlStorageProvider.Store(catalog.SiteDefinition, languageGroup, memory, storedPageCount.Value++, isDelta));

            storedCount += batch.Count();
        }

        return storedLocations;
    }

    internal class StoredPageCount(int initialValue)
    {
        public int Value { get; set; } = initialValue;
    }
}