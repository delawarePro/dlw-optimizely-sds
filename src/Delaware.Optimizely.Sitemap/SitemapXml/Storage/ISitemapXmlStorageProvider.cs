using Delaware.Optimizely.Sitemap.Shared.Models;
using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Storage;

public interface ISitemapXmlStorageProvider
{
    public string Store(SiteDefinition siteDefinition, KeyValuePair<string, IReadOnlyCollection<string>> languageGroup,
        Stream inputStream, int pageNumber, bool isDelta);
}