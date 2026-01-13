using EPiServer;
using EPiServer.Core;
using EPiServer.ServiceLocation;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

public class DefaultSiteCatalogPageProvider(
    IContentLanguageSettingsHandler contentLanguageSettingsHandler)
    : SiteCatalogContentProviderBase(contentLanguageSettingsHandler), ISiteCatalogPageProvider
{
    public virtual async Task<SiteCatalogItemsResult> GetPages(ContentReference root, string? next, IOperationContext context)
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

        // Gets a batch of id's.
        var descendants = contentLoader
            .GetDescendents(root)
            .ToList() // Materialize first!
            .Skip(skip.GetValueOrDefault())
            .Take(take)
            .ToList();

        // If the first page, add the root itself as well.
        if (string.IsNullOrEmpty(next))
        {
            descendants.Add(root);
        }

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
}