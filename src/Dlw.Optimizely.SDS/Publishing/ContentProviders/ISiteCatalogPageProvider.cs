using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

public interface ISiteCatalogPageProvider
{
    Task<SiteCatalogItemsResult> GetPages(ContentReference root, string? continuationToken, IOperationContext context);

    Task<IReadOnlyCollection<SiteCatalogItem>> GetContent(params IContent[] contentItems);
}