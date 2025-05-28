using Dlw.Optimizely.Sds.Builders;
using Dlw.Optimizely.Sds.Publishing;
using EPiServer;
using EPiServer.Core;
using EPiServer.Events;
using EPiServer.Events.Clients;
using EPiServer.Web;
using Microsoft.Extensions.Logging;

namespace Dlw.Optimizely.Sds.Events
{
    public class SiteCatalogEventHandler
    {
        private static readonly string OriginalUrlSegmentToken = "PreviousUrlSegment";

        public static readonly Guid PublishSiteCatalogEventId = new("{059399EF-CB1E-4409-A908-D88A6916BB3C}");
        public static readonly Guid UpdatedSiteCatalogEventId = new("{E8BEB0EF-0E15-4199-ACA3-D9A500738395}");

        private readonly IContentEvents _contentEvents;
        private readonly IContentLoader _contentLoader;
        private readonly ISiteCatalogPublisher _siteCatalogPublisher;
        private readonly ISiteDefinitionResolver _siteDefinitionResolver;
        private readonly SiteCatalogDirectory _siteCatalogDirectory;

        private readonly IEventRegistry _eventRegistry;
        private readonly ILogger _logger;

        public SiteCatalogEventHandler(
            IContentEvents contentEvents,
            IContentLoader contentLoader,
            IEventRegistry eventRegistry,
            ISiteCatalogPublisher siteCatalogPublisher,
            ISiteDefinitionResolver siteDefinitionResolver,
            SiteCatalogDirectory siteCatalogDirectory,
            ILoggerFactory loggerFactory)
        {
            _contentEvents = contentEvents;
            _contentLoader = contentLoader;
            _siteCatalogPublisher = siteCatalogPublisher;
            _siteDefinitionResolver = siteDefinitionResolver;
            _siteCatalogDirectory = siteCatalogDirectory;
            _eventRegistry = eventRegistry;
            _logger = loggerFactory.CreateLogger<SiteCatalogEventHandler>();
        }

        public virtual void PublishSiteCatalog(ISiteCatalog siteCatalog)
        {
            _eventRegistry
                .Get(PublishSiteCatalogEventId)
                .Raise(PublishSiteCatalogEventId, new PublishSiteCatalogRequest(siteCatalog));
        }

        public virtual void Initialize()
        {
            _contentEvents.PublishingContent += new EventHandler<ContentEventArgs>(async (s, e) => await PublishingContent(s, e));
            _contentEvents.PublishedContent += new EventHandler<ContentEventArgs>(async (s, e) => await PublishedContent(s, e));
            _contentEvents.MovingContent += new EventHandler<ContentEventArgs>(async (s, e) => await MovingContent(s, e));
            _contentEvents.MovedContent += new EventHandler<ContentEventArgs>(async (s, e) => await MovedContent(s, e));
            _eventRegistry.Get(PublishSiteCatalogEventId).Raised += new EventNotificationHandler(new EventHandler<EventNotificationEventArgs>(async (s, e) => await OnPublishSiteCatalogEvent(s, e)));
        }

        public virtual void Uninitialize()
        {
            _contentEvents.PublishingContent -= new EventHandler<ContentEventArgs>(async (s, e) => await PublishingContent(s, e));
            _contentEvents.PublishedContent -= new EventHandler<ContentEventArgs>(async (s, e) => await PublishedContent(s, e));
            _contentEvents.MovingContent -= new EventHandler<ContentEventArgs>(async (s, e) => await MovingContent(s, e));
            _contentEvents.MovedContent -= new EventHandler<ContentEventArgs>(async (s, e) => await MovedContent(s, e));
            _eventRegistry.Get(PublishSiteCatalogEventId).Raised -= new EventNotificationHandler(new EventHandler<EventNotificationEventArgs>(async (s, e) => await OnPublishSiteCatalogEvent(s, e)));
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

                await _siteCatalogPublisher.Publish(context, request.SiteCatalog);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "[Sds] Error occurred when publishing to site catalog.");
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
                        var childContentReferences = _contentLoader
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

                await _siteCatalogPublisher.Publish(context, siteCatalog, contentLinks);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "[Sds] Error occurred when publishing to site catalog.");
            }
        }

        private Task PublishingContent(object? sender, ContentEventArgs e)
        {
            if (e.Content is PageData content && !ContentReference.IsNullOrEmpty(content.ContentLink) /* Can be null when creating content! */)
            {
                // Get the latest published version - if any.
                var previousPageData = _contentLoader.Get<PageData>(content.ContentLink.ToReferenceWithoutVersion());

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

            _eventRegistry
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
            var siteDefinition = _siteDefinitionResolver.GetByContent(forContent.ContentLink, true);

            if (siteDefinition == null)
            {
                siteCatalog = null;
                return false;
            }

            if (_siteCatalogDirectory.TryGetSiteCatalog(siteDefinition.Name, out siteCatalog))
            {
                return true;
            }

            siteCatalog = null;

            return false;
        }
    }
}
