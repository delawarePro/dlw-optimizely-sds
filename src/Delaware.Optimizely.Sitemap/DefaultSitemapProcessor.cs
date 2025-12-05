using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.SitemapXml;
using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap;

public class DefaultSitemapProcessor : ISiteResourceProcessor
{
    /// <summary>
    /// Logical sitemap identifier, this has nothing to do with file names.
    /// </summary>
    public string SitemapId => SiteDefinition.Name;

    public SiteDefinition SiteDefinition { get; }

    public IReadOnlyCollection<ISitemapDataExtractor> Extractors { get; private set; }

    public string? SitemapUrl { get; }

    public DefaultSitemapProcessor(
        SiteDefinition siteDefinition,
        IReadOnlyCollection<ISitemapDataExtractor> extractors,
        string? sitemapUrl = null)
    {
        if (string.IsNullOrWhiteSpace(siteDefinition.Name))
            throw new ArgumentException($"Could not determine site catalog ID for site definition {siteDefinition.Id}");

        SiteDefinition = siteDefinition;
        Extractors = extractors;
        SitemapUrl = sitemapUrl;
    }

    public async Task<IList<SiteResourceUrls>> Process(SourceSet sourceSet)
    {
        IList<SiteResourceUrls> result = new List<SiteResourceUrls>();

        if (sourceSet.Resources.Count <= 0)
        {
            return result;
        }

        if (!SitemapId.Equals(SiteDefinition.Current.Name))
        {
            return new List<SiteResourceUrls>(0);
        }

        foreach (var sitemapDataExtractor in Extractors)
        {
            var urls = await sitemapDataExtractor.Extract(sourceSet);

            foreach (var url in urls)
            {
                result.Add(url);
            }
        }

        return result;
    }

    public bool CanProcess(ISiteCatalog forCatalog)
    {
        return forCatalog.SiteDefinition == SiteDefinition;
    }
}