using Delaware.Optimizely.Sitemap.Core.Extensions;
using EPiServer;
using EPiServer.Core;
using EPiServer.ServiceLocation;
using Microsoft.Extensions.DependencyInjection;

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

        var take = context.BatchSizeHint ?? DefaultBatchSize;
        var contentLoader = ServiceLocator.Current.GetRequiredService<IContentLoader>();

        // Use iterative approach to fetch descendants to avoid database connection issues (which can occur with GetDescendants).
        var allDescendants = contentLoader.GetDescendantsIteratively(root, context.Logger);

        var descendants = allDescendants
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