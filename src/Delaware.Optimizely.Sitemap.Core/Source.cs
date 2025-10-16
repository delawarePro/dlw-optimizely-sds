namespace Delaware.Optimizely.Sitemap.Core;

/// <summary>
/// Source that provides resources for the site.
/// This is typically the CMS but can also e.g. be a commerce catalog or ODS.
/// </summary>
/// <param name="Id">Identifier of the source.</param>
/// <remarks>SitemapId should not be equal with a SourceId within the same tenant.</remarks>
public record Source(string Id);