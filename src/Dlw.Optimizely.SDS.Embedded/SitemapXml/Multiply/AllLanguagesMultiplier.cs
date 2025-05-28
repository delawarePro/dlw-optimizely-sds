using Dlw.Optimizely.Sds;
using Dlw.Optimizely.SDS.Shared.Utilities;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Multiply;

public class AllLanguagesMultiplier : IMultiplier
{
    public string[] AllLanguages { get; }

    public AllLanguagesMultiplier(string[] allLanguages)
    {
        AllLanguages = allLanguages;
    }

    public IAsyncEnumerable<Multiplication> Multiply(ISiteResource source, Multiplication? factor = null)
    {
        return new[]
        {
            // Only return a single multiplication, which will not really multiply ;-)
            new Multiplication(allLanguages: AllLanguages)
        }.ToAsync();
    }
}