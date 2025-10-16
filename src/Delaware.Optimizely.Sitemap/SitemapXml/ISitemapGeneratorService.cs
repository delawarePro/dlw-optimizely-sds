using Delaware.Optimizely.Sitemap.Core.Client;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.Shared.Models;

namespace Delaware.Optimizely.Sitemap.SitemapXml;

public interface ISitemapGeneratorService
{
    Task<SitemapState?> GenerateAndPersistAsync(IOperationContext context, ISiteCatalog siteCatalog);

    Task<SitemapState?> GenerateAndPersistDeltaAsync(
        IOperationContext context,
        ISiteCatalog siteCatalog,
        IReadOnlyCollection<SiteCatalogEntry> updates);
}