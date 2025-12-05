using Delaware.Optimizely.Sitemap.Shared.Models;

namespace Delaware.Optimizely.Sitemap.Core;

public record SourceSet(
    IReadOnlyCollection<ISiteResource> Resources,
    Source Source,
    SitemapLanguageGroup LanguageGroup);