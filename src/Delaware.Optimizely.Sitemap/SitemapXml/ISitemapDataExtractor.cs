using Delaware.Optimizely.Sitemap.Core;

namespace Delaware.Optimizely.Sitemap.SitemapXml;

public interface ISitemapDataExtractor
{
    Task<IReadOnlyList<SiteResourceUrls>> Extract(SourceSet sourceSet);
}