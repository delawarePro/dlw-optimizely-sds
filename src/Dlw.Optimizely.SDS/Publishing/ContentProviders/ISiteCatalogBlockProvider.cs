namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

public interface ISiteCatalogBlockProvider
{
    Task<SiteCatalogItemsResult> GetBlocks(string? continuationToken, IOperationContext context);

    IList<int> GetBlockRoots();
}