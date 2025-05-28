using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.SDS.Client;
using Dlw.Optimizely.SDS.Shared.Models;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml;

public interface ISitemapGeneratorService
{
    Task<SitemapState?> GenerateAndPersistAsync(IOperationContext context, ISiteCatalog siteCatalog);

    Task<SitemapState?> GenerateAndPersistDeltaAsync(
        IOperationContext context,
        ISiteCatalog siteCatalog,
        IReadOnlyCollection<SiteCatalogEntry> updates);
}