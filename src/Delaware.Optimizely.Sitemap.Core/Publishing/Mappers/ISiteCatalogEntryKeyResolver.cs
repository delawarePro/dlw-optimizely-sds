using Delaware.Optimizely.Sitemap.Core.Client;
using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;

public interface ISiteCatalogEntryKeyResolver
{
    SiteCatalogEntryKey Resolve(string siteId, IContent content, IOperationContext context);
}