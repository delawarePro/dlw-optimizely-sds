using Dlw.Optimizely.SDS.Embedded.SitemapXml.Models;
using Dlw.Optimizely.SDS.Shared.Models;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Output;

/// <summary>
/// Interface for writing sitemap files.
/// </summary>
public interface ISitemapXmlWriter
{
    Task WriteSitemapIndex(SitemapIndex index, Stream output);

    Task WriteSitemapHeader(Stream output);

    Task WriteUrls(IEnumerable<Url> urls, Stream output);

    Task WriteSitemapFooter(Stream output);
}