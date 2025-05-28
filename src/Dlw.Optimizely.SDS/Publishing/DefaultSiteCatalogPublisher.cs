using Dlw.Optimizely.Sds.Builders;
using Dlw.Optimizely.SDS.Shared.Utilities;
using EPiServer;
using EPiServer.Core;
using EPiServer.Web;
using Microsoft.Extensions.Logging;
using Dlw.Optimizely.SDS.Client;

namespace Dlw.Optimizely.Sds.Publishing;

public class DefaultSiteCatalogPublisher : ISiteCatalogPublisher
{
    private readonly ISiteCatalogClient _siteCatalogClient;
    private readonly ISiteDefinitionRepository _siteDefinitionRepository;
    private readonly ISiteDefinitionResolver _siteDefinitionResolver;
    private readonly IContentLoader _contentLoader;
    private readonly ILogger _logger;

    public SiteCatalogDirectory SiteCatalogs { get; }

    public DefaultSiteCatalogPublisher(
        SiteCatalogDirectory siteCatalogs,
        ISiteCatalogClient siteCatalogClient,
        ISiteDefinitionRepository siteDefinitionRepository,
        ISiteDefinitionResolver siteDefinitionResolver,
        IContentLoader contentLoader,
        ILoggerFactory loggerFactory)
    {
        SiteCatalogs = siteCatalogs;

        _siteCatalogClient = siteCatalogClient;
        _siteDefinitionRepository = siteDefinitionRepository;
        _siteDefinitionResolver = siteDefinitionResolver;
        _contentLoader = contentLoader;
        _logger = loggerFactory.CreateLogger<DefaultSiteCatalogPublisher>();
    }

    public virtual Task Publish(IOperationContext context, ISiteCatalog siteCatalog)
    {
        var siteDefinition = _siteDefinitionRepository.Get(siteCatalog.SiteId);
        if (siteDefinition == null)
        {
            context.Logger.LogWarning($"Could not find site definition for sites '{siteCatalog.SiteId}'.");
            return Task.CompletedTask;
        }

        return DoPublish(siteCatalog, siteDefinition, context);
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
                _logger
                    .LogWarning($"Couldn't determine site definition for content with ID " +
                      $"{string.Join(',', items.Select(c => c.ContentLink.ID))}");

                continue;
            }

            using (new SiteContextSwitcher(items.Key))
            {
                var entries = await siteCatalog.GetEntries(context, items.ToArray());

                _siteCatalogClient.UpdateCatalog(siteCatalog.SiteId, entries);
            }
        }
    }

    protected virtual async Task DoPublish(ISiteCatalog siteCatalog, SiteDefinition siteDefinition, IOperationContext context)
    {
        using (new SiteContextSwitcher(siteDefinition))
        {
            var rootPage = siteDefinition.StartPage;

            _logger.LogInformation($"Publishing pages for site {siteDefinition.Name} to Sds catalog.");

            // Pages.
            await DoPublish(siteCatalog, rootPage, context,
                (root, ctx, next) => siteCatalog.GetPageEntries(context, root, next));

            _logger.LogInformation($"Publishing blocks for site {siteDefinition.Name} to Sds catalog.");

            // Blocks.
            await DoPublish(siteCatalog, rootPage, context,
                (root, ctx, next) => siteCatalog.GetBlockEntries(context, next));
        }
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

    private List<IGrouping<SiteDefinition?, IContent>> GroupContentPerSite(IEnumerable<IContent> contentItems)
    {
        var intermediateResult = new List<KeyValuePair<SiteDefinition?, IContent>>();

        foreach (var contentItem in contentItems)
        {
            if (contentItem is PageData)
            {
                // Pages map to 1 (or 0, if outside a site tree...) site definitions, not more.
                var sd = _siteDefinitionResolver.GetByContent(contentItem.ContentLink, true);
                intermediateResult.Add(new KeyValuePair<SiteDefinition?, IContent>(sd, contentItem));
            }

            if (contentItem is BlockData)
            {
                // Blocks can be used by 0 or multiple sites.
                if (SiteCatalogs.TryGetSiteUsages(contentItem, out var bySites))
                {
                    foreach (var siteDefinition in bySites)
                    {
                        intermediateResult.Add(new KeyValuePair<SiteDefinition?, IContent>(siteDefinition, contentItem));
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