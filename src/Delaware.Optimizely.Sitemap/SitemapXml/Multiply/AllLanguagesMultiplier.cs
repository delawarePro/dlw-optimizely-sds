using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Shared.Utilities;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Multiply;

public class AllLanguagesMultiplier(string[] allLanguages) : IMultiplier
{
    public string[] AllLanguages { get; } = allLanguages;

    public IAsyncEnumerable<Multiplication> Multiply(ISiteResource source, Multiplication? factor = null)
    {
        return new[]
        {
            // Only return a single multiplication, which will not really multiply ;-)
            new Multiplication(allLanguages: AllLanguages)
        }.ToAsync();
    }
}