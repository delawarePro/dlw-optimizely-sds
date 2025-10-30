using Delaware.Optimizely.Sitemap.Core.Publishing;

namespace Delaware.Optimizely.Sitemap.Core.Client;

public interface ISiteCatalogClient
{
    void UpdateCatalog(string siteId, SiteCatalogEntriesResult entriesResult);
}