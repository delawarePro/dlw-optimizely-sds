using Delaware.Optimizely.Sitemap.Shared.Models;
using EPiServer.Applications;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Storage;

public interface ISitemapXmlStorageProvider
{
    public string Store(InProcessWebsite application, SitemapLanguageGroup languageGroup,
        Stream inputStream, int pageNumber, bool isDelta);
}