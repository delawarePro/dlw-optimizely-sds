using System.Globalization;
using EPiServer;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

public abstract class SiteCatalogContentProviderBase
{
    protected const int DefaultBatchSize = 100;
    protected readonly IContentLoader ContentLoader;

    protected SiteCatalogContentProviderBase(IContentLoader contentLoader)
    {
        ContentLoader = contentLoader;
    }

    public Task<IReadOnlyCollection<SiteCatalogItem>> GetContent(params IContent[] contentItems)
    {
        var items = contentItems
            .Select(x => new SiteCatalogItem(x))
            .ToArray();

        var itemsPerId =
            items.ToDictionary(x => x.Content.ContentLink.ToReferenceWithoutVersion(), x => x);

        // Loads all existing localized data of incoming content items.
        LoadLocalizedData(itemsPerId);

        return Task.FromResult<IReadOnlyCollection<SiteCatalogItem>>(items);
    }

    protected virtual void LoadLocalizedData(IDictionary<ContentReference, SiteCatalogItem> itemPerId)
    {
        // First get available locales per content.
        var contentLinksByCulture = itemPerId
            .Select(x => x.Value.Content is ILocalizable localized
                ? (x.Key, localized)
                : ((ContentReference Key, ILocalizable localized)?)null)
            .Where(x => x != null)
            .Select(x => x!.Value)
            .SelectMany(
                x => x.localized.ExistingLanguages,
                (item, cultureInfo) => !cultureInfo.Equals(item.localized.Language)
                    ? new KeyValuePair<CultureInfo, ContentReference>(cultureInfo, item.Key)
                    : (KeyValuePair<CultureInfo, ContentReference>?)null)
            .Where(x => x != null)
            .GroupBy(x => x!.Value.Key, x => x!.Value);

        // Load content by culture & map data to localized site entry.
        foreach (var group in contentLinksByCulture)
        {
            var contentLinks = group.Select(x => x.Value).ToArray();
            var items = ContentLoader.GetItems(contentLinks, group.Key);

            foreach (var item in items)
            {
                if (!itemPerId.TryGetValue(item.ContentLink.ToReferenceWithoutVersion(), out var contentItem) || item is not ILocalizable localized)
                    continue;

                contentItem.Localized[localized.Language.Name] = item;
            }
        }
    }
}