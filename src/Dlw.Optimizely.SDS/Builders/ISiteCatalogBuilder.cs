using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.Sds.Publishing.ContentProviders;
using Dlw.Optimizely.Sds.Publishing.Mappers;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Builders;

public interface ISiteCatalogBuilder
{
    /// <summary>
    /// Configure only using the defaults.
    /// </summary>
    void WithDefaults();

    /// <summary>
    /// Use a default page data mapper for a single shard.
    /// </summary>
    ISiteCatalogBuilder WithDefaultMapping();

    /// <summary>
    /// Registers a custom <see cref="ISiteCatalogEntryMapper"/> implementation instead of the default <see cref="DefaultSiteCatalogEntryMapper"/>.
    /// </summary>
    ISiteCatalogBuilder WithCustomMapping(ISiteCatalogEntryMapper customEntryMapper);

    /// <summary>
    /// Add a filter to include/exclude pages from site catalog.
    /// Content will be evaluated for each filter (AND behaviour).
    /// </summary>
    ISiteCatalogBuilder WithPageFilter(Func<SiteCatalogItem, IOperationContext, bool> filter);

    /// <summary>
    /// Add a filter to include/exclude pages from site catalog.
    /// Content will be evaluated for each filter (AND behaviour).
    /// </summary>
    ISiteCatalogBuilder WithPageFilter(ISiteCatalogFilter siteCatalogFilter);

    /// <summary>
    /// Add a filter to include/exclude blocks from site catalog.
    /// Content will be evaluated for each filter (AND behaviour).
    /// </summary>
    ISiteCatalogBuilder WithBlockFilter(Func<SiteCatalogItem, IOperationContext, bool> filter);

    /// <summary>
    /// Adds the default recommended filter options.
    /// </summary>
    /// <returns></returns>
    ISiteCatalogBuilder WithDefaultFilters();

    /// <summary>
    /// Include default block handling setup. Searches the asset folder for a site for blocks to include.
    /// </summary>
    /// <returns></returns>
    ISiteCatalogBuilder WithDefaultBlocks();

    /// <summary>
    /// Specify which roots to search blocks for a site.
    /// </summary>
    /// <param name="blockRoots"></param>
    /// <returns></returns>
    ISiteCatalogBuilder WithBlockRoots(IList<ContentReference>? blockRoots);

    /// <summary>
    /// Adds the default <see cref="DefaultSiteCatalogPageProvider"/>.
    /// </summary>
    ISiteCatalogBuilder WithDefaultPageProvider();

    /// <summary>
    /// Registers a custom <see cref="ISiteCatalogPageProvider"/> implementation instead of the default <see cref="DefaultSiteCatalogPageProvider"/>.
    /// </summary>
    ISiteCatalogBuilder WithPageProvider(ISiteCatalogPageProvider pageProvider);
}