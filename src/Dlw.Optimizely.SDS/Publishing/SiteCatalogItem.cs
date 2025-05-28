using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing;

public class SiteCatalogItem
{
    public IContent Content { get; }

    public IDictionary<string, IContent> Localized { get; }

    public SiteCatalogItem(IContent content)
    {
        Content = content;
        Localized = new Dictionary<string, IContent>(StringComparer.OrdinalIgnoreCase);

        if (content is ILocalizable localizable)
            Localized[localizable.Language.Name] = content;
    }
}