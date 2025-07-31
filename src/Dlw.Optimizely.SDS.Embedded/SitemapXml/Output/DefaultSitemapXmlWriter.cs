using System.Text;
using System.Xml;
using Dlw.Optimizely.SDS.Embedded.SitemapXml.Models;
using Dlw.Optimizely.SDS.Shared.Models;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Output
{
    public class DefaultSitemapXmlWriter : ISitemapXmlWriter
    {
        private const string SitemapNs = "http://www.sitemaps.org/schemas/sitemap/0.9";
        private const string XhtmlNs = "http://www.w3.org/1999/xhtml";

        public async Task WriteSitemapIndex(SitemapIndex index, Stream output)
        {
            var settings = GetSettings(startNewFile: true);

            await using var xmlWriter = XmlWriter.Create(output, settings);

            await xmlWriter.WriteStartDocumentAsync();

            xmlWriter.WriteStartElement("sitemapindex", SitemapNs);

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

        public async Task WriteSitemapHeader(Stream output)
        {
            var settings = GetSettings(startNewFile: true);

            await using var xmlWriter = XmlWriter.Create(output, settings);
            await xmlWriter.WriteStartDocumentAsync();

            xmlWriter.WriteStartElement("urlset", SitemapNs);
            await xmlWriter.WriteAttributeStringAsync("xmlns", "xhtml", null, XhtmlNs);

            await xmlWriter.WriteRawAsync("\n");

            await xmlWriter.FlushAsync();
        }

        public async Task WriteSitemapFooter(Stream output)
        {
            await using var xmlWriter = XmlWriter.Create(output, GetSettings());
            await xmlWriter.WriteRawAsync("\n</urlset>");
            await xmlWriter.FlushAsync();
        }

        public async Task WriteUrls(IEnumerable<Shared.Models.Url> urls, Stream output)
        {
            await using var xmlWriter = XmlWriter.Create(output, GetSettings());

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
            writer.WriteStartElement("xhtml", "link");

            writer.WriteAttributeString("rel", "alternate");
            writer.WriteAttributeString("hreflang", alternative.Language);
            writer.WriteAttributeString("href", alternative.Location);

            writer.WriteEndElement();
        }

        protected virtual XmlWriterSettings GetSettings(bool startNewFile = false)
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
}
