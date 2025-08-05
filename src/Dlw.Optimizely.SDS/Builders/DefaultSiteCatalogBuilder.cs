using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.Sds.Publishing.ContentProviders;
using Dlw.Optimizely.Sds.Publishing.Filters;
using Dlw.Optimizely.Sds.Publishing.Mappers;
using EPiServer;
using EPiServer.Core;
using EPiServer.Core.Routing.Internal;
using EPiServer.Web;
using Microsoft.Extensions.DependencyInjection;

namespace Dlw.Optimizely.Sds.Builders;

public class DefaultSiteCatalogBuilder : ISiteCatalogBuilder
{
    private readonly IServiceProvider _serviceProvider;
    private readonly SiteDefinition _siteDefinition;
    private readonly IList<ISiteCatalogFilter> _pageFilters = new List<ISiteCatalogFilter>();
    private readonly IList<ISiteCatalogFilter> _blockFilters = new List<ISiteCatalogFilter>();
    private readonly IList<ISiteCatalogBlockProvider> _blockReferencesProviders = new List<ISiteCatalogBlockProvider>();

    private ISiteCatalogPageProvider? PageProvider { get; set; }
    private ISiteCatalogEntryMapper? DefaultEntryMapper { get; set; }

    public DefaultSiteCatalogBuilder(IServiceProvider serviceProvider, SiteDefinition siteDefinition)
    {
        _serviceProvider = serviceProvider;
        _siteDefinition = siteDefinition;
    }

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

        var publishStateAssessor = _serviceProvider.GetRequiredService<IPublishedStateAssessor>();
        var entryKeyResolver = new DefaultEntryKeyResolver();
        var contentUrlGenerator = _serviceProvider.GetRequiredService<IContentUrlGenerator>();
        var contentLoader = _serviceProvider.GetRequiredService<IContentLoader>();

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
            WithPageFilter((x, _) => x.Content is not IExcludeFromSds)
                .WithPageFilter((x, _) => x.Content is PageData)
                .WithPageFilter(new HasAccessSiteCatalogFilter())
                .WithBlockFilter((x, _) => x.Content is not MediaData);
    }

    public ISiteCatalogBuilder WithDefaultBlocks()
    {
        var contentLoader = _serviceProvider.GetRequiredService<IContentLoader>();
        var contentLanguageSettingsHandler = _serviceProvider.GetRequiredService<IContentLanguageSettingsHandler>();

        _blockReferencesProviders.Add(new DefaultSiteCatalogBlockProvider(contentLoader, contentLanguageSettingsHandler, _siteDefinition));

        return this;
    }

    public ISiteCatalogBuilder WithBlockRoots(IList<ContentReference>? blockRoots)
    {
        if (blockRoots is not { Count: > 0 })
        {
            return this;
        }

        var contentLoader = _serviceProvider.GetRequiredService<IContentLoader>();
        var contentLanguageSettingsHandler = _serviceProvider.GetRequiredService<IContentLanguageSettingsHandler>();
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

        PageProvider = _serviceProvider.GetRequiredService<ISiteCatalogPageProvider>();
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

    public ISiteCatalog Build()
    {
        var pageProvider = PageProvider ?? throw new NullReferenceException($"No page provider registered for '{_siteDefinition.Name}' site catalog.");
        var defaultMapper = DefaultEntryMapper ?? throw new NullReferenceException($"No default mapping provided for '{_siteDefinition.Name}' site catalog.");

        return new SiteCatalog(_siteDefinition, pageProvider, defaultMapper, _pageFilters, _blockFilters, _blockReferencesProviders);
    }
}