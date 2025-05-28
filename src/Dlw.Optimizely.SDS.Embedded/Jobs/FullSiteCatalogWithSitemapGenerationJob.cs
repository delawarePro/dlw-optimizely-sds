using Dlw.Optimizely.Sds.Builders;
using Dlw.Optimizely.Sds.Events;
using Dlw.Optimizely.Sds.Jobs;
using Dlw.Optimizely.SDS.Embedded.SitemapXml;
using Dlw.Optimizely.Sds.Publishing;
using EPiServer.DataAbstraction;
using EPiServer.PlugIn;
using Microsoft.Extensions.Logging;

namespace Dlw.Optimizely.SDS.Embedded.Jobs
{
    [ScheduledPlugIn(
        GUID = JobId,
        DisplayName = "[Sds-Embedded] Fully process site catalogs and create sitemap XML files",
        IntervalType = ScheduledIntervalType.Days,
        IntervalLength = 1,
        DefaultEnabled = true)]
    public class FullSiteCatalogWithSitemapGenerationJob : FullSiteCatalogJob
    {
        public new const string JobId = "{08E2879D-1903-44AF-913C-0D967BFFFF68}";

        private readonly ISitemapGeneratorService _sitemapGeneratorService;

        public FullSiteCatalogWithSitemapGenerationJob(
            ILoggerFactory loggerFactory, 
            ISitemapGeneratorService sitemapGeneratorService, 
            SiteCatalogEventHandler? siteCatalogEventHandler = null,
            SiteCatalogDirectory? siteCatalogDirectory = null) :
            base(loggerFactory, siteCatalogEventHandler, siteCatalogDirectory)
        {
            _sitemapGeneratorService = sitemapGeneratorService;
        }

        protected override async Task OnSiteCatalogPublishedAsync(ISiteCatalog siteCatalog)
        {
            await _sitemapGeneratorService.GenerateAndPersistAsync(new OperationContext(), siteCatalog);
        }
    }
}
