using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;
using Delaware.Optimizely.Sitemap.Core.Publishing.Filters;
using Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;
using Delaware.Optimizely.Sitemap.Shared.Models;
using EPiServer;
using EPiServer.Core;
using EPiServer.Core.Routing.Internal;
using EPiServer.Web;
using Microsoft.Extensions.DependencyInjection;

namespace Delaware.Optimizely.Sitemap.Core.Builders;

/// <summary>
/// Default implementation for <see cref="ISiteCatalogBuilder"/>.
/// </summary>
/// <param name="serviceProvider"></param>
/// <param name="siteDefinition"></param>
/// <param name="languages"></param>
public class DefaultSiteCatalogBuilder(
    IServiceProvider serviceProvider,
    SiteDefinition siteDefinition,
    string[]? languages) : ISiteCatalogBuilder
{
    public const string DefaultLanguageGroupName = "Default";

    private readonly IList<ISiteCatalogFilter> _pageFilters = new List<ISiteCatalogFilter>();
    private readonly IList<ISiteCatalogFilter> _blockFilters = new List<ISiteCatalogFilter>();
    private readonly IList<ISiteCatalogBlockProvider> _blockReferencesProviders = new List<ISiteCatalogBlockProvider>();

    private ISiteCatalogPageProvider? PageProvider { get; set; }
    private ISiteCatalogEntryMapper? DefaultEntryMapper { get; set; }

    private readonly IList<SitemapLanguageGroup> _languageGroups = new List<SitemapLanguageGroup>();

    /// <inheritdoc/>
    public void WithDefaults()
    {
        WithDefaultBlocks()
            .WithDefaultFilters()
            .WithDefaultMapping()
            .WithDefaultPageProvider();
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithDefaultMapping()
    {
        if (DefaultEntryMapper != null)
        {
            throw new Exception($"There already is a mapper registered, of type {DefaultEntryMapper.GetType().Name}.");
        }

        var publishStateAssessor = serviceProvider.GetRequiredService<IPublishedStateAssessor>();
        var entryKeyResolver = new DefaultEntryKeyResolver();
        var contentUrlGenerator = serviceProvider.GetRequiredService<IContentUrlGenerator>();
        var contentLoader = serviceProvider.GetRequiredService<IContentLoader>();

        DefaultEntryMapper = new DefaultSiteCatalogEntryMapper(contentLoader, publishStateAssessor, entryKeyResolver, contentUrlGenerator);

        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithCustomMapping(ISiteCatalogEntryMapper customMapper)
    {
        if (DefaultEntryMapper != null)
        {
            throw new Exception($"There already is a mapper registered, of type {DefaultEntryMapper.GetType().Name}.");
        }

        DefaultEntryMapper = customMapper;

        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithPageFilter(Func<SiteCatalogItem, IOperationContext, bool> filter)
    {
        _pageFilters.Add(new LambdaSiteCatalogFilter(filter));

        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithPageFilter(ISiteCatalogFilter siteCatalogFilter)
    {
        _pageFilters.Add(siteCatalogFilter);

        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithBlockFilter(Func<SiteCatalogItem, IOperationContext, bool> filter)
    {
        _blockFilters.Add(new LambdaSiteCatalogFilter(filter));

        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithDefaultFilters()
    {
        return
            WithPageFilter((x, _) => x.Content is not IExcludeFromSitemap)
                .WithPageFilter((x, _) => x.Content is PageData)
                .WithPageFilter(new HasAccessSiteCatalogFilter())
                .WithBlockFilter((x, _) => x.Content is not MediaData);
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithDefaultBlocks()
    {
        var contentLoader = serviceProvider.GetRequiredService<IContentLoader>();
        var contentLanguageSettingsHandler = serviceProvider.GetRequiredService<IContentLanguageSettingsHandler>();

        _blockReferencesProviders.Add(new DefaultSiteCatalogBlockProvider(contentLoader, contentLanguageSettingsHandler, siteDefinition));

        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithBlockRoots(IList<ContentReference>? blockRoots)
    {
        if (blockRoots is not { Count: > 0 })
        {
            return this;
        }

        var contentLoader = serviceProvider.GetRequiredService<IContentLoader>();
        var contentLanguageSettingsHandler = serviceProvider.GetRequiredService<IContentLanguageSettingsHandler>();
        var provider = new ConfigurableSiteCatalogBlockRootProvider(contentLoader, contentLanguageSettingsHandler, blockRoots);

        _blockReferencesProviders.Add(provider);

        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithDefaultPageProvider()
    {
        if (PageProvider != null)
        {
            throw new Exception($"There already is a page provider registered, of type {PageProvider.GetType().Name}.");
        }

        PageProvider = serviceProvider.GetRequiredService<ISiteCatalogPageProvider>();
        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithPageProvider(ISiteCatalogPageProvider pageProvider)
    {
        if (PageProvider != null)
        {
            throw new Exception($"There already is a page provider registered, of type {PageProvider.GetType().Name}.");
        }

        PageProvider = pageProvider ?? throw new ArgumentNullException(nameof(pageProvider), "Page provider cannot be null.");
        return this;
    }

    /// <inheritdoc/>
    public ISiteCatalogBuilder WithLanguageGroup(IReadOnlyCollection<string> languages, string name = DefaultLanguageGroupName)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new ArgumentException("Specify a language group name.", nameof(name));

        var languageGroupKey = new SitemapLanguageGroupKey(name);
        if (_languageGroups.Any(lg => lg.Key.Value.Equals(languageGroupKey, StringComparison.InvariantCultureIgnoreCase)))
            throw new Exception($"A language group with the name '{name}' already exists.");

        _languageGroups.Add(new SitemapLanguageGroup(languageGroupKey, languages));

        return this;
    }

    /// <summary>
    /// Builds and returns a configured site catalog instance for the current site definition.
    /// </summary>
    /// <returns>An <see cref="ISiteCatalog"/> instance representing the site catalog for the configured site definition.</returns>
    /// <exception cref="NullReferenceException">Thrown if no page provider or default entry mapper is registered for the site catalog.</exception>
    public ISiteCatalog Build()
    {
        var pageProvider = PageProvider ?? throw new NullReferenceException($"No page provider registered for '{siteDefinition.Name}' site catalog.");
        var defaultMapper = DefaultEntryMapper ?? throw new NullReferenceException($"No default mapping provided for '{siteDefinition.Name}' site catalog.");

        // If there are language groups configured, use those.
        // Otherwise, create a 'Default' language group containing all languages for site.
        var languageGroups = _languageGroups.Any()
            ? _languageGroups
            : new List<SitemapLanguageGroup>
            {
                new(new SitemapLanguageGroupKey(DefaultLanguageGroupName), languages ?? [])
            };

        return new SiteCatalog(siteDefinition, pageProvider, defaultMapper, _pageFilters, _blockFilters, _blockReferencesProviders)
        {
            LanguageGroups = (IReadOnlyCollection<SitemapLanguageGroup>)languageGroups
        };
    }
}