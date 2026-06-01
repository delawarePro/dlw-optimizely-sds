using EPiServer;
using EPiServer.Core;
using EPiServer.Web;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

/// <summary>
/// This <see cref="ISiteCatalogBlockProvider"/> implementation returns the blocks configured in the "For this site" folder.
/// </summary>
public class DefaultSiteCatalogBlockProvider : SiteCatalogContentProviderBase, ISiteCatalogBlockProvider
{
    private readonly SiteDefinition _siteDefinition;
    private readonly ILogger<DefaultSiteCatalogBlockProvider> _logger;

    public DefaultSiteCatalogBlockProvider(
        IContentLoader contentLoader,
        IContentLanguageSettingsHandler contentLanguageSettingsHandler,
        SiteDefinition siteDefinition,
        ILogger<DefaultSiteCatalogBlockProvider> logger) : base(contentLoader, contentLanguageSettingsHandler)
    {
        _siteDefinition = siteDefinition;
        _logger = logger;
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
        var allDescendants = ContentLoader.GetDescendents(forThisSiteBlockFolder);

        var descendants = allDescendants
            .Skip(skip.GetValueOrDefault())
            .Take(take)
            .ToList();

        IEnumerable<IContent>? items = null;
        if (descendants.Any())
        {
            try
            {
                items = ContentLoader.GetItems(descendants, LanguageSelector.MasterLanguage());
            }
            catch (Exception ex)
            {
                _logger.LogWarning(ex, "GetItems failed for batch, falling back to per-item loading to skip ghost items.");
                items = descendants
                    .Select(reference =>
                    {
                        try
                        {
                            return ContentLoader.Get<IContent>(reference, LanguageSelector.MasterLanguage());
                        }
                        catch (Exception itemEx)
                        {
                            _logger.LogWarning(itemEx, "Skipping ghost or unresolvable content reference {ContentReference}.", reference);
                            return null;
                        }
                    })
                    .Where(x => x != null)
                    .Select(x => x!);
            }
        }

        var blocks = items != null
            ? await GetContent(items.ToArray())
            : null;

        // Skip previous count + current page count for next iteration.
        // If there are no more results, we're at the end.
        skip = descendants.Any() ? (skip ?? 0) + descendants.Count : null;

        return new SiteCatalogItemsResult(blocks, skip?.ToString());
    }

    public IList<int> GetBlockRoots()
    {
        return new List<int>(1) { _siteDefinition.SiteAssetsRoot.ID };
    }
}