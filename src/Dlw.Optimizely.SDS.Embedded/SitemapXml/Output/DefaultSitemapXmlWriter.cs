using System.Text;
using System.Xml;
using Dlw.Optimizely.SDS.Embedded.SitemapXml.Models;
using Dlw.Optimizely.SDS.Shared.Models;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Output;

public class DefaultSitemapXmlWriter : ISitemapXmlWriter
{
    private const string _sitemapNs = "http://www.sitemaps.org/schemas/sitemap/0.9";
    private const string _xhtmlNs = "http://www.w3.org/1999/xhtml/";
    private const string _xsiNs = "http://www.w3.org/2001/XMLSchema-instance";
    private const string _schemaLocation = "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd http://www.w3.org/1999/xhtml http://www.w3.org/2002/08/xhtml/xhtml1-strict.xsd";

    public async Task WriteSitemapIndex(SitemapIndex index, Stream output)
    {
        var settings = GetSettings(startNewFile: true);

        await using var xmlWriter = XmlWriter.Create(output, settings);

        await xmlWriter.WriteStartDocumentAsync();

        xmlWriter.WriteStartElement("sitemapindex", _sitemapNs);

        foreach (var sitemap in index.Sitemaps)
        {
            xmlWriter.WriteStartElement("sitemap");

            Write(sitemap, xmlWriter);

            await xmlWriter.WriteEndElementAsync();
        }

        await xmlWriter.WriteEndElementAsync();

        await xmlWriter.WriteEndDocumentAsync();

        await xmlWriter.FlushAsync();
    }

    public async Task WriteSitemapHeader(Stream output, XmlWriter xmlWriter)
    {
        await xmlWriter.WriteStartDocumentAsync();

        xmlWriter.WriteStartElement("urlset", _sitemapNs);
        await xmlWriter.WriteAttributeStringAsync("xmlns", "xhtml", null, _xhtmlNs);
        await xmlWriter.WriteAttributeStringAsync("xmlns", "xsi", null, _xsiNs);
        await xmlWriter.WriteAttributeStringAsync("xsi", "schemaLocation", _xsiNs, _schemaLocation);

        await xmlWriter.WriteRawAsync("\n");

        await xmlWriter.FlushAsync();
    }

    public async Task WriteSitemapFooter(Stream output, XmlWriter xmlWriter)
    {
        await xmlWriter.WriteRawAsync("\n</urlset>");
        await xmlWriter.FlushAsync();
    }

    public async Task WriteUrls(IEnumerable<Url> urls, Stream output, XmlWriter xmlWriter)
    {
        foreach (var url in urls)
        {
            xmlWriter.WriteStartElement("url");

            Write(url, xmlWriter);

            await xmlWriter.WriteEndElementAsync();

            await xmlWriter.FlushAsync();
        }
    }

    protected virtual void Write<T>(T url, XmlWriter writer)
        where T : AbstractUrl
    {
        writer.WriteElementString("loc", url.Location);

        if (url.Modified.HasValue)
            writer.WriteElementString("lastmod", url.Modified.Value.ToString("O"));

        if (url is Shared.Models.Url fullUrl)
        {
            foreach (var alternative in fullUrl.LanguageAlternatives ?? Enumerable.Empty<LanguageAlternative>())
            {
                Write(alternative, writer);
            }
        }
    }

    protected virtual void Write(LanguageAlternative alternative, XmlWriter writer)
    {
        writer.WriteStartElement("xhtml", "link", _xhtmlNs);

        writer.WriteAttributeString("rel", "alternate");
        writer.WriteAttributeString("hreflang", alternative.Language);
        writer.WriteAttributeString("href", alternative.Location);

        writer.WriteEndElement();
    }

    public virtual XmlWriterSettings GetSettings(bool startNewFile = false)
    {
        return new XmlWriterSettings
        {
            Async = true,
            CloseOutput = false,

            // Only write encoding Byte Order Mark when starting a new file.
            Encoding = startNewFile ? Encoding.UTF8 : new UTF8Encoding(false),

            OmitXmlDeclaration = !startNewFile,

            // We need document to write the xml declaration.
            ConformanceLevel = startNewFile ? ConformanceLevel.Document : ConformanceLevel.Fragment,

            Indent = true,
            WriteEndDocumentOnClose = false
        };
    }
}