using Delaware.Optimizely.Sitemap.Core;
using Delaware.Optimizely.Sitemap.Shared;
using Delaware.Optimizely.Sitemap.Shared.Models;
using Delaware.Optimizely.Sitemap.Shared.Utilities;
using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.SitemapXml;

public class ConfiguredSitemapDataExtractor : ISitemapDataExtractor
{
    private readonly IContentLanguageSettingsHandler _contentLanguageSettingsHandler;
    protected SitemapDataExtractorConfig[] Configurations { get; }

    public ConfiguredSitemapDataExtractor(
        IContentLanguageSettingsHandler contentLanguageSettingsHandler,
        params SitemapDataExtractorConfig[] configurations)
    {
        if (configurations == null || configurations.Length == 0)
            throw new ArgumentNullException(nameof(configurations));
        _contentLanguageSettingsHandler = contentLanguageSettingsHandler;

        Configurations = configurations;
    }

    public virtual async Task<IReadOnlyList<SiteResourceUrls>> Extract(IReadOnlyCollection<ISiteResource> resources)
    {
        if (resources is null)
            throw new ArgumentNullException(nameof(resources));

        var results = new List<SiteResourceUrls>();
        foreach (var resource in resources)
        {
            var config = Configurations.FirstOrDefault(x => x.Matches(resource));
            if (config == null) continue;

            var urls = await Extract(resource, config);
            if (urls != null) results.Add(urls);
        }

        return results;
    }

    protected virtual async Task<SiteResourceUrls?> Extract(ISiteResource resource, SitemapDataExtractorConfig config)
    {
        var urls = new List<Url>();

        // Track alternative languages for this resource so that we can automatically add language alternatives.
        // Every url should always have all alternatives, even itself.
        // We assume all domains basically show the same content, so they're all alternatives of one another.
        // We don't use this feature for 'old' urls / domains. Redirect should be used for that.
        var languageAlternatives = new List<LanguageAlternative>();
        string? defaultLanguage = null;

        await foreach (var multiplication in config.Multiplier.Multiply(resource))
        {
            // Allow multiplier to configure the default language.
            defaultLanguage ??= multiplication.Variables.GetValueOrDefault(SharedSitemapConstants.DefaultLanguageVariable, null) as string;

            var withFallbackEnabledDefaultLanguage = WithFallbackLanguages(resource, defaultLanguage);
            string? location = null;

            foreach (var possibleDefaultLanguage in withFallbackEnabledDefaultLanguage.Distinct())
            {
                location = GenerateLocation(resource, config, multiplication.Variables, possibleDefaultLanguage);

                if (location != null) break;
            }

            if (location == null) continue;

            // Track language version.
            if (multiplication.AllLanguages?.Length > 0)
            {
                // Generate url for each set language.
                // This supports the case where a resource only contains data for a single language.
                // This will probably result in wrongly localized urls, but we assume url resolving doesn't depend on localized parts.
                // The sitemap is used to discover urls, we assume there's no ranking impact.
                foreach (var language in multiplication.AllLanguages)
                {
                    foreach (var expandedLanguage in WithFallbackLanguages(resource, language).Distinct())
                    {
                        if (expandedLanguage == null) continue;

                        multiplication.Variables[SharedSitemapConstants.LanguageVariable] = expandedLanguage;

                        var alternativeLocation = GenerateLocation(resource, config, multiplication.Variables, expandedLanguage);
                        if (alternativeLocation == null || languageAlternatives.Any(la => la.Location.Equals(alternativeLocation))) continue;

                        languageAlternatives.Add(new LanguageAlternative(expandedLanguage, alternativeLocation));
                    }
                }
            }
            else if (multiplication.Variables.TryGetValue(SharedSitemapConstants.LanguageVariable, out var language))
            {
                // Use dynamically discovered languages from resource.
                // This works when all languages are contained within the resource.
                languageAlternatives.Add(new LanguageAlternative(language!.ToString()!, location));
            }

            var url = CreateUrl(resource, config, languageAlternatives, location);
            urls.Add(url);
        }

        config.LanguageAlternativesProcessor?
            .Process(languageAlternatives, new LanguageAlternativeOptions
            {
                DefaultLanguage = defaultLanguage
            }
        );

        return urls.Count > 0
            ? new SiteResourceUrls(resource, urls)
            : null;
    }

    protected virtual IEnumerable<string?> WithFallbackLanguages(ISiteResource resource, string? language)
    {
        if (resource is DefaultSiteResource defaultSiteResource)
        {
            var settings =
                _contentLanguageSettingsHandler.Get(defaultSiteResource.SourceId);

            foreach (var contentLanguageSetting in settings.Where(cl => cl.LanguageBranch.Equals(language)))
            {
                foreach (string s in contentLanguageSetting.LanguageBranchFallback)
                {
                    yield return s;
                }
            }
        }

        yield return language;
    }

    protected virtual Url CreateUrl(ISiteResource resource,
        SitemapDataExtractorConfig config,
        List<LanguageAlternative> languageAlternatives,
        string location)
    {
        return new Url(location)
        {
            Modified = (DateTime?)config.ModifiedResolver?.GetValue(resource),
            // Don't copy list, track reference because alternatives might be added during next iteration.
            LanguageAlternatives = languageAlternatives
        };
    }

    protected virtual string? GenerateLocation(
        ISiteResource resource,
        SitemapDataExtractorConfig config,
        IDictionary<string, object?> variables,
        string? language)
    {
        if (resource is DefaultSiteResource optimizelySiteResource)
        {
            if (optimizelySiteResource.Localized.Count <= 0)
            {
                return null;
            }

            if (language == null)
            {
                language = optimizelySiteResource.Localized.Keys.First();
            }

            if (optimizelySiteResource.Localized.TryGetValue(language, out var value))
            {
                return value.Url;
            }
        }

        return null;
    }
}