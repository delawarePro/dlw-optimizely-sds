using Dlw.Optimizely.Sds.Publishing;

namespace Dlw.Optimizely.SDS.Client;

public interface ISiteCatalogClient
{
    void UpdateCatalog(string siteId, SiteCatalogEntriesResult entriesResult);
}