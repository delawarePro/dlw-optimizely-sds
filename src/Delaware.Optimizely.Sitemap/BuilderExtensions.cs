using Delaware.Optimizely.Sitemap.Client;
using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Core.Builders;
using Delaware.Optimizely.Sitemap.Core.Client;
using Delaware.Optimizely.Sitemap.Middleware;
using Delaware.Optimizely.Sitemap.Shared.Models;
using Delaware.Optimizely.Sitemap.SitemapXml;
using Delaware.Optimizely.Sitemap.SitemapXml.DynamicContent;
using Delaware.Optimizely.Sitemap.SitemapXml.Multiply;
using Delaware.Optimizely.Sitemap.SitemapXml.Output;
using Delaware.Optimizely.Sitemap.SitemapXml.Storage;
using EPiServer.Core;
using EPiServer.Data.Dynamic;
using EPiServer.Web;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace Delaware.Optimizely.Sitemap;

public static class BuilderExtensions
{
    #region Defaults

    /// <summary>
    /// Adds the default sitemap processing: both publishing and sitemap serving.
    /// This calls both <see cref="AddSitemapServing"/> and <see cref="Sitemap.BuilderExtensions.AddSitemapPublishing"/>.
    /// Call both these methods manually instead, to have more control (or if sitemap serving is not required).
    /// </summary>
    public static IServiceCollection AddSitemap(
        this IServiceCollection services,
        IConfiguration configuration,
        Action<ISiteCatalogsBuilder>? configure = null)
    {
        services.AddSitemapPublishing(configuration, configure);
        services.AddSitemapServing(configuration);

        return services;
    }

    /// <summary>
    /// Configures the default sitemap: both publishing and sitemap serving.
    /// This calls both <see cref="ConfigureSitemapServing"/> and <see cref="Sitemap.BuilderExtensions.AddSitemapPublishing"/>.
    /// Call both these methods manually instead, to have more control (or if sitemap serving is not required).
    /// </summary>
    public static IApplicationBuilder ConfigureSitemap(this IApplicationBuilder app)
    {
        app.ConfigureSitemapPublishing();
        app.ConfigureSitemapServing();

        return app;
    }

    #endregion Defaults

    #region Specific methods

    /// <summary>
    /// This method adds the serving of the sitemap XML files as the sitemap for configured site catalogs.
    /// Use <see cref="AddSitemap"/> instead, if you don't require anything but the default behavior.
    /// </summary>
    public static IServiceCollection AddSitemapServing(
        this IServiceCollection services,
        IConfiguration configuration,
        Action<ISiteCatalogsBuilder>? configure = null)
    {
        services
            .AddSingleton<ISitemapXmlStorageProvider, DefaultSitemapXmlStorageProvider>()
            .AddSingleton<ISitemapGeneratorService, DefaultSitemapGeneratorService>()
            .AddSingleton<ISitemapXmlWriter, DefaultSitemapXmlWriter>()
            .AddSingleton<ISitemapProcessorRegistry, SitemapProcessorRegistry>()
            .AddTransient<IEmbeddedSiteCatalogClient, EmbeddedClientSiteCatalogClient>()
            .AddTransient<ISiteCatalogClient, EmbeddedClientSiteCatalogClient>() // Replaces noop-client.
            .Configure<EmbeddedSitemapOptions>(configuration.GetSection("Dlw:Sitemaps"));

        return services;
    }

    /// <summary>
    /// Configures the serving of the sitemap XML files for configured site catalogs.
    /// </summary>
    public static IApplicationBuilder ConfigureSitemapServing(this IApplicationBuilder applicationBuilder)
    {
        var parameters = new StoreDefinitionParameters();
        parameters.IndexNames.Add(nameof(SiteCatalogEntry.SiteName));

        DynamicDataStoreFactory.Instance.CreateStore(typeof(SiteCatalogEntry), parameters);
        DynamicDataStoreFactory.Instance.CreateStore(typeof(SitemapState));

        applicationBuilder.MapSitemapEndpoints();

        return applicationBuilder;
    }

    /// <summary>
    /// Setup catalog publishing and XML sitemap serving for a <param name="siteDefinition">site</param>
    /// in <param name="languages">an array of site languages</param>.
    /// This is the default method to add a catalog for a <param name="siteDefinition">site</param>
    /// which calls <see cref="Sitemap.BuilderExtensions.AddSitemapCatalog"/> and <see cref="WithEmbeddedSitemap"/> internally.
    /// </summary>
    /// <param name="siteDefinition">The site definition to create a catalog for.</param>
    /// <param name="languages">*All* site's languages the sitemap needs to be published and served in.</param>
    public static IServiceProvider AddEmbeddedSitemapCatalog(
        this IServiceProvider serviceProvider,
        SiteDefinition siteDefinition,
        string[] languages,
        Action<ISiteCatalogBuilder>? configure = null)
    {
        serviceProvider
            .AddSitemapCatalog(siteDefinition, languages, configure)
            .WithEmbeddedSitemap(siteDefinition, languages);
        
        return serviceProvider;
    }

    /// <summary>
    /// Enable the sitemap serving for a given <param name="site">site</param> in the specified <param name="languages">languages</param>.
    /// </summary>
    /// <param name="site">The <param name="site">site</param> to enable embedded sitemap serving for.</param>
    /// <param name="languages">The <param name="languages">languages</param> to serve the sitemap in.</param>
    /// <exception cref="InvalidOperationException">Make sure not to add the same <param name="site">site</param> twice!</exception>
    public static IServiceProvider WithEmbeddedSitemap(
        this IServiceProvider serviceProvider,
        SiteDefinition site, 
        string[] languages)
    {
        var registry = serviceProvider.GetRequiredService<ISitemapProcessorRegistry>();
        var contentLanguageSettingsHandler = serviceProvider.GetRequiredService<IContentLanguageSettingsHandler>();

        if (registry.Processors.OfType<DefaultSitemapProcessor>().Any(x => string.Equals(x.SitemapId, site.Name)))
        {
            throw new InvalidOperationException($"Sitemap with name '{site.Name}' already exists in pipeline.");
        }

        // Resolve custom implementations for IDynamicContentRootProcessor - if any.
        var dynamicContentRootProcessors = serviceProvider.GetServices<IDynamicContentRootProcessor>().ToList();

        var config = new SitemapDataExtractorConfig()
            .WithMultiplier(new AllLanguagesMultiplier(languages));

        var configuredSitemapDataExtractor = new ConfiguredSitemapDataExtractor(contentLanguageSettingsHandler, config);
        var dynamicContentSitemapExtractor = new DynamicContentSitemapExtractor(dynamicContentRootProcessors);
        var sitemapProcessor = 
            new DefaultSitemapProcessor(site, [configuredSitemapDataExtractor, dynamicContentSitemapExtractor]);

        registry.Processors.Add(sitemapProcessor);

        return serviceProvider;
    }

    /// <summary>
    /// Enables the endpoints for serving the sitemap XML content.
    /// Only call this method manually if you're not using the <see cref="ConfigureSitemap"/> default method approach.
    /// See the README.md file on how to set the (optional) <see cref="EmbeddedSitemapOptions"/> options in configuration.
    /// </summary>
    public static IApplicationBuilder MapSitemapEndpoints(this IApplicationBuilder app)
    {
        app.MapWhen(context =>
        {
            var options = context.RequestServices.GetRequiredService<IOptions<EmbeddedSitemapOptions>>().Value;

            if (context.Request.Path.StartsWithSegments(new PathString(options.SitemapEntryPath))
                || context.Request.Path.StartsWithSegments(new PathString("/sitemap")))
            {
                return true;
            }

            return false;
        }, _ =>
        {
            app.UseMiddleware<EmbeddedSitemapMiddleware>();
        });

        return app;
    }

    #endregion Specific methods
}