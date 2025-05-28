using EPiServer.Web;
using Microsoft.Extensions.DependencyInjection;

namespace Dlw.Optimizely.Sds.Builders;

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
        var siteDefinitionRepo = _serviceProvider.GetRequiredService<ISiteDefinitionRepository>();

        foreach (var x in _siteCatalogBuilders)
        {
            // Translate key (site name) to a site definition.
            var siteDefinition = siteDefinitionRepo.Get(x.Key);

            directory.AddSiteCatalog(siteDefinition, x.Value);
        }

        return directory;
    }
}