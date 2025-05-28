using EPiServer;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

/// <summary>
/// This <see cref="ISiteCatalogBlockProvider"/> allows to register one or more block roots to be iterated over when publishing sitemaps.
/// </summary>
public class ConfigurableSiteCatalogBlockRootProvider : SiteCatalogContentProviderBase, ISiteCatalogBlockProvider
{
    private readonly IList<ContentReference> _blockRoots;

    public ConfigurableSiteCatalogBlockRootProvider(IContentLoader contentLoader, IList<ContentReference> blockRoots)
        : base(contentLoader)
    {
        _blockRoots = blockRoots;
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

        var root = _blockRoots
            .Skip(skip.GetValueOrDefault())
            .FirstOrDefault();

        if (root == null)
        {
            return new SiteCatalogItemsResult(new List<SiteCatalogItem>(0), null);
        }

        // Gets a batch of id's.
        var descendants = ContentLoader
            .GetDescendents(root)
            .Take(take)
            .ToList();

        var items = descendants.Any() ? ContentLoader
                .GetItems(descendants, LanguageSelector.MasterLanguage())
            : null;

        var pages = items != null
            ? await GetContent(items.ToArray())
            : null;

        // Note! Skip is the number of block roots already processed.
        skip = skip + 1 >= _blockRoots.Count ? null : skip.GetValueOrDefault(0) + 1;

        return new SiteCatalogItemsResult(pages, skip?.ToString());
    }

    public IList<int> GetBlockRoots()
    {
        return _blockRoots.Select(c => c.ID).ToList();
    }
}