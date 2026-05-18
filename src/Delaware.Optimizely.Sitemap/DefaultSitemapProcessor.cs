using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.SitemapXml;
using EPiServer.Applications;

namespace Delaware.Optimizely.Sitemap;

public class DefaultSitemapProcessor : ISiteResourceProcessor
{
    /// <summary>
    /// Logical sitemap identifier, this has nothing to do with file names.
    /// </summary>
    public string SitemapId => Application.Name;

    public InProcessWebsite Application { get; }

    public IReadOnlyCollection<ISitemapDataExtractor> Extractors { get; private set; }

    public string? SitemapUrl { get; }

    public DefaultSitemapProcessor(
        InProcessWebsite application,
        IReadOnlyCollection<ISitemapDataExtractor> extractors,
        string? sitemapUrl = null)
    {
        if (string.IsNullOrWhiteSpace(application.Name))
            throw new ArgumentException($"Could not determine site catalog ID for application {application.Name}");

        Application = application;
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

        if (!SitemapId.Equals(Application.Name))
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
        return forCatalog.Application == Application;
    }
}