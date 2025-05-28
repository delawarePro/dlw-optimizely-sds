using Dlw.Optimizely.Sds.Builders;
using Dlw.Optimizely.Sds.Events;
using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.Sds.Publishing.ContentProviders;
using Dlw.Optimizely.Sds.Publishing.Mappers;
using Dlw.Optimizely.SDS.Client;
using EPiServer;
using EPiServer.Web;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace Dlw.Optimizely.Sds;

public static class BuilderExtensions
{
    /// <summary>
    /// This enables the publishing of site catalogs.
    /// </summary>
    public static IServiceCollection AddSdsPublishing(
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
            .AddTransient<ISiteCatalogClient, SiteCatalogNullClient>() // Either replace this with the full SDS client or embedded SDS client.
            .AddSingleton<SiteCatalogEventHandler>();

        return services;
    }

    /// <summary>
    /// Configures the handling of catalog-publishing events.
    /// </summary>
    /// <param name="applicationBuilder"></param>
    /// <returns></returns>
    public static IApplicationBuilder ConfigureSdsPublishing(this IApplicationBuilder applicationBuilder)
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
    public static IServiceProvider AddSdsCatalog(
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