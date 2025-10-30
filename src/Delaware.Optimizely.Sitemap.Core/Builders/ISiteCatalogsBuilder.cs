namespace Delaware.Optimizely.Sitemap.Core.Builders;

public interface ISiteCatalogsBuilder
{
    /// <summary>
    ///  Add a site catalog to publish to sitemap processing.
    /// </summary>
    /// <returns></returns>
    ISiteCatalogsBuilder AddSiteCatalog(string siteId, Action<ISiteCatalogBuilder>? configure = null);
}