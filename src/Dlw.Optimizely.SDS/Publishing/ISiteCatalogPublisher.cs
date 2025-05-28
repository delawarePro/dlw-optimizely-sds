using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing;

public interface ISiteCatalogPublisher
{
    /// <summary>
    /// Publishes all Optimizely-published pages for this site to Sds.
    /// </summary>
    Task Publish(IOperationContext context, ISiteCatalog siteCatalog);

    /// <summary>
    /// Publishes provided pages to Sds.
    /// </summary>
    Task Publish(IOperationContext context, ISiteCatalog requestSiteCatalog, params ContentReference[] contentLinks);
}