using Dlw.Optimizely.Sds.Publishing.ContentProviders;
using Dlw.Optimizely.Sds.Publishing.Mappers;
using Dlw.Optimizely.SDS.Client;
using Dlw.Optimizely.SDS.Shared.Utilities;
using EPiServer.Core;
using EPiServer.Web;

namespace Dlw.Optimizely.Sds.Publishing;

public class SiteCatalog(
    SiteDefinition siteDefinition,
    ISiteCatalogPageProvider pageProvider,
    ISiteCatalogEntryMapper defaultMapper,
    ICollection<ISiteCatalogFilter> pageFilters,
    ICollection<ISiteCatalogFilter> blockFilters,
    IList<ISiteCatalogBlockProvider> blockReferencesProviders)
    : ISiteCatalog
{
    public string SiteId => SiteDefinition.Name;

    public SiteDefinition SiteDefinition { get; } = siteDefinition;

    public virtual async Task<SiteCatalogEntriesResult> GetPageEntries(
        IOperationContext context,
        ContentReference rootPage,
        string? next = null)
    {
        var result = await pageProvider.GetPages(rootPage, next, context);

        var part = result
                .Items
                ?.EmptyWhenNull()
                .Partition(x => pageFilters.All(filter => filter.Filter(x, context)));

        var filtered = part?.Matches.ToList();
        var filteredOut = part?.NonMatches.ToList();

        var entries = filtered != null ? MapItems(filtered, context) : null;
        var entriesFilteredOut = filteredOut != null ? MapItems(filteredOut, context) : null;

        return new SiteCatalogEntriesResult(entries, entriesFilteredOut, result.Next);
    }

    public IList<int> GetBlockRoots()
    {
        var result = new List<int>();

        foreach (var siteCatalogBlockProvider in blockReferencesProviders)
        {
            result.AddRange(siteCatalogBlockProvider.GetBlockRoots());
        }

        return result.Distinct().ToList();
    }

    public virtual async Task<SiteCatalogEntriesResult> GetBlockEntries(IOperationContext context, string? next = null)
    {
        // Skip if specified.
        int? skip = null;
        if (!string.IsNullOrEmpty(next))
        {
            // Throw if 'next' value is provided but could not parse to integer, to avoid infinite loop.
            skip = int.Parse(next);
        }

        var result = new List<SiteCatalogEntry>();
        var resultFilteredOut = new List<SiteCatalogEntry>();

        var currentProvider = blockReferencesProviders.Skip(skip.GetValueOrDefault()).FirstOrDefault();

        if (currentProvider == null)
        {
            return new SiteCatalogEntriesResult(new List<SiteCatalogEntry>(0), new List<SiteCatalogEntry>(0), null);
        }

        SiteCatalogItemsResult? intermediateResult = null;

        do
        {
            intermediateResult = await currentProvider.GetBlocks(intermediateResult?.Next, context);

            // Apply filters.
            var part =
                intermediateResult
                    .Items
                    ?.EmptyWhenNull()
                    .Partition(x => blockFilters.All(filter => filter.Filter(x, context)));

            var filtered = part?.Matches.ToList();
            var filteredOut = part?.NonMatches.ToList();

            if (filteredOut != null)
                resultFilteredOut.AddRange(MapItems(filteredOut, context));

            // Map to SiteCatalogEntry items.
            var entries = filtered?.Any() == true
                ? MapItems(filtered, context)
                : Array.Empty<SiteCatalogEntry>();

            if (entries.Count > 0)
            {
                result.AddRange(entries);
            }

        } while (!string.IsNullOrWhiteSpace(intermediateResult.Next));

        skip = skip + 1 >= blockReferencesProviders.Count ? null : skip.GetValueOrDefault(0) + 1;

        return new SiteCatalogEntriesResult(result, resultFilteredOut, skip?.ToString());
    }

    public virtual async Task<SiteCatalogEntriesResult> GetEntries(IOperationContext context, params IContent[] contentItems)
    {
        var result = await pageProvider.GetContent(contentItems);

        // Apply filtering, contentItems may contain a mix of blocks and pages.
        var part = result
            .Partition(x =>
                x.Content is BlockData && blockFilters.All(filter => filter.Filter(x, context))
                || (x.Content is PageData && pageFilters.All(filter => filter.Filter(x, context))));

        var filtered = part.Matches.ToArray();
        var filteredOut = part.NonMatches.ToList();

        var entries = MapItems(filtered, context);
        var entriesFilteredOut = MapItems(filteredOut, context);

        return new SiteCatalogEntriesResult(entries, entriesFilteredOut, null);
    }

    protected virtual IReadOnlyCollection<SiteCatalogEntry> MapItems(
        IReadOnlyCollection<SiteCatalogItem> contentItems,
        IOperationContext context)
    {
        return contentItems
            .EmptyWhenNull()
            .Select(x => defaultMapper.Map(SiteId, x, context))
            // Exclude items which have no URLs.
            .Where(x => x is { Localized: not null } && x.Localized.Any(l => !string.IsNullOrWhiteSpace(l.Value.Url)))
            .Select(x => x!)
            .ToArray();
    }
}