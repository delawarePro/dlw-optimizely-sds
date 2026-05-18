using Delaware.Optimizely.Sitemap.Core.Builders;
using Delaware.Optimizely.Sitemap.Core.Client;
using EPiServer;
using EPiServer.Applications;
using EPiServer.Core;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Core.Publishing;

public class DefaultSiteCatalogPublisher : ISiteCatalogPublisher
{
    private readonly ISiteCatalogClient _siteCatalogClient;
    private readonly IApplicationRepository _applicationRepository;
    private readonly IApplicationResolver _applicationResolver;
    private readonly IContentLoader _contentLoader;
    private readonly ILogger _logger;

    public SiteCatalogDirectory SiteCatalogs { get; }

    public DefaultSiteCatalogPublisher(
        SiteCatalogDirectory siteCatalogs,
        ISiteCatalogClient siteCatalogClient,
        IApplicationRepository applicationRepository,
        IApplicationResolver applicationResolver,
        IContentLoader contentLoader,
        ILoggerFactory loggerFactory)
    {
        SiteCatalogs = siteCatalogs;

        _siteCatalogClient = siteCatalogClient;
        _applicationRepository = applicationRepository;
        _applicationResolver = applicationResolver;
        _contentLoader = contentLoader;
        _logger = loggerFactory.CreateLogger<DefaultSiteCatalogPublisher>();
    }

    public virtual Task Publish(IOperationContext context, ISiteCatalog siteCatalog)
    {
        if (siteCatalog == null || string.IsNullOrWhiteSpace(siteCatalog.SiteId))
        {
            context.Logger.LogWarning("'{Publish}' ignored. No site catalog provided", nameof(Publish));
            return Task.CompletedTask;
        }

        var application = _applicationRepository.Get<InProcessWebsite>(siteCatalog.SiteId);
        if (application == null)
        {
            context.Logger.LogWarning("Could not find application for site '{siteId}'.", siteCatalog.SiteId);
            return Task.CompletedTask;
        }

        return DoPublish(siteCatalog, application, context);
    }

    public virtual async Task Publish(
        IOperationContext context,
        ISiteCatalog siteCatalog,
        params ContentReference[] contentLinks)
    {
        var contentItems = _contentLoader.GetItems(contentLinks, LanguageSelector.MasterLanguage());
        var itemsBySite = GroupContentPerSite(contentItems);

        foreach (var items in itemsBySite)
        {
            if (items.Key == null)
            {
                _logger.LogWarning("Couldn't determine application for content with ID {ContentIds}", string.Join(',', items.Select(c => c.ContentLink.ID)));

                continue;
            }

            var entries = await siteCatalog.GetEntries(context, [.. items]);

            _siteCatalogClient.UpdateCatalog(siteCatalog.SiteId, entries);
        }
    }

    protected virtual async Task DoPublish(ISiteCatalog siteCatalog, InProcessWebsite application, IOperationContext context)
    {
        var rootPage = application.EntryPoint;

        _logger.LogInformation("Publishing pages for site {site} to sitemap catalog.", application.DisplayName);

        // Pages.
        await DoPublish(siteCatalog, rootPage, context,
            (root, ctx, next) => siteCatalog.GetPageEntries(context, root, next));

        _logger.LogInformation("Publishing blocks for site {site} to sitemap catalog.", application.DisplayName);

        // Blocks.
        await DoPublish(siteCatalog, rootPage, context,
            (root, ctx, next) => siteCatalog.GetBlockEntries(context, next));
    }

    protected virtual async Task DoPublish(
        ISiteCatalog siteCatalog,
        ContentReference? root,
        IOperationContext context,
        Func<ContentReference, IOperationContext, string?, Task<SiteCatalogEntriesResult>> entriesResolver)
    {
        if (root == null || root == ContentReference.EmptyReference)
        {
            return;
        }

        SiteCatalogEntriesResult? result = null;

        do
        {
            result = await entriesResolver(root, context, result?.Next);

            if (result.Entries?.Any() == true)
            {
                _siteCatalogClient.UpdateCatalog(siteCatalog.SiteId, result);
            }

        } while (result.HasNext);
    }

    #region Helper Methods

    private List<IGrouping<Application?, IContent>> GroupContentPerSite(IEnumerable<IContent> contentItems)
    {
        var intermediateResult = new List<KeyValuePair<Application?, IContent>>();

        foreach (var contentItem in contentItems)
        {
            if (contentItem is PageData)
            {
                // Pages map to 1 (or 0, if outside a site tree...) site definitions, not more.
                var app = _applicationResolver.GetByContent(contentItem.ContentLink, true);
                intermediateResult.Add(new KeyValuePair<Application?, IContent>(app, contentItem));
            }

            if (contentItem is BlockData)
            {
                // Blocks can be used by 0 or multiple sites.
                if (SiteCatalogs.TryGetSiteUsages(contentItem, out var bySites))
                {
                    foreach (var application in bySites)
                    {
                        intermediateResult.Add(new KeyValuePair<Application?, IContent>(application, contentItem));
                    }
                }
            }
        }

        return intermediateResult
            .GroupBy(k => k.Key, k => k.Value)
            .ToList();
    }

    #endregion
}