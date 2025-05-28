using Dlw.Optimizely.Sds;
using Dlw.Optimizely.Sds.Builders;
using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.SDS.Client;
using Dlw.Optimizely.SDS.Embedded.Client;
using Dlw.Optimizely.SDS.Embedded.Middleware;
using Dlw.Optimizely.SDS.Embedded.SitemapXml.Output;
using Dlw.Optimizely.SDS.Embedded.SitemapXml.Storage;
using Dlw.Optimizely.SDS.Shared.Models;
using Dlw.Optimizely.SDS.Shared.Utilities;
using Microsoft.Extensions.Options;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml;

internal class DefaultSitemapGeneratorService : ISitemapGeneratorService
{
    private readonly IEmbeddedSiteCatalogClient _embeddedSiteCatalogClient;
    private readonly ISitemapXmlWriter _sitemapXmlWriter;
    private readonly ISitemapXmlStorageProvider? _sitemapXmlStorageProvider;
    private readonly ISitemapProcessorRegistry _sitemapProcessorRegistry;
    private readonly SiteCatalogDirectory _siteCatalogDirectory;
    private readonly IOptions<EmbeddedSdsOptions> _options;

    public DefaultSitemapGeneratorService(
        SiteCatalogDirectory siteCatalogDirectory,
        IEmbeddedSiteCatalogClient embeddedSiteCatalogClient,
        ISitemapProcessorRegistry sitemapProcessorRegistry,
        ISitemapXmlWriter sitemapXmlWriter,
        ISitemapXmlStorageProvider? sitemapXmlStorageProvider,
        IOptions<EmbeddedSdsOptions> options)
    {
        _embeddedSiteCatalogClient = embeddedSiteCatalogClient;
        _sitemapXmlWriter = sitemapXmlWriter;
        _sitemapXmlStorageProvider = sitemapXmlStorageProvider;
        _options = options;
        _sitemapProcessorRegistry = sitemapProcessorRegistry;
        _siteCatalogDirectory = siteCatalogDirectory;
    }

    public async Task<SitemapState?> GenerateAndPersistDeltaAsync(
        IOperationContext context, 
        ISiteCatalog siteCatalog,
        IReadOnlyCollection<SiteCatalogEntry> updates)
    {
        var state = _embeddedSiteCatalogClient.GetState(siteCatalog.SiteId);
        var storedPageCount = new StoredPageCount(state.DeltaPages.Count);

        if (updates is { Count: > 0 })
        {
            using (new SiteContextSwitcher(siteCatalog.SiteDefinition))
            {
                var currentDelta = state.DeltaPages.Count;

                var sitemapXmlPageUrls =
                    await DoGenerateAndPersistAsync(siteCatalog, updates, storedPageCount, false) ?? Array.Empty<string>();

                foreach (var sitemapXmlPageUrl in sitemapXmlPageUrls)
                {
                    state.DeltaPages[currentDelta++] = sitemapXmlPageUrl;
                }
            }
        }

        state.LastDeltaGenerationUtc = DateTime.UtcNow;
        _embeddedSiteCatalogClient.SaveState(state);

        return state;
    }

    public async Task<SitemapState?> GenerateAndPersistAsync(IOperationContext context, ISiteCatalog siteCatalog)
    {
        using (new SiteContextSwitcher(siteCatalog.SiteDefinition))
        {
            var siteName = siteCatalog.SiteId;
            var entryCountForSite = _embeddedSiteCatalogClient.GetCatalogEntryCount(siteName);
            var processedCount = 0;
            var currentEntryBatch = 0;
            var sitemapPageCount = 0;
            var state = _embeddedSiteCatalogClient.GetState(siteName);

            state.FullPages = new Dictionary<int, string>();
            var storedPageCount = new StoredPageCount(0);

            while (processedCount < entryCountForSite)
            {
                var entries = _embeddedSiteCatalogClient.GetCatalog(siteName, currentEntryBatch, _options.Value.UrlCountPerSitemapPage);

                if (entries is not { Count: > 0 }) break;

                var sitemapXmlPageUrls = 
                    await DoGenerateAndPersistAsync(siteCatalog, entries, storedPageCount, false) ?? Array.Empty<string>();

                foreach (var sitemapXmlPageUrl in sitemapXmlPageUrls)
                {
                    state.FullPages[sitemapPageCount++] = sitemapXmlPageUrl;
                }

                processedCount += entries.Count;
                currentEntryBatch = ++currentEntryBatch;
            }

            state.LastDeltaGenerationUtc = null;
            state.LastFullGenerationUtc = DateTime.UtcNow;
            state.DeltaPages = new Dictionary<int, string>(0);

            // TODO clean in a new way? siteCatalog.SitemapXmlStorageProvider.Clean(state);

            _embeddedSiteCatalogClient.SaveState(state);

            return state;
        }
    }

    private async Task<ICollection<string>?> DoGenerateAndPersistAsync(
        ISiteCatalog catalog,
        IReadOnlyCollection<SiteCatalogEntry> entries,
        StoredPageCount storedPageCount,
        bool isDelta)
    {
        if (_sitemapXmlStorageProvider == null)
        {
            throw new Exception("No sitemap storage provider was registered.");
        }

        var mapped =
            entries
                .Select(x => new DefaultSiteResource(x))
                .ToArray();

        var sourceSet = new SourceSet(mapped, new Source(catalog.SiteId));

        var resourceUrls = new List<SiteResourceUrls>();

        foreach (var processor in _sitemapProcessorRegistry.Processors.Where(p => p.CanProcess(catalog)))
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
                .Take(_options.Value.UrlCountPerSitemapPage)
                .ToList();

            using var memory = new MemoryStream();

            // Write the XML.
            await _sitemapXmlWriter.WriteSitemapHeader(memory);
            await _sitemapXmlWriter.WriteUrls(batch.SelectMany(x => x.Urls), memory);
            await _sitemapXmlWriter.WriteSitemapFooter(memory);

            // Reset the stream position.
            memory.Seek(0, SeekOrigin.Begin);

            storedLocations.Add(_sitemapXmlStorageProvider.Store(catalog.SiteDefinition, memory, storedPageCount.Value++, isDelta));

            storedCount += batch.Count();
        }

        return storedLocations;

    }

    internal class StoredPageCount
    {
        public StoredPageCount(int initialValue)
        {
            Value = initialValue;
        }

        public int Value { get; set; }
    }
}