using EPiServer;
using EPiServer.Core;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

public class DefaultSiteCatalogPageProvider(
    IContentLoader contentLoader,
    IContentLanguageSettingsHandler contentLanguageSettingsHandler,
    ILogger<DefaultSiteCatalogPageProvider> logger)
    : SiteCatalogContentProviderBase(contentLoader, contentLanguageSettingsHandler), ISiteCatalogPageProvider
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

        var allDescendants = ContentLoader.GetDescendents(root).ToList();

        var descendants = allDescendants
            .Skip(skip.GetValueOrDefault())
            .Take(take)
            .ToList();

        // If the first page, add the root itself as well.
        if (string.IsNullOrEmpty(next))
        {
            descendants.Add(root);
        }

        IEnumerable<IContent>? items = null;
        if (descendants.Any())
        {
            try
            {
                items = ContentLoader.GetItems(descendants, LanguageSelector.MasterLanguage());
            }
            catch (Exception ex)
            {
                logger.LogWarning(ex, "GetItems failed for batch, falling back to per-item loading to skip ghost items.");
                items = descendants
                    .Select(reference =>
                    {
                        try
                        {
                            return ContentLoader.Get<IContent>(reference, LanguageSelector.MasterLanguage());
                        }
                        catch (Exception itemEx)
                        {
                            logger.LogWarning(itemEx, "Skipping ghost or unresolvable content reference {ContentReference}.", reference);
                            return null;
                        }
                    })
                    .Where(x => x != null)
                    .Select(x => x!);
            }
        }

        var pages = items != null
            ? await GetContent(items.ToArray())
            : null;

        // Skip previous count + current page count for next iteration.
        // If there are no more results, we're at the end.
        skip = descendants.Any() ? (skip ?? 0) + descendants.Count : null;

        return new SiteCatalogItemsResult(pages, skip?.ToString());
    }
}