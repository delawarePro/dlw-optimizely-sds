using Delaware.Optimizely.Sitemap.Core.Builders;
using Delaware.Optimizely.Sitemap.Core.Client;
using Delaware.Optimizely.Sitemap.Core.Events;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;
using Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;
using EPiServer;
using EPiServer.Web;
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
                    sp.GetRequiredService<ISiteDefinitionRepository>(),
                    sp.GetRequiredService<ISiteDefinitionResolver>(),
                    sp.GetRequiredService<IContentLoader>(),
                    sp.GetRequiredService<ILoggerFactory>()
            ))
            .AddTransient<ISiteCatalogClient, SiteCatalogNullClient>() // Either replace this with the full sitemap client or embedded sitemap client.
            .AddSingleton<SiteCatalogEventHandler>();

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
    /// Register a catalog for a <param name="siteDefinition">site</param>.
    /// This will include the <param name="siteDefinition">site</param> in the catalog publishing process.
    /// </summary>
    /// <param name="serviceProvider"></param>
    /// <param name="siteDefinition">The site to add a catalog for.</param>
    /// <param name="languages">The languages the sitemap will have to be published in for this site.</param>
    /// <param name="configure"></param>
    public static IServiceProvider AddSitemapCatalog(
        this IServiceProvider serviceProvider,
        SiteDefinition siteDefinition,
        string[] languages,
        Action<ISiteCatalogBuilder>? configure = null)
    {
        var siteCatalogDirectory = serviceProvider.GetRequiredService<SiteCatalogDirectory>();

        siteCatalogDirectory.AddSiteCatalog(siteDefinition, configure);

        return serviceProvider;
    }
}