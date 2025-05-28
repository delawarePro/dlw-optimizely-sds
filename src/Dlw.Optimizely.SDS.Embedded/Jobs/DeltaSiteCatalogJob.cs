using System.Text;
using Dlw.Optimizely.Sds.Builders;
using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.SDS.Embedded.Client;
using Dlw.Optimizely.SDS.Embedded.SitemapXml;
using Dlw.Optimizely.SDS.Shared;
using EPiServer.DataAbstraction;
using EPiServer.PlugIn;
using EPiServer.Scheduler;
using Microsoft.Extensions.Logging;

namespace Dlw.Optimizely.SDS.Embedded.Jobs;

[ScheduledPlugIn(
    GUID = JobId,
    DisplayName = "[Sds-Embedded] Delta process site catalogs and create delta-sitemap XML files",
    IntervalType = ScheduledIntervalType.Hours,
    IntervalLength = 2,
    DefaultEnabled = true)]
public class DeltaSiteCatalogJob : ScheduledJobBase
{
    public const string JobId = "60EA0295-2477-4FD1-8185-A8091360A89D";

    private readonly SiteCatalogDirectory? _siteCatalogDirectory;
    private readonly IEmbeddedSiteCatalogClient? _embeddedSiteCatalogClient;
    private readonly ILogger<DeltaSiteCatalogJob> _logger;
    private readonly ISitemapGeneratorService _sitemapGeneratorService;

    private bool _stopSignaled;

    public DeltaSiteCatalogJob(
        SiteCatalogDirectory siteCatalogDirectory,
        IEmbeddedSiteCatalogClient embeddedSiteCatalogClient,
        ILoggerFactory loggerFactory, 
        ISitemapGeneratorService sitemapGeneratorService)
    {
        _siteCatalogDirectory = siteCatalogDirectory;
        _logger = loggerFactory.CreateLogger<DeltaSiteCatalogJob>();
        _sitemapGeneratorService = sitemapGeneratorService;
        _embeddedSiteCatalogClient = embeddedSiteCatalogClient;

        IsStoppable = true;
    }

    public override void Stop() => _stopSignaled = true;

    public override string Execute()
    {
        var msg = string.Empty;
        var msgBuilder = new StringBuilder();

        var context = new OperationContext(logger: _logger);

        // Ensure no parallel running of other Sds jobs.
        using var mutex = new Mutex(false, SharedSdsConstants.SdsJobMutexName, out var isMutexAcquired);

        if (!isMutexAcquired)
        {
            var alreadyRunningMsg = "A full rebuild is already running. Skipping execution.";

            _logger.LogWarning(alreadyRunningMsg);

            return alreadyRunningMsg;
        }

        if (_siteCatalogDirectory == null || _siteCatalogDirectory.SiteIds.Count <= 0 || _embeddedSiteCatalogClient == null)
        {
            msg = "Could not find any site catalogs, stopping job.";
            _logger.LogWarning(msg);

            return msg;
        }

        foreach (var siteName in _siteCatalogDirectory!.SiteIds)
        {
            if (_stopSignaled)
            {
                var stopMsg = "Stop signal received.";
                _logger.LogWarning(stopMsg);
                msgBuilder.AppendLine(stopMsg);

                break;
            }

            if (!_siteCatalogDirectory.TryGetSiteCatalog(siteName, out var siteCatalog) || siteCatalog == null)
            {
                msg = $"Site catalog for site {siteName} is missing. Skipping.";

                msgBuilder.AppendLine(msg);

                _logger.LogWarning(msg);

                continue;
            }

            var state = _embeddedSiteCatalogClient.GetState(siteName);

            if (state.LastFullGenerationUtc == null)
            {
                msg =
                    $"Site catalog for site {siteName} is empty, a full build is needed before a delta can be processed. Skipping.";

                _logger.LogWarning(msg);

                msgBuilder.AppendLine(msg);

                continue;
            }

            msg = $"Processing delta for site {siteName}";
            msgBuilder.AppendLine(msg);


            // Determine time from which to try to find updates.
            var time = state.LastDeltaGenerationUtc ?? state.LastFullGenerationUtc ?? DateTime.MinValue;
            var updates = _embeddedSiteCatalogClient.GetCatalogUpdates(context, siteName, time);

            _sitemapGeneratorService.GenerateAndPersistDeltaAsync(context, siteCatalog, updates).GetAwaiter().GetResult();

            msg = $"Done processing delta for site {siteName}";
            msgBuilder.AppendLine(msg);
        }

        return msgBuilder.ToString();
    }
}