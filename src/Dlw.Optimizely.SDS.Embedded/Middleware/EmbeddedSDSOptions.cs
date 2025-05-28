namespace Dlw.Optimizely.SDS.Embedded.Middleware;

public class EmbeddedSdsOptions
{
    /// <summary>
    /// Number of locations sections per page.
    /// </summary>
    public int UrlCountPerSitemapPage { get; set; } = 10000; // Default value

    public string SitemapEntryPath { get; set; } = "/sitemap.xml";
}