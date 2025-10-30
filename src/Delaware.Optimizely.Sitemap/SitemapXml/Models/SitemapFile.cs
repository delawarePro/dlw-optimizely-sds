using EPiServer.Core;
using EPiServer.DataAnnotations;
using EPiServer.Framework.DataAnnotations;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Models
{
    [ContentType(
        DisplayName = "Sitemap XML File", 
        GUID = "994C5DF8-5AFC-4B7C-85B7-FFE77C70D04C", 
        Description = "Sitemap XML File")]
    //[MediaDescriptor(ExtensionString = ".sdssitemapxml")]
    public class SitemapFile : MediaData
    {
    }
}
