using System.Globalization;
using Delaware.Optimizely.Sitemap.Core.Client;
using EPiServer;
using EPiServer.Applications;
using EPiServer.Core;
using EPiServer.Core.Routing.Internal;
using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap.Core.Publishing.Mappers;

/// <summary>
/// Maps Optimizely content, both pages and blocks.
/// </summary>
public class DefaultSiteCatalogEntryMapper : AbstractSiteCatalogEntryMapper
{
    private readonly IContentUrlGenerator _contentUrlResolver;

    public DefaultSiteCatalogEntryMapper(
        IContentLoader contentLoader,
        IPublishedStateAssessor publishedStateAssessor,
        ISiteCatalogEntryKeyResolver siteCatalogEntryKeyResolver,
        IContentUrlGenerator contentUrlResolver)
        : base(contentLoader, publishedStateAssessor, siteCatalogEntryKeyResolver)
    {
        _contentUrlResolver = contentUrlResolver;
    }

    protected override void Map(SiteCatalogItem item, SiteCatalogEntry entry, InProcessWebsite application, IOperationContext context)
    {
        // Try to use publish date as 'modified date'.
        if (item.Content is PageData page)
        {
            entry.Modified = page.StartPublish?.ToUniversalTime();
        }

        // Fall back to 'saved' - if possible.
        if (item.Content is IChangeTrackable changeTrackable)
        {
            entry.Modified = changeTrackable.Saved;
        }

        entry.ContentTypeId = item.Content.ContentTypeID;
    }

    protected override void Map(string locale, IContent content, LocalizedSiteCatalogEntry entry, InProcessWebsite application, IOperationContext context)
    {
        var culture = CultureInfo.GetCultureInfo(locale);

        var hosts = application.GetHosts(culture, true);
        var host =  hosts.FirstOrDefault((ApplicationHost h) => h.Type == ApplicationHostType.Primary) ?? hosts.FirstOrDefault((ApplicationHost h) => h.Type == ApplicationHostType.Default);

        var options = new UrlGeneratorOptions()
            .SetContextMode(ContextMode.Default)
            .SetForceCanonicalUrl()
            .SetForceAbsoluteUrl()
            .SetLanguage(culture)
            .SetCurrentHost(host?.Url?.Authority);

        var generatedUrl = _contentUrlResolver.Generate(content.ContentLink, options);

        if (generatedUrl == null)
        {
            return;
        }

        var url = generatedUrl.Url;

        var path = url?.IsAbsoluteUri == true ? url.PathAndQuery : url?.ToString();
        var isStartPage = path != null && path.Equals($"/{locale}", StringComparison.OrdinalIgnoreCase);

        if (string.IsNullOrEmpty(path))
        {
            return;
        }

        entry.Url = isStartPage ? url?.Host : url?.ToString();
    }
}