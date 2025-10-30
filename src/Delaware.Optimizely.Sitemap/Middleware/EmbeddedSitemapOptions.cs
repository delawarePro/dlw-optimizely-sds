namespace Delaware.Optimizely.Sitemap.Middleware;

public class EmbeddedSitemapOptions
{
    /// <summary>
    /// Number of locations sections per page.
    /// </summary>
    public int UrlCountPerSitemapPage { get; set; } = 10000; // Default value

    public string SitemapEntryPath { get; set; } = "/sitemap.xml";
}