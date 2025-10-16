using Delaware.Optimizely.Sitemap.Core;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Multiply;

/// <summary>
/// Allows generating multiple urls for a single resource.
/// </summary>
public interface IMultiplier
{
    /// <summary>
    /// Generates a set of variables for each url that has to be generated.
    /// </summary>
    /// <param name="source">Source resource to generate urls for.</param>
    /// <param name="factor">Optional multiplication that this multiplication is multiplied with.</param>
    /// <returns>Async stream of multiplication result (variables) for which to generate a url.</returns>
    /// <remarks>
    /// Returning no result, simulates multiplication with 0, which will result in skipping the source entirely.
    /// Returning a single result doesn't really multiply of course, but it allows injecting variables.
    /// </remarks>
    IAsyncEnumerable<Multiplication> Multiply(ISiteResource source, Multiplication? factor = null);
}