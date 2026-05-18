using EPiServer.Applications;
using Microsoft.Extensions.DependencyInjection;

namespace Delaware.Optimizely.Sitemap.Core.Builders;

public class SiteCatalogsBuilder : ISiteCatalogsBuilder
{
    private readonly IDictionary<string, Action<ISiteCatalogBuilder>?> _siteCatalogBuilders =
        new Dictionary<string, Action<ISiteCatalogBuilder>?>(StringComparer.OrdinalIgnoreCase);

    private readonly IServiceProvider _serviceProvider;

    public SiteCatalogsBuilder(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
    }

    public virtual ISiteCatalogsBuilder AddSiteCatalog(string siteId, Action<ISiteCatalogBuilder>? configure = null)
    {
        _siteCatalogBuilders[siteId] = configure;

        return this;
    }

    public SiteCatalogDirectory Build()
    {
        var directory = new SiteCatalogDirectory(_serviceProvider);
        var applicationRepo = _serviceProvider.GetRequiredService<IApplicationRepository>();

        foreach (var x in _siteCatalogBuilders)
        {
            // Translate key (site name) to a site definition.
            var application = applicationRepo.Get<InProcessWebsite>(x.Key);

            if(application != null)
                directory.AddSiteCatalog(application, x.Value);
        }

        return directory;
    }
}