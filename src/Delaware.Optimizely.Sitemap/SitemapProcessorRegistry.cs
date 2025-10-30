namespace Delaware.Optimizely.Sitemap;

public class SitemapProcessorRegistry : ISitemapProcessorRegistry
{
    public IList<ISiteResourceProcessor> Processors { get; } = new List<ISiteResourceProcessor>();
}