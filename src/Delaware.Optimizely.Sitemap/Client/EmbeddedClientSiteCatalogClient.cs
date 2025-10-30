using Delaware.Optimizely.Sitemap.Core.Client;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Shared.Models;
using EPiServer.Core;
using EPiServer.Data;
using EPiServer.Data.Dynamic;

namespace Delaware.Optimizely.Sitemap.Client;

public class EmbeddedClientSiteCatalogClient : IEmbeddedSiteCatalogClient
{
    public void UpdateCatalog(string siteId, SiteCatalogEntriesResult entriesResult)
    {
        var entities = entriesResult
            .Entries
            ?.GroupBy(entry => new { entry.SiteName, entry.SourceId })
            .Select(group => group.Aggregate((a, b) => a.Merge(b)))
            .ToArray() ?? [];

        foreach (var entity in entities)
        {
            var existing = GetExisting(entity);

            existing?.Merge(entity);

            _ = DynamicDataStoreFactory.Instance.GetStore(typeof(SiteCatalogEntry)).Save(existing ?? entity);
        }

        var filteredOut = entriesResult.FilteredOut ?? [];
        // Filter settings can be redefined between deployments. Ensure filtered out content is not available in the store.
        foreach (var siteCatalogItem in filteredOut)
        {
            var existing = GetExisting(siteCatalogItem);

            if (existing != null)
            {
                DynamicDataStoreFactory.Instance.GetStore(typeof(SiteCatalogEntry)).Delete(existing);
            }
        }
    }

    public IReadOnlyCollection<SiteCatalogEntry>? GetCatalog(string forSiteName, int page = 0, int pageSize = int.MaxValue)
    {
        return
            DynamicDataStoreFactory.Instance
                .GetStore(typeof(SiteCatalogEntry))
                .Items<SiteCatalogEntry>()
                .Where(i => i.SiteName == forSiteName)
                .Skip(page * pageSize)
                .Take(pageSize)
                .ToArray();
    }

    public IReadOnlyCollection<SiteCatalogEntry> GetCatalogUpdates(IOperationContext context, string forSiteName,
        DateTime time)
    {
        return
            DynamicDataStoreFactory.Instance
                .GetStore(typeof(SiteCatalogEntry))
                .Items<SiteCatalogEntry>()
                .Where(i => i.SiteName == forSiteName && i.Modified >= time)
                .ToArray();
    }

    public SitemapState GetState(string forSiteName)
    {
        var existing =
            DynamicDataStoreFactory.Instance
                .GetStore(typeof(SitemapState))
                .Items<SitemapState>()
                .FirstOrDefault(i => i.SiteName == forSiteName);

        return existing ?? new SitemapState { Id = Identity.NewIdentity(), SiteName = forSiteName };
    }

    public SiteCatalogEntry? GetEntry(IContent forContent)
    {
        return
            DynamicDataStoreFactory.Instance
                .GetStore(typeof(SiteCatalogEntry))
                .Items<SiteCatalogEntry>()
                .FirstOrDefault(sce =>
                    sce.SourceId!.Equals(forContent.ContentLink.ToReferenceWithoutVersion().ToString()));
    }

    public int GetCatalogEntryCount(string forSiteName)
    {
        return
            DynamicDataStoreFactory.Instance
                .GetStore(typeof(SiteCatalogEntry))
                .Items<SiteCatalogEntry>()
                .Count(i => i.SiteName == forSiteName);
    }

    public void SaveState(SitemapState state)
    {
        DynamicDataStoreFactory.Instance
                .GetStore(typeof(SitemapState))
                .Save(state);
    }

    #region Helper Methods

    private SiteCatalogEntry? GetExisting(SiteCatalogEntry entity)
    {
        return DynamicDataStoreFactory.Instance.GetStore(typeof(SiteCatalogEntry))
            .Items<SiteCatalogEntry>()
            .SingleOrDefault(sce =>
                sce.SourceId!.Equals(entity.SourceId) && sce.SiteName!.Equals(entity.SiteName));
    }


    #endregion
}