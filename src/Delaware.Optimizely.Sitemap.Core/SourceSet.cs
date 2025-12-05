namespace Delaware.Optimizely.Sitemap.Core;

public record SourceSet(
    IReadOnlyCollection<ISiteResource> Resources,
    Source Source,
    KeyValuePair<string, IReadOnlyCollection<string>> LanguageGroup);