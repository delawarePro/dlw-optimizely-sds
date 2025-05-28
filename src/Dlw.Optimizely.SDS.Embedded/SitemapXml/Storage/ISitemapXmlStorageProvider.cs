using Dlw.Optimizely.SDS.Shared.Models;
using EPiServer.Web;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Storage;

public interface ISitemapXmlStorageProvider
{
    public string Store(SiteDefinition siteDefinition, Stream inputStream, int pageNumber, bool isDelta);

    public void Clean(SiteDefinition siteDefinition, SitemapState forState);
}