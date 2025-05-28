namespace Dlw.Optimizely.SDS.Embedded;

public class SitemapProcessorRegistry : ISitemapProcessorRegistry
{
    public IList<ISiteResourceProcessor> Processors { get; } = new List<ISiteResourceProcessor>();
}