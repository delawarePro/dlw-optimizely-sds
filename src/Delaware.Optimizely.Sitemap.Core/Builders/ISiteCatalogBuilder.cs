using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;
using Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;
using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.Core.Builders;

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

    /// <summary>
    /// Create split sitemaps by creating <see cref="SitemapLanguageGroup"/> objects with this method.
    /// </summary>
    /// <remarks>
    /// Use this approach to have split sitemaps when having multiple hostnames/languages for a single site.
    /// When no languages are specified, a 'default' group will be created for the <see cref="ISiteCatalog"/> using the languages specified when adding the sitemap catalog.
    /// </remarks>
    /// <param name="languages">The languages to group.</param>
    /// <param name="name">Unique name for this group.</param>
    /// <returns></returns>
    ISiteCatalogBuilder WithLanguageGroup(IReadOnlyCollection<string> languages, string name);
}