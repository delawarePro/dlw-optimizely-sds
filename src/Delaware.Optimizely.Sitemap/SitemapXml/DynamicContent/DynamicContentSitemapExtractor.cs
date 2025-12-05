using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Core.Extensions;
using Delaware.Optimizely.Sitemap.Shared.Models;

namespace Delaware.Optimizely.Sitemap.SitemapXml.DynamicContent;

public class DynamicContentSitemapExtractor(IList<IDynamicContentRootProcessor> processors) : ISitemapDataExtractor
{
    /// <summary>
    /// Processor for the alternative languages.
    /// Typically used to add fallback languages.
    /// Pass null to disable.
    /// </summary>
    public ILanguageAlternativesProcessor? LanguageAlternativesProcessor { get; set; } = new LanguageAlternativesProcessor();

    #region ISitemapDataExtractor

    public async Task<IReadOnlyList<SiteResourceUrls>> Extract(SourceSet sourceSet)
    {
        if (sourceSet == null) throw new ArgumentNullException(nameof(sourceSet));
        
        var resources = sourceSet.Resources;

        var results = new List<SiteResourceUrls>();

        // Iterate all site resources, check if content can be dynamically expanded.
        foreach (var siteResource in resources)
        {
            if (!CanHandle(siteResource, out var optimizelySiteResource) || optimizelySiteResource == null)
            {
                continue;
            }

            // Iterate all registered processors to add dynamic content.
            foreach (var dynamicContentRootExpander in processors)
            {
                // For readability:
                var pageId = optimizelySiteResource.SourceId;
                var contentTypeId = optimizelySiteResource.ContentTypeId;
                var languages = optimizelySiteResource.Localized?.Keys.ToArray();

                var expandResultsForPage = new Dictionary<DynamicContentSourceId, List<IntermediateExpandResult>>();

                // Fetch dynamic content. Note: the expander implementation can return results in a seemingly
                // random order (e.g.: iterate some tree or repo language by language, ...).
                // Therefor, wait for all results to be aggregated so they can be grouped correctly:
                // - this avoids duplicates
                // - this allows for language alternatives grouped together.
                await foreach (var expandResult in dynamicContentRootExpander.ExpandForPageAsync(pageId, contentTypeId, languages!))
                {
                    if (expandResult == null || string.IsNullOrWhiteSpace(expandResult.Path))
                    {
                        // Expanding this page yielded no result.
                        continue;
                    }

                    // Lookup the base url for the dynamic content in language.
                    if (!optimizelySiteResource.Localized!.ContainsKey(expandResult.Language))
                    {
                        // Should not happen, really.
                        continue;
                    }

                    // Determine the base URL, typically the '*' page.
                    var baseUrlInLanguage = optimizelySiteResource.Localized[expandResult.Language].Url;

                    // Build an URL for the returned result: relative (default) or absolute.
                    var tempUri =
                        expandResult.PathType == DynamicContentPathType.Relative
                            ? new Uri($"{baseUrlInLanguage?.EnsureEndsWithSuffix("/")}{expandResult.Path.EnsureNoPrefix("/")}")
                            : new Uri(expandResult.Path, UriKind.Absolute);

                    var urlForLanguage = new IntermediateExpandResult(expandResult.Language, tempUri);

                    // Add to the intermediate result map.
                    if (!expandResultsForPage.ContainsKey(expandResult.DynamicContentSourceId))
                    {
                        expandResultsForPage[expandResult.DynamicContentSourceId] = [urlForLanguage];
                    }
                    else
                    {
                        expandResultsForPage[expandResult.DynamicContentSourceId].Add(urlForLanguage);
                    }
                }

                // Now the results can be safely grouped by the dynamic content they were generated for.
                // The key of the map is the dynamic content ID.
                foreach (var forPage in expandResultsForPage)
                {
                    // The first one is assumed the default language one, the others the alternatives.
                    var assumedUrlInDefaultLanguage = forPage.Value.FirstOrDefault();
                    var languageAlternatives =
                        forPage.Value.Any()
                            ? forPage
                                .Value
                                .Select(v => new LanguageAlternative(v.Language, v.Uri.ToString()))
                                .ToList()
                            : [];
                    
                    if (assumedUrlInDefaultLanguage == null) continue;

                    Url urlDefaultLanguage = new Url(assumedUrlInDefaultLanguage.Uri.ToString());
                    var defaultLanguage = assumedUrlInDefaultLanguage.Language;

                    // Alternate language links for dynamic content.
                    LanguageAlternativesProcessor?
                        .Process(languageAlternatives, new LanguageAlternativeOptions { DefaultLanguage = defaultLanguage });

                    urlDefaultLanguage.LanguageAlternatives = languageAlternatives;

                    results.Add(new SiteResourceUrls(siteResource, new List<Url> { urlDefaultLanguage }));
                }
            }
        }

        return results;
    }

    #endregion ISitemapDataExtractor

    #region Helper Methods

    private static bool CanHandle(ISiteResource siteResource, out DefaultSiteResource? optimizelySiteResource)
    {
        if (siteResource is not DefaultSiteResource asOptimizelySiteResource)
        {
            // Can only handle OptimizelySiteResource items.
            optimizelySiteResource = null;

            return false;
        }

        optimizelySiteResource = asOptimizelySiteResource;

        return true;
    }

    #endregion Helper Methods

    #region Nested Type: IntermediateExpandMapping

    /// <summary>
    /// Intermediate result class to keep track of an URL and the language it was generated for.
    /// </summary>
    internal record IntermediateExpandResult(string Language, Uri Uri);

    #endregion
}