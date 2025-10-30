using Delaware.Optimizely.Sitemap.Core.Client;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;

public interface ISiteCatalogEntryMapper
{
    SiteCatalogEntry Map(string siteName, SiteCatalogItem item, IOperationContext context);
}