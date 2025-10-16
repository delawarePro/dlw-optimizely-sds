namespace Delaware.Optimizely.Sitemap;

public interface ISitemapProcessorRegistry
{
    IList<ISiteResourceProcessor> Processors { get; }
}