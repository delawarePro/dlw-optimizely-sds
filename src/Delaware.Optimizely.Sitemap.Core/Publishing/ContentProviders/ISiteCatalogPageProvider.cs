using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

public interface ISiteCatalogPageProvider
{
    Task<SiteCatalogItemsResult> GetPages(ContentReference root, string? continuationToken, IOperationContext context);

    Task<IReadOnlyCollection<SiteCatalogItem>> GetContent(params IContent[] contentItems);
}