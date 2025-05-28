using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.SDS.Client;
using Dlw.Optimizely.SDS.Shared.Models;

namespace Dlw.Optimizely.SDS.Embedded.Client;

public interface IEmbeddedSiteCatalogClient : ISiteCatalogClient
{
    IReadOnlyCollection<SiteCatalogEntry>? GetCatalog(string forSiteName, int page = 0, int pageSize = int.MaxValue);

    IReadOnlyCollection<SiteCatalogEntry> GetCatalogUpdates(IOperationContext context, string forSiteName, DateTime sinceUtc);

    int GetCatalogEntryCount(string forSiteName);

    void SaveState(SitemapState state);

    /// <summary>
    /// Gets the current site map state for a given site. Creates a new instance if no instance is found.
    /// </summary>
    /// <param name="forSiteName"></param>
    /// <returns></returns>
    SitemapState GetState(string forSiteName);
}