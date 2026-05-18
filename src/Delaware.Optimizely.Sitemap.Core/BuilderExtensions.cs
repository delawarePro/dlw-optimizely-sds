using Delaware.Optimizely.Sitemap.Core.Builders;
using Delaware.Optimizely.Sitemap.Core.Client;
using Delaware.Optimizely.Sitemap.Core.Events;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;
using Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;
using EPiServer;
using EPiServer.Applications;
using EPiServer.DependencyInjection;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Core;

public static class BuilderExtensions
{
    /// <summary>
    /// This enables the publishing of site catalogs.
    /// </summary>
    public static IServiceCollection AddSitemapPublishing(
        this IServiceCollection services,
        IConfiguration configuration,
        Action<ISiteCatalogsBuilder>? configure = null)
    {
        services
            .AddSingleton<ISiteCatalogPageProvider, DefaultSiteCatalogPageProvider>()
            .AddSingleton<ISiteCatalogBlockProvider, DefaultSiteCatalogBlockProvider>()
            .AddSingleton<DefaultSiteCatalogEntryMapper>()
            .AddSingleton(sp =>
            {
                var builder = new SiteCatalogsBuilder(sp);
                configure?.Invoke(builder);
                return builder.Build();
            })
            .AddSingleton<ISiteCatalogPublisher>(sp => new DefaultSiteCatalogPublisher(
                    sp.GetRequiredService<SiteCatalogDirectory>(),
                    sp.GetRequiredService<ISiteCatalogClient>(),
                    sp.GetRequiredService<IApplicationRepository>(),
                    sp.GetRequiredService<IApplicationResolver>(),
                    sp.GetRequiredService<IContentLoader>(),
                    sp.GetRequiredService<ILoggerFactory>()
            ))
            .AddTransient<ISiteCatalogClient, SiteCatalogNullClient>() // Either replace this with the full sitemap client or embedded sitemap client.
            .AddSingleton<SiteCatalogEventHandler>();

        services
            .AddCmsEvents()
            .AddCmsEventType<PublishSiteCatalogRequestEvent>()
            .AddCmsEventType<UpdatedSiteCatalogEvent>();

        return services;
    }

    /// <summary>
    /// Configures the handling of catalog-publishing events.
    /// </summary>
    /// <param name="applicationBuilder"></param>
    /// <returns></returns>
    public static IApplicationBuilder ConfigureSitemapPublishing(this IApplicationBuilder applicationBuilder)
    {
        applicationBuilder
            .ApplicationServices
            .GetRequiredService<SiteCatalogEventHandler>()
            .Initialize();

        return applicationBuilder;
    }

    /// <summary>
    /// Register a catalog for a <param name="application">application</param>.
    /// This will include the <param name="application">application</param> in the catalog publishing process.
    /// </summary>
    /// <param name="serviceProvider"></param>
    /// <param name="application">The application to add a catalog for.</param>
    /// <param name="languages">*All* application's languages to include in sitemap for this application.</param>
    /// <param name="configure"></param>
    public static IServiceProvider AddSitemapCatalog(
        this IServiceProvider serviceProvider,
        InProcessWebsite application,
        string[] languages,
        Action<ISiteCatalogBuilder>? configure = null)
    {
        var siteCatalogDirectory = serviceProvider.GetRequiredService<SiteCatalogDirectory>();

        siteCatalogDirectory.AddSiteCatalog(application, configure, languages);

        return serviceProvider;
    }
}