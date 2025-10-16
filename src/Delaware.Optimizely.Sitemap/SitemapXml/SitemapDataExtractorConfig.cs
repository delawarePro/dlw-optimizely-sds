using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Core.Values;
using Delaware.Optimizely.Sitemap.SitemapXml.Multiply;

namespace Delaware.Optimizely.Sitemap.SitemapXml;

public class SitemapDataExtractorConfig
{
    protected CompositeMultiplier Multipliers { get; } = new();

    /// <summary>
    /// Predicates for which resources this config is applicable.
    /// Null to match all.
    /// </summary>
    protected IDictionary<IValueResolver, object?>? PropertyPredicates { get; set; }

    /// <summary>
    /// Allow multiplication of urls for a single resource.
    /// </summary>
    /// <remarks>This is abstract because it can be quite dependent on the implementation.</remarks>
    public virtual IMultiplier Multiplier => Multipliers;

    /// <summary>
    /// Value resolver to get the modified date.
    /// Returned value should be a nullable DateTime.
    /// </summary>
    public IValueResolver? ModifiedResolver { get; set; }

    /// <summary>
    /// Processor for the alternative languages.
    /// Typically used to add fallback languages.
    /// Pass null to disable.
    /// </summary>
    public ILanguageAlternativesProcessor? LanguageAlternativesProcessor { get; set; } = new LanguageAlternativesProcessor();

    public virtual bool Matches(ISiteResource siteResource)
    {
        if (PropertyPredicates != null)
        {
            if (PropertyPredicates.Any(x => !object.Equals(x.Key.GetValue(siteResource), x.Value)))
                return false;
        }

        return true;
    }

    public SitemapDataExtractorConfig WithMultiplier<T>(T multiplier, Action<T>? configurer = null)
        where T : IMultiplier
    {
        configurer?.Invoke(multiplier);
        Multipliers.Add(multiplier);
        return this;
    }
}