using Dlw.Optimizely.Sds.Builders;
using Dlw.Optimizely.Sds.Events;
using Dlw.Optimizely.Sds.Publishing;
using Dlw.Optimizely.SDS.Shared;
using EPiServer.DataAbstraction;
using EPiServer.PlugIn;
using EPiServer.Scheduler;
using Microsoft.Extensions.Logging;

namespace Dlw.Optimizely.Sds.Jobs;

/// <summary>
/// Job is registered in Optimizely once assembly is referenced.
/// Initial schedule is once a day. This can be configured in CMS after installation.
/// </summary>
[ScheduledPlugIn(
    GUID = JobId,
    DisplayName = "[Sds] Full publish (only) of site catalogs",
    IntervalType = ScheduledIntervalType.None,
    IntervalLength = 1,
    DefaultEnabled = true)]
public class FullSiteCatalogJob : ScheduledJobBase
{
    public const string JobId = "B101435E-0754-4054-9513-2D5D082C7DD0";

    protected readonly SiteCatalogEventHandler? SiteCatalogEventHandler;
    protected readonly SiteCatalogDirectory? SiteCatalogDirectory;
    protected readonly ILogger<FullSiteCatalogJob> Logger;
    protected bool StopSignaled;

    public FullSiteCatalogJob(
        ILoggerFactory loggerFactory,
        SiteCatalogEventHandler? siteCatalogEventHandler = null,
        SiteCatalogDirectory? siteCatalogDirectory = null)
    {
        Logger = loggerFactory.CreateLogger<FullSiteCatalogJob>();
        SiteCatalogEventHandler = siteCatalogEventHandler;
        SiteCatalogDirectory = siteCatalogDirectory;

        IsStoppable = true;
    }

    public override void Stop() => StopSignaled = true;

    public override string Execute()
    {
        // Ensure no parallel running of other Sds jobs.
        using var mutex = new Mutex(false, SharedSdsConstants.SdsJobMutexName, out var isMutexAcquired);

        if (!isMutexAcquired)
        {
            var alreadyRunningMsg = "Another SDS processing job is already running. Skipping execution.";

            Logger.LogWarning(alreadyRunningMsg);

            return alreadyRunningMsg;
        }

        return DoSiteCatalogPublishes();
    }

    protected string DoSiteCatalogPublishes()
    {
        Logger.LogInformation($"Started {nameof(ScheduledJob)}.");

        if (SiteCatalogEventHandler == null)
        {
            var msg = "[Sds] Site catalog publishing not enabled.";
            Logger.LogWarning(msg);

            return msg;
        }

        if (SiteCatalogDirectory?.SiteIds.Any() != true)
        {
            var msg = "[Sds] No site catalogs found to publish.";
            Logger.LogWarning(msg);

            return msg;
        }

        OnStatusChanged($"[Sds] Starting '{nameof(FullSiteCatalogJob)}'.");

        foreach (var siteName in SiteCatalogDirectory.SiteIds)
        {
            if (!SiteCatalogDirectory.TryGetSiteCatalog(siteName, out var siteCatalog) || siteCatalog == null)
            {
                Logger.LogWarning($"Inconsistent site catalog registration: catalog {siteName} was not found!");

                continue;
            }

            if (StopSignaled)
            {
                Logger.LogInformation("Received stop signal.");

                break;
            }

            Logger.LogInformation($"Processing site catalog for site {siteName}.");

            OnStatusChanged($"[Sds] Triggering site catalog publish '{siteName}'.");

            SiteCatalogEventHandler.PublishSiteCatalog(siteCatalog);

            OnSiteCatalogPublishedAsync(siteCatalog);
        }

        var msg2 = $"[Sds] '{nameof(FullSiteCatalogJob)}' finished.";
        OnStatusChanged(msg2);

        return msg2;
    }

    protected virtual Task OnSiteCatalogPublishedAsync(ISiteCatalog siteCatalog)
    {
        return Task.CompletedTask;
    }
}