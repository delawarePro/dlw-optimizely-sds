namespace Delaware.Optimizely.Sitemap.Core.Publishing.ContentProviders;

public record SiteCatalogItemsResult(IReadOnlyCollection<SiteCatalogItem>? Items, string? Next);