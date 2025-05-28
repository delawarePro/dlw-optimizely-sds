namespace Dlw.Optimizely.Sds.Publishing;

public interface ISiteCatalogFilter
{
    public bool Filter(SiteCatalogItem item, IOperationContext context);
}