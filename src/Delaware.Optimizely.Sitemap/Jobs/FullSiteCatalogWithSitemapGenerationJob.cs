using Delaware.Optimizely.Sitemap.Core.Builders;
using Delaware.Optimizely.Sitemap.Core.Events;
using Delaware.Optimizely.Sitemap.Core.Jobs;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using Delaware.Optimizely.Sitemap.SitemapXml;
using EPiServer.DataAbstraction;
using EPiServer.PlugIn;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Jobs
{
    [ScheduledPlugIn(
        GUID = JobId,
        DisplayName = "[delaware sitemap] Fully process site catalogs and create sitemap XML files",
        IntervalType = ScheduledIntervalType.Days,
        IntervalLength = 1,
        DefaultEnabled = true)]
    public class FullSiteCatalogWithSitemapGenerationJob(
        ILoggerFactory loggerFactory,
        ISitemapGeneratorService sitemapGeneratorService,
        SiteCatalogEventHandler? siteCatalogEventHandler = null,
        SiteCatalogDirectory? siteCatalogDirectory = null)
        : FullSiteCatalogJob(loggerFactory, siteCatalogEventHandler, siteCatalogDirectory)
    {
        public new const string JobId = "{08E2879D-1903-44AF-913C-0D967BFFFF68}";

        protected override async Task OnSiteCatalogPublishedAsync(ISiteCatalog siteCatalog)
        {
            await sitemapGeneratorService.GenerateAndPersistAsync(new OperationContext(), siteCatalog);
        }
    }
}
