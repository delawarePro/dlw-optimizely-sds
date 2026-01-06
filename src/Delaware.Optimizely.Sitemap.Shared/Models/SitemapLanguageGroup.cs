using static System.String;

namespace Delaware.Optimizely.Sitemap.Shared.Models;

/// <summary>
/// Represents a group of languages for sitemap generation.
/// </summary>
/// <param name="Key">Unique name for the group.></param>
/// <param name="Languages">The languages for the group.</param>
public record SitemapLanguageGroup(SitemapLanguageGroupKey Key, IReadOnlyCollection<string> Languages);

/// <summary>
/// Represents a key for a <see cref="SitemapLanguageGroup"/>.
/// </summary>
/// <param name="Value"></param>
public record SitemapLanguageGroupKey(string Value)
{
    public static implicit operator string(SitemapLanguageGroupKey key) => key.Value;

    public static implicit operator SitemapLanguageGroupKey(string? value) => new(value ?? Empty);

    public override string ToString() => Value;
}