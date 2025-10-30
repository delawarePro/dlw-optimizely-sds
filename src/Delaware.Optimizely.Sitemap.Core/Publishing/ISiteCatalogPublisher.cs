using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.Core.Publishing;

public interface ISiteCatalogPublisher
{
    /// <summary>
    /// Publishes all Optimizely-published pages for this site to store.
    /// </summary>
    Task Publish(IOperationContext context, ISiteCatalog siteCatalog);

    /// <summary>
    /// Publishes provided pages to store.
    /// </summary>
    Task Publish(IOperationContext context, ISiteCatalog requestSiteCatalog, params ContentReference[] contentLinks);
}