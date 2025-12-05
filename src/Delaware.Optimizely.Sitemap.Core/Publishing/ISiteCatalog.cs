using EPiServer.Core;
using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap.Core.Publishing;

public interface ISiteCatalog
{
    string SiteId { get; }

    SiteDefinition SiteDefinition { get; }

    public IDictionary<string, IReadOnlyCollection<string>> LanguageGroups { get; set; }

    Task<SiteCatalogEntriesResult> GetPageEntries(IOperationContext context, ContentReference rootPage, string? continuationToken = null);
    
    Task<SiteCatalogEntriesResult> GetBlockEntries(IOperationContext context, string? next = null);

    Task<SiteCatalogEntriesResult> GetEntries(IOperationContext context, params IContent[] contentItems);

    IList<int> GetBlockRoots();
}