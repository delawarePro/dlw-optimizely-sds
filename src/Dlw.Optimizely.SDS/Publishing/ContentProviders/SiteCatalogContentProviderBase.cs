using System.Globalization;
using EPiServer;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

public abstract class SiteCatalogContentProviderBase(
    IContentLoader contentLoader,
    IContentLanguageSettingsHandler contentLanguageSettingsHandler)
{
    protected const int DefaultBatchSize = 100;
    protected readonly IContentLoader ContentLoader = contentLoader;
    protected readonly IContentLanguageSettingsHandler ContentLanguageSettingsHandler = contentLanguageSettingsHandler;

    public virtual Task<IReadOnlyCollection<SiteCatalogItem>> GetContent(params IContent[] contentItems)
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
                x => DetermineCultureInfos(x.Key, x.localized)/*x.localized.ExistingLanguages*/,
                (item, lang) => !lang.Equals(item.localized.Language.Name, StringComparison.InvariantCultureIgnoreCase)
                    ? new KeyValuePair<string, ContentReference>(lang, item.Key)
                    : (KeyValuePair<string, ContentReference>?)null)
            .Where(x => x != null)
            .GroupBy(x => x!.Value.Key, x => x!.Value);

        // Load content by culture & map data to localized site entry.
        foreach (var group in contentLinksByCulture)
        {
            var cultureInfoForGroup = CultureInfo.GetCultureInfo(group.Key);
            var contentLinks = group.Select(x => x.Value).ToArray();
            var languageLoaderOption = new LoaderOptions { LanguageLoaderOption.Fallback(cultureInfoForGroup) };
            var items = ContentLoader.GetItems(contentLinks, languageLoaderOption);

            foreach (var item in items)
            {
                if (!itemPerId.TryGetValue(item.ContentLink.ToReferenceWithoutVersion(), out var contentItem) || item is not ILocalizable localized)
                    continue;

                contentItem.Localized[cultureInfoForGroup.Name] = item;
            }
        }
    }

    /// <summary>
    /// Determine the languages a given content item will resolve content in:
    /// * by direct language version
    /// * by language fallback setting
    /// </summary>
    protected virtual IReadOnlyCollection<string> DetermineCultureInfos(
        ContentReference forContent,
        ILocalizable? localizable)
    {
        var result = new HashSet<string>();

        if (localizable != null)
        {
            foreach (var asLocalizableExistingLanguage in localizable.ExistingLanguages)
            {
                result.Add(asLocalizableExistingLanguage.Name);
            }
        }

        foreach (var fallback in ContentLanguageSettingsHandler.Get(forContent))
        {
            result.Add(fallback.LanguageBranch);
        }

        return result;
    }
}