using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;
using Delaware.Optimizely.Sitemap.Core.Publishing.Filters;
using Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;
using EPiServer;
using EPiServer.Core;
using EPiServer.Core.Routing.Internal;
using EPiServer.Web;
using Microsoft.Extensions.DependencyInjection;

namespace Delaware.Optimizely.Sitemap.Core.Builders;

public class DefaultSiteCatalogBuilder(IServiceProvider serviceProvider, SiteDefinition siteDefinition) : ISiteCatalogBuilder
{
    public const string DefaultLanguageGroupName = "Default";

    private readonly IList<ISiteCatalogFilter> _pageFilters = new List<ISiteCatalogFilter>();
    private readonly IList<ISiteCatalogFilter> _blockFilters = new List<ISiteCatalogFilter>();
    private readonly IList<ISiteCatalogBlockProvider> _blockReferencesProviders = new List<ISiteCatalogBlockProvider>();

    private ISiteCatalogPageProvider? PageProvider { get; set; }
    private ISiteCatalogEntryMapper? DefaultEntryMapper { get; set; }

    private readonly IDictionary<string, IReadOnlyCollection<string>> _languageGroups = new Dictionary<string, IReadOnlyCollection<string>>();

    public void WithDefaults()
    {
        WithDefaultBlocks()
            .WithDefaultFilters()
            .WithDefaultMapping()
            .WithDefaultPageProvider();
    }

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

    public ISiteCatalogBuilder WithCustomMapping(ISiteCatalogEntryMapper customMapper)
    {
        if (DefaultEntryMapper != null)
        {
            throw new Exception($"There already is a mapper registered, of type {DefaultEntryMapper.GetType().Name}.");
        }

        DefaultEntryMapper = customMapper;

        return this;
    }

    public ISiteCatalogBuilder WithPageFilter(Func<SiteCatalogItem, IOperationContext, bool> filter)
    {
        _pageFilters.Add(new LambdaSiteCatalogFilter(filter));

        return this;
    }

    public ISiteCatalogBuilder WithPageFilter(ISiteCatalogFilter siteCatalogFilter)
    {
        _pageFilters.Add(siteCatalogFilter);

        return this;
    }

    public ISiteCatalogBuilder WithBlockFilter(Func<SiteCatalogItem, IOperationContext, bool> filter)
    {
        _blockFilters.Add(new LambdaSiteCatalogFilter(filter));

        return this;
    }

    public ISiteCatalogBuilder WithDefaultFilters()
    {
        return
            WithPageFilter((x, _) => x.Content is not IExcludeFromSitemap)
                .WithPageFilter((x, _) => x.Content is PageData)
                .WithPageFilter(new HasAccessSiteCatalogFilter())
                .WithBlockFilter((x, _) => x.Content is not MediaData);
    }

    public ISiteCatalogBuilder WithDefaultBlocks()
    {
        var contentLoader = serviceProvider.GetRequiredService<IContentLoader>();
        var contentLanguageSettingsHandler = serviceProvider.GetRequiredService<IContentLanguageSettingsHandler>();

        _blockReferencesProviders.Add(new DefaultSiteCatalogBlockProvider(contentLoader, contentLanguageSettingsHandler, siteDefinition));

        return this;
    }

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

    public ISiteCatalogBuilder WithDefaultPageProvider()
    {
        if (PageProvider != null)
        {
            throw new Exception($"There already is a page provider registered, of type {PageProvider.GetType().Name}.");
        }

        PageProvider = serviceProvider.GetRequiredService<ISiteCatalogPageProvider>();
        return this;
    }

    public ISiteCatalogBuilder WithPageProvider(ISiteCatalogPageProvider pageProvider)
    {
        if (PageProvider != null)
        {
            throw new Exception($"There already is a page provider registered, of type {PageProvider.GetType().Name}.");
        }

        PageProvider = pageProvider ?? throw new ArgumentNullException(nameof(pageProvider), "Page provider cannot be null.");
        return this;
    }

    public ISiteCatalogBuilder WithLanguageGroup(IReadOnlyCollection<string> languages, string name = DefaultLanguageGroupName)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new ArgumentException("Specify a language group name.", nameof(name));
    
        if(_languageGroups.ContainsKey(name))
            throw new Exception($"A language group with the name '{name}' already exists.");

        _languageGroups[name] = languages.ToArray();

        return this;
    }

    public ISiteCatalog Build()
    {
        var pageProvider = PageProvider ?? throw new NullReferenceException($"No page provider registered for '{siteDefinition.Name}' site catalog.");
        var defaultMapper = DefaultEntryMapper ?? throw new NullReferenceException($"No default mapping provided for '{siteDefinition.Name}' site catalog.");

        return new SiteCatalog(siteDefinition, pageProvider, defaultMapper, _pageFilters, _blockFilters, _blockReferencesProviders)
        {
            LanguageGroups = _languageGroups
        };
    }
}