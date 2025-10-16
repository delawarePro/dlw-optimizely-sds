using Delaware.Optimizely.Sitemap.Core.Builders;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using EPiServer;
using EPiServer.Core;
using EPiServer.Events;
using EPiServer.Events.Clients;
using EPiServer.Web;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Core.Events
{
    public class SiteCatalogEventHandler(
        IContentEvents contentEvents,
        IContentLoader contentLoader,
        IEventRegistry eventRegistry,
        ISiteCatalogPublisher siteCatalogPublisher,
        ISiteDefinitionResolver siteDefinitionResolver,
        SiteCatalogDirectory siteCatalogDirectory,
        ILoggerFactory loggerFactory)
    {
        private static readonly string OriginalUrlSegmentToken = "PreviousUrlSegment";

        public static readonly Guid PublishSiteCatalogEventId = new("{059399EF-CB1E-4409-A908-D88A6916BB3C}");
        public static readonly Guid UpdatedSiteCatalogEventId = new("{E8BEB0EF-0E15-4199-ACA3-D9A500738395}");

        private readonly ILogger _logger = loggerFactory.CreateLogger<SiteCatalogEventHandler>();

        public virtual void PublishSiteCatalog(ISiteCatalog siteCatalog)
        {
            eventRegistry
                .Get(PublishSiteCatalogEventId)
                .Raise(PublishSiteCatalogEventId, new PublishSiteCatalogRequest(siteCatalog));
        }

        public virtual void Initialize()
        {
            contentEvents.PublishingContent += new EventHandler<ContentEventArgs>(async (s, e) => await PublishingContent(s, e));
            contentEvents.PublishedContent += new EventHandler<ContentEventArgs>(async (s, e) => await PublishedContent(s, e));
            contentEvents.MovingContent += new EventHandler<ContentEventArgs>(async (s, e) => await MovingContent(s, e));
            contentEvents.MovedContent += new EventHandler<ContentEventArgs>(async (s, e) => await MovedContent(s, e));
            eventRegistry.Get(PublishSiteCatalogEventId).Raised += new EventNotificationHandler(new EventHandler<EventNotificationEventArgs>(async (s, e) => await OnPublishSiteCatalogEvent(s, e)));
        }

        public virtual void Uninitialize()
        {
            contentEvents.PublishingContent -= new EventHandler<ContentEventArgs>(async (s, e) => await PublishingContent(s, e));
            contentEvents.PublishedContent -= new EventHandler<ContentEventArgs>(async (s, e) => await PublishedContent(s, e));
            contentEvents.MovingContent -= new EventHandler<ContentEventArgs>(async (s, e) => await MovingContent(s, e));
            contentEvents.MovedContent -= new EventHandler<ContentEventArgs>(async (s, e) => await MovedContent(s, e));
            eventRegistry.Get(PublishSiteCatalogEventId).Raised -= new EventNotificationHandler(new EventHandler<EventNotificationEventArgs>(async (s, e) => await OnPublishSiteCatalogEvent(s, e)));
        }

        protected virtual async Task OnPublishSiteCatalogEvent(object? sender, EventNotificationEventArgs e)
        {
            try
            {
                if (e.Param is not PublishSiteCatalogRequest request)
                {
                    _logger.LogWarning($"'{nameof(OnPublishSiteCatalogEvent)}' ignored. No site catalog id provided");
                    return;
                }

                var context = new OperationContext(logger: _logger);

                await siteCatalogPublisher.Publish(context, request.SiteCatalog);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "[Sitemap] Error occurred when publishing to site catalog.");
            }
        }

        protected virtual async Task DoPublish(object? sender, ContentEventArgs e)
        {
            try
            {
                var context = new OperationContext(logger: _logger, eventArgs: e);
                var contentLinks = new[] { e.ContentLink };

                if (!TryGetSiteCatalog(e.Content, out var siteCatalog) || siteCatalog == null)
                {
                    // Content does not belong to a site catalog.
                    return;
                }

                if (e.Content is PageData changedPageData)
                {
                    var originalUrlSegment = e.Items[OriginalUrlSegmentToken] as string;

                    if (!string.IsNullOrWhiteSpace(originalUrlSegment)
                        && !originalUrlSegment.Equals(changedPageData.URLSegment,
                            StringComparison.InvariantCultureIgnoreCase))
                    {
                        // The URL segment has changed, this will have effect on the descending page URLs as well.
                        var childContentReferences = contentLoader
                            .GetDescendents(changedPageData.ContentLink)
                            .ToList();

                        if (childContentReferences.Any())
                        {
                            contentLinks = contentLinks.Concat(childContentReferences).ToArray();
                        }
                    }
                }

                if (e is MoveContentEventArgs { Descendents: not null } movedContentArgs)
                {
                    contentLinks = contentLinks
                        .Concat(movedContentArgs.Descendents)
                        .ToArray();
                }

                await siteCatalogPublisher.Publish(context, siteCatalog, contentLinks);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "[Sitemap] Error occurred when publishing to site catalog.");
            }
        }

        private Task PublishingContent(object? sender, ContentEventArgs e)
        {
            if (e.Content is PageData content && !ContentReference.IsNullOrEmpty(content.ContentLink) /* Can be null when creating content! */)
            {
                // Get the latest published version - if any.
                var previousPageData = contentLoader.Get<PageData>(content.ContentLink.ToReferenceWithoutVersion());

                if (previousPageData != null)
                {
                    e.Items[OriginalUrlSegmentToken] = previousPageData.URLSegment;
                }
            }

            return Task.CompletedTask;
        }

        private async Task PublishedContent(object? sender, ContentEventArgs e)
        {
            await DoPublish(sender, e);

            eventRegistry
                .Get(UpdatedSiteCatalogEventId)
                .Raise(UpdatedSiteCatalogEventId, null);
        }

        private Task MovedContent(object? sender, ContentEventArgs e)
        {
            return DoPublish(sender, e);
        }

        private Task MovingContent(object? sender, ContentEventArgs e)
        {
            // Only trigger a publish if content editor is moving content to waste basket.
            return e is MoveContentEventArgs moveContentArgs && moveContentArgs.TargetLink == ContentReference.WasteBasket
                ? DoPublish(sender, e)
                : Task.CompletedTask;
        }

        private bool TryGetSiteCatalog(IContent forContent, out ISiteCatalog? siteCatalog)
        {
            var siteDefinition = siteDefinitionResolver.GetByContent(forContent.ContentLink, true);

            if (siteDefinition == null)
            {
                siteCatalog = null;
                return false;
            }

            if (siteCatalogDirectory.TryGetSiteCatalog(siteDefinition.Name, out siteCatalog))
            {
                return true;
            }

            siteCatalog = null;

            return false;
        }
    }
}
