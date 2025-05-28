using Dlw.Optimizely.Sds;
using Dlw.Optimizely.SDS.Shared.Models;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml;

/// <summary>
/// Generated URLs for a resource in a website.
/// </summary>
public record SiteResourceUrls(ISiteResource SiteResource, IReadOnlyList<Url> Urls);