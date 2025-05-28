namespace Dlw.Optimizely.Sds.Builders;

public interface ISiteCatalogsBuilder
{
    /// <summary>
    ///  Add a site catalog to publish to Sds.
    /// </summary>
    /// <returns></returns>
    ISiteCatalogsBuilder AddSiteCatalog(string siteId, Action<ISiteCatalogBuilder>? configure = null);
}