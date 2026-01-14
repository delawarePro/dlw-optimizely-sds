using Delaware.Optimizely.Sitemap.Core.Extensions;
using EPiServer;
using EPiServer.Core;
using EPiServer.ServiceLocation;
using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

/// <summary>
/// This <see cref="ISiteCatalogBlockProvider"/> implementation returns the blocks configured in the "For this site" folder.
/// </summary>
public class DefaultSiteCatalogBlockProvider : SiteCatalogContentProviderBase, ISiteCatalogBlockProvider
{
    private readonly SiteDefinition _siteDefinition;

    public DefaultSiteCatalogBlockProvider(
        IContentLanguageSettingsHandler contentLanguageSettingsHandler,
        SiteDefinition siteDefinition) : base( contentLanguageSettingsHandler)
    {
        _siteDefinition = siteDefinition;
    }

    public async Task<SiteCatalogItemsResult> GetBlocks(string? next, IOperationContext context)
    {
        // Skip if specified.
        int? skip = null;
        if (!string.IsNullOrEmpty(next))
        {
            // Throw if 'next' value is provided but could not parse to integer, to avoid infinite loop.
            skip = int.Parse(next);
        }

        var contentLoader = ServiceLocator.Current.GetInstance<IContentLoader>();
        var take = context.BatchSizeHint ?? DefaultBatchSize;

        var forThisSiteBlockFolder = _siteDefinition.SiteAssetsRoot;

        // Use iterative approach to fetch descendants to avoid database connection issues (which can occur with GetDescendants).
        var allDescendants = contentLoader.GetDescendantsIteratively(forThisSiteBlockFolder, context.Logger);

        var descendants = allDescendants
            .Skip(skip.GetValueOrDefault())
            .Take(take)
            .ToList();

        var items = descendants.Any() ? contentLoader
                .GetItems(descendants, LanguageSelector.MasterLanguage())
            : null;

        var pages = items != null
            ? await GetContent(items.ToArray())
            : null;

        // Skip previous count + current page count for next iteration.
        // If there are no more results, we're at the end.
        skip = descendants.Any() ? (skip ?? 0) + descendants.Count : null;

        return new SiteCatalogItemsResult(pages, skip?.ToString());
    }

    public IList<int> GetBlockRoots()
    {
        return new List<int>(1) { _siteDefinition.SiteAssetsRoot.ID };
    }
}