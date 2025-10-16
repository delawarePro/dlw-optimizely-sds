using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Shared.Models;

namespace Delaware.Optimizely.Sitemap.SitemapXml;

/// <summary>
/// Generated URLs for a resource in a website.
/// </summary>
public record SiteResourceUrls(ISiteResource SiteResource, IReadOnlyList<Url> Urls);