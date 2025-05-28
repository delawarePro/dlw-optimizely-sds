namespace Dlw.Optimizely.SDS.Embedded;

public interface ISitemapProcessorRegistry
{
    IList<ISiteResourceProcessor> Processors { get; }
}