using EPiServer;
using EPiServer.Applications;
using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

/// <summary>
/// This <see cref="ISiteCatalogBlockProvider"/> implementation returns the blocks configured in the "For this site" folder.
/// </summary>
public class DefaultSiteCatalogBlockProvider : SiteCatalogContentProviderBase, ISiteCatalogBlockProvider
{
    private readonly InProcessWebsite _application;

    public DefaultSiteCatalogBlockProvider(
        IContentLoader contentLoader,
        IContentLanguageSettingsHandler contentLanguageSettingsHandler,
        InProcessWebsite application) : base(contentLoader, contentLanguageSettingsHandler)
    {
        _application = application;
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
        var forThisSiteBlockFolder = _application.AssetsRoot;

        var allDescendants = ContentLoader.GetDescendents(forThisSiteBlockFolder);

        var descendants = allDescendants
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
        return _application.AssetsRoot != null 
            ? [_application.AssetsRoot.ID] 
            : [];
    }
}