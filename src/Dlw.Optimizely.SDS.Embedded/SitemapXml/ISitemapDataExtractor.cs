using Dlw.Optimizely.Sds;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml;

public interface ISitemapDataExtractor
{
    Task<IReadOnlyList<SiteResourceUrls>> Extract(IReadOnlyCollection<ISiteResource> resources);
}