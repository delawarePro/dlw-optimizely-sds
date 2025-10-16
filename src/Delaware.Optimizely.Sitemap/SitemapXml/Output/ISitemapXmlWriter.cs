using System.Xml;
using Delaware.Optimizely.Sitemap.Shared.Models;
using Delaware.Optimizely.Sitemap.SitemapXml.Models;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Output;

/// <summary>
/// Interface for writing sitemap files.
/// </summary>
public interface ISitemapXmlWriter
{
    Task WriteSitemapIndex(SitemapIndex index, Stream output);

    Task WriteSitemapHeader(Stream output, XmlWriter xmlWriter);

    Task WriteUrls(IEnumerable<Url> urls, Stream output, XmlWriter xmlWriter);

    Task WriteSitemapFooter(Stream output, XmlWriter xmlWriter);

    XmlWriterSettings GetSettings(bool startNewFile = false);
}