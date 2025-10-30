using Delaware.Optimizely.Sitemap.Shared;
using Delaware.Optimizely.Sitemap.Shared.Models;

namespace Delaware.Optimizely.Sitemap.SitemapXml;

public class LanguageAlternativeOptions
{
    public string? DefaultLanguage { get; set; }
}

public interface ILanguageAlternativesProcessor
{
    Task Process(
        IList<LanguageAlternative> languageAlternatives,
        LanguageAlternativeOptions? options = null
    );
}

/// <summary>
/// Generates language fallback for all languages present in the alternative language collection.
/// For culture variant languages (e.g. nl-BE) an invariant language will be added (e.g. nl) when not present.
/// For the entire set a default (x-default) will be added.
/// 
/// The logic of these fallbacks is implemented according to following rules:
/// - Language for which invariant part and region is the same (e.g. nl-NL) is used as default invariant language.
/// - If such a language is not present, first one (ordered) is taken.
/// 
/// - 'en-US' and 'en' are used as general defaults.
/// - If one of these languages is not present, first one (ordered) is taken.
/// 
/// Customize this processor to your liking ;-)
/// </summary>
public class LanguageAlternativesProcessor : ILanguageAlternativesProcessor
{
    /// <summary>
    /// Whether to generate invariant fallback languages.
    /// If not set, fallback languages will be generated for backwards compatibility.
    /// </summary>
    public bool? IncludeInvariantLanguages { get; set; }

    /// <summary>
    /// Whether to generate an x-default.
    /// If not set, x-default will be included for backwards compatibility.
    /// </summary>
    public bool? IncludeDefault { get; set; }

    protected record LanguageInfo(string Code, string InvariantLanguage, string? Region, LanguageAlternative LanguageAlternative);

    /// <summary>
    /// Default languages in order of importance.
    /// This will be used to set the 'x-default' alternative language.
    /// </summary>
    public IReadOnlyCollection<string> DefaultLanguages { get; set; } = new[] { "en-US", "en" };

    public Task Process(
        IList<LanguageAlternative>? languageAlternatives,
        LanguageAlternativeOptions? options = null)
    {
        if (languageAlternatives == null || languageAlternatives.Count <= 0)
            return Task.CompletedTask;

        if (IncludeInvariantLanguages != false)
        {
            foreach (var group in GroupByInvariantLanguage(languageAlternatives))
            {
                var defaultInvariant = FindDefaultInvariant(group.Key, group.ToArray());
                if (defaultInvariant != null)
                    AddDefaultInvariant(languageAlternatives, group.Key, defaultInvariant);
            }
        }

        if (IncludeDefault != false)
        {
            // Add 'x-default'.
            var defaultAlternative = FindDefault(languageAlternatives, options);
            if (defaultAlternative != null)
            {
                AddDefault(languageAlternatives, defaultAlternative);
            }
        }

        return Task.CompletedTask;
    }

    protected virtual IReadOnlyCollection<IGrouping<string, LanguageInfo>> GroupByInvariantLanguage(
        IList<LanguageAlternative> languageAlternatives)
    {
        return languageAlternatives
            .Select(a =>
            {
                var parts = a.Language.Split(new[] { '-', '_' }, StringSplitOptions.RemoveEmptyEntries);
                return new LanguageInfo(
                    Code: a.Language,
                    InvariantLanguage: parts[0],
                    Region: parts.Length > 1 ? parts[1] : null,
                    LanguageAlternative: a
                );
            })
            .GroupBy(x => x.InvariantLanguage)
            .ToArray();
    }

    protected LanguageAlternative? FindDefaultInvariant(
        string invariantLanguage,
        IReadOnlyCollection<LanguageInfo>? group)
    {
        if (group == null || group.Count <= 0) return null;

        // Ignore if invariant is already present.
        if (group.Any(x => string.IsNullOrWhiteSpace(x.Region))) return null;

        // Prefer 'main' region, e.g. nl-NL over nl-BE or fr-FR over fr-BE.
        var main = group
            .Where(x => string.Equals(x.InvariantLanguage, x.Region, StringComparison.OrdinalIgnoreCase))
            .FirstOrDefault();
        if (main != null) return main.LanguageAlternative;

        // Fallback to sorting.
        return group
            .OrderBy(x => x.Code)
            .FirstOrDefault()?
            .LanguageAlternative;
    }

    protected virtual void AddDefaultInvariant(
        IList<LanguageAlternative> languageAlternatives,
        string invariantLanguage,
        LanguageAlternative defaultInvariant)
    {
        languageAlternatives.Add(new LanguageAlternative(invariantLanguage, defaultInvariant.Location));
    }

    protected virtual LanguageAlternative? FindDefault(
        IList<LanguageAlternative> languageAlternatives,
        LanguageAlternativeOptions? options = null)
    {
        LanguageAlternative? defaultAlternative = null;

        // Check if default language is specified through options.
        if (!string.IsNullOrWhiteSpace(options?.DefaultLanguage))
        {
            defaultAlternative = languageAlternatives
                .FirstOrDefault(a => string.Equals(a.Language, options.DefaultLanguage, StringComparison.OrdinalIgnoreCase));
        }

        if (defaultAlternative == null)
        {
            // Find best matching default language.
            defaultAlternative = languageAlternatives
                .Select(a => new
                {
                    Alternative = a,
                    Index = DefaultLanguages
                        .Select((d, i) => string.Equals(a.Language, d, StringComparison.OrdinalIgnoreCase) ? i : (int?)null)
                        .FirstOrDefault()
                })
                .OrderBy(x => x.Index.GetValueOrDefault(int.MaxValue))
                .FirstOrDefault()
                ?.Alternative;
        }

        if (defaultAlternative == null)
        {
            // Fallback to available language and try to stabilize by sorting.
            defaultAlternative = languageAlternatives
                .OrderBy(x => x.Language)
                .ThenBy(x => x.Location)
                .FirstOrDefault();
        }

        return defaultAlternative;
    }

    protected virtual void AddDefault(
        IList<LanguageAlternative> languageAlternatives,
        LanguageAlternative defaultAlternative)
    {
        languageAlternatives.Add(new LanguageAlternative(SharedSitemapConstants.DefaultLanguageKey, defaultAlternative.Location));
    }
}