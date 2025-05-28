using EPiServer.Core;
using EPiServer.Web;

namespace Dlw.Optimizely.Sds.Publishing;

public interface ISiteCatalog
{
    string SiteId { get; }

    SiteDefinition SiteDefinition { get; }
    
    Task<SiteCatalogEntriesResult> GetPageEntries(IOperationContext context, ContentReference rootPage, string? continuationToken = null);
    
    Task<SiteCatalogEntriesResult> GetBlockEntries(IOperationContext context, string? next = null);

    Task<SiteCatalogEntriesResult> GetEntries(IOperationContext context, params IContent[] contentItems);

    IList<int> GetBlockRoots();
}