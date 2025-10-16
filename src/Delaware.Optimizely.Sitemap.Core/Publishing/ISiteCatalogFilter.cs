namespace Delaware.Optimizely.Sitemap.Core.Publishing;

public interface ISiteCatalogFilter
{
    public bool Filter(SiteCatalogItem item, IOperationContext context);
}