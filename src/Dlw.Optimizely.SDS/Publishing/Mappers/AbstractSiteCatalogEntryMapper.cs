using Dlw.Optimizely.Sds.Extensions;
using Dlw.Optimizely.SDS.Client;
using EPiServer;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing.Mappers;

public abstract class AbstractSiteCatalogEntryMapper : ISiteCatalogEntryMapper
{
    protected readonly IContentLoader ContentLoader;
    protected readonly IPublishedStateAssessor PublishedStateAssessor;
    protected readonly ISiteCatalogEntryKeyResolver SiteCatalogEntryKeyResolver;

    protected AbstractSiteCatalogEntryMapper(
        IContentLoader contentLoader,
        IPublishedStateAssessor publishedStateAssessor,
        ISiteCatalogEntryKeyResolver siteCatalogEntryKeyResolver)
    {
        ContentLoader = contentLoader;
        PublishedStateAssessor = publishedStateAssessor;
        SiteCatalogEntryKeyResolver = siteCatalogEntryKeyResolver;
    }

    public SiteCatalogEntry Map(string siteName, SiteCatalogItem item, IOperationContext context)
    {
        var key = CreateKey(siteName, item.Content, context);
        var entry = new SiteCatalogEntry(key, siteName);

        if (ShouldArchive(item.Content, context))
            entry.Archived = DateTime.UtcNow;

        Map(item, entry, context);

        if (!item.Localized.Any())
        {
            return entry;
        }

        var path = ContentLoader
            .GetAncestors(item.Content.ContentLink)
            .Select(i => i.ContentLink.ID)
            .ToList();

        path.Add(item.Content.ContentLink.ID);

        entry.Path = string.Join(',', path);

        entry.Localized = new Dictionary<string, LocalizedSiteCatalogEntry>(StringComparer.OrdinalIgnoreCase);

        foreach (var (locale, localizedContent) in item.Localized)
        {
            var localizedEntry = Map(locale, localizedContent, context);

            if (localizedEntry.Url == null)
            {
                // The URL could not be generated, don't add it to the result.
                continue;
            }

            entry.Localized[locale] = localizedEntry;
        }

        return entry;
    }

    protected virtual LocalizedSiteCatalogEntry Map(string locale, IContent content, IOperationContext context)
    {
        var localizedEntry = new LocalizedSiteCatalogEntry();

        if (ShouldArchive(content, context))
            localizedEntry.Archived = DateTime.UtcNow;

        Map(locale, content, localizedEntry, context);

        return localizedEntry;
    }

    protected abstract void Map(SiteCatalogItem item, SiteCatalogEntry entry, IOperationContext context);

    protected abstract void Map(string locale, IContent content, LocalizedSiteCatalogEntry entry, IOperationContext context);

    protected virtual bool ShouldArchive(IContent content, IOperationContext context)
    {
        // Archive the entry if the content is not accessible. So this that this entry doesn't show up in the sitemap.
        // Currently, Sds does not yet support history/redirections yet.
        return content.ShouldArchive(PublishedStateAssessor, context);
    }

    protected virtual SiteCatalogEntryKey CreateKey(string siteId, IContent content, IOperationContext context)
    {
        return SiteCatalogEntryKeyResolver.Resolve(siteId, content, context);
    }
}