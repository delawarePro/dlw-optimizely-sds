using System.Xml;
using Dlw.Optimizely.SDS.Embedded.SitemapXml.Models;
using Dlw.Optimizely.SDS.Shared.Models;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Output;

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