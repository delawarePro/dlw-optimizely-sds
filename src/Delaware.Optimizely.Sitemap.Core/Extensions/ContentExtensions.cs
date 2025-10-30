using Delaware.Optimizely.Sitemap.Core.Publishing;
using EPiServer;
using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.Core.Extensions;

public static class ContentExtensions
{
    public static bool ShouldArchive(this IContent content, IPublishedStateAssessor assessor, IOperationContext context)
    {
        return !assessor.IsPublished(content)
               || content.IsDeleted
               || (context.EventArgs is MoveContentEventArgs args && args.TargetLink == ContentReference.WasteBasket);
    }
}