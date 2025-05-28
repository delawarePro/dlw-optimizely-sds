using Dlw.Optimizely.Sds;
using Dlw.Optimizely.SDS.Embedded.SitemapXml;
using Dlw.Optimizely.Sds.Publishing;

namespace Dlw.Optimizely.SDS.Embedded;

public interface ISiteResourceProcessor
{
    Task<IList<SiteResourceUrls>> Process(SourceSet sourceSet);

    bool CanProcess(ISiteCatalog forCatalog);
}