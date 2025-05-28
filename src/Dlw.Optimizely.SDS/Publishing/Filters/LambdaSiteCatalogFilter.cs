namespace Dlw.Optimizely.Sds.Publishing.Filters;

public class LambdaSiteCatalogFilter(Func<SiteCatalogItem, IOperationContext, bool> filter) : ISiteCatalogFilter
{
    public bool Filter(SiteCatalogItem item, IOperationContext context)
    {
        return filter.Invoke(item, context);
    }
}