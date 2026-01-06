using Delaware.Optimizely.Sitemap.Shared.Models;
using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Storage;

public interface ISitemapXmlStorageProvider
{
    public string Store(SiteDefinition siteDefinition, SitemapLanguageGroup languageGroup,
        Stream inputStream, int pageNumber, bool isDelta);
}