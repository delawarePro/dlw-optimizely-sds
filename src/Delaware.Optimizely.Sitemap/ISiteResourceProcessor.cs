using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.SitemapXml;

namespace Delaware.Optimizely.Sitemap;

public interface ISiteResourceProcessor
{
    Task<IList<SiteResourceUrls>> Process(SourceSet sourceSet);

    bool CanProcess(ISiteCatalog forCatalog);
}