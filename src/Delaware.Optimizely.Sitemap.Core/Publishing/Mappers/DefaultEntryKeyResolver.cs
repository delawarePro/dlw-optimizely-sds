using Delaware.Optimizely.Sitemap.Core.Client;
using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;

public class DefaultEntryKeyResolver : ISiteCatalogEntryKeyResolver
{
    public SiteCatalogEntryKey Resolve(string siteId, IContent content, IOperationContext context)
    {
        var id = content.ContentLink?.ToReferenceWithoutVersion()?.ToString();
        if (string.IsNullOrEmpty(id))
            throw new NullReferenceException(nameof(content.ContentLink));

        return new SiteCatalogEntryKey("all", id);
    }
}