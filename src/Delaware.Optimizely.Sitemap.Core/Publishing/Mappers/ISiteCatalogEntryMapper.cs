using Delaware.Optimizely.Sitemap.Core.Client;
using EPiServer.Applications;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;

public interface ISiteCatalogEntryMapper
{
    SiteCatalogEntry Map(string siteName, SiteCatalogItem item, InProcessWebsite application, IOperationContext context);
}