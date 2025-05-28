namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

public record SiteCatalogItemsResult(IReadOnlyCollection<SiteCatalogItem>? Items, string? Next);