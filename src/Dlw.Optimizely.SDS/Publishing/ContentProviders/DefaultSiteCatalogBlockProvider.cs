using EPiServer;
using EPiServer.Core;
using EPiServer.Web;

namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

/// <summary>
/// This <see cref="ISiteCatalogBlockProvider"/> implementation returns the blocks configured in the "For this site" folder.
/// </summary>
public class DefaultSiteCatalogBlockProvider : SiteCatalogContentProviderBase, ISiteCatalogBlockProvider
{
    private readonly SiteDefinition _siteDefinition;

    public DefaultSiteCatalogBlockProvider(
        IContentLoader contentLoader,
        IContentLanguageSettingsHandler contentLanguageSettingsHandler,
        SiteDefinition siteDefinition) : base(contentLoader, contentLanguageSettingsHandler)
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

        var take = context.BatchSizeHint ?? DefaultBatchSize;

        var forThisSiteBlockFolder = _siteDefinition.SiteAssetsRoot;
        var descendants =
            ContentLoader
                .GetDescendents(forThisSiteBlockFolder)
                .Skip(skip.GetValueOrDefault())
                .Take(take)
                .ToList();

        var items = descendants.Any() ? ContentLoader
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