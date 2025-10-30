namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

public interface ISiteCatalogBlockProvider
{
    Task<SiteCatalogItemsResult> GetBlocks(string? continuationToken, IOperationContext context);

    IList<int> GetBlockRoots();
}