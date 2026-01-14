using EPiServer;
using EPiServer.Core;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Core.Extensions;

public static class ContentLoaderExtensions
{
    /// <summary>
    /// Alternative method for fetching a <see cref="ContentReference">content reference</see>'s descendants,
    /// where an iterative breadth-first approach is used to avoid database connection issues.
    /// </summary>
    /// <param name="contentLoader">The content loader instance.</param>
    /// <param name="root">The root content reference.</param>
    /// <param name="logger">Optional logger.</param>
    /// <returns>An enumerable collection of descendant content references.</returns>
    public static IEnumerable<ContentReference> GetDescendantsIteratively(this IContentLoader contentLoader,
        ContentReference root, ILogger? logger = null)
    {
        var toProcess = new Queue<ContentReference>();
        toProcess.Enqueue(root);

        while (toProcess.Count > 0)
        {
            var current = toProcess.Dequeue();
            IEnumerable<ContentReference> children;
            try
            {
                children = contentLoader.GetChildren<EPiServer.Core.IContent>(current)
                    .Select(c => c.ContentLink);
            }
            catch (Exception ex)
            {
                logger?.LogWarning(ex, "Error loading children for content {ContentLink}", current);

                // If there is an error loading children, skip this node.
                continue;
            }
            foreach (var child in children)
            {
                yield return child;
                toProcess.Enqueue(child);
            }
        }
    }
}