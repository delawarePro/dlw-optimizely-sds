using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap.Shared.Utilities;

internal class SiteContextSwitcher : IDisposable
{
    private readonly SiteDefinition _originalSite;

    public SiteContextSwitcher(SiteDefinition newSite)
    {
        // Store the original site to restore later
        _originalSite = SiteDefinition.Current;

        // Set the new site context
        SiteDefinition.Current = newSite;
    }

    public void Dispose()
    {
        // Restore the original site context
        SiteDefinition.Current = _originalSite;
    }
}