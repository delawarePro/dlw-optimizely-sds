using Dlw.Optimizely.SDS.Client;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds;

public class DefaultSiteResource : ISiteResource
{
    public readonly ContentReference SourceId;
    public readonly ContentReference ContentTypeId;
    public readonly IDictionary<string, LocalizedSiteCatalogEntry> Localized;
    public readonly DateTime? Archived;
    public readonly DateTime? Modified;

    public DefaultSiteResource(SiteCatalogEntry siteCatalogEntry)
    {
        Localized = siteCatalogEntry.Localized!;
        Archived = siteCatalogEntry.Archived;
        Modified = siteCatalogEntry.Modified;

        if (!ContentReference.TryParse(siteCatalogEntry.SourceId, out var tempSourceId))
        {
            throw new ArgumentException($"Could not parse {siteCatalogEntry.SourceId} to {nameof(ContentReference)}.");
        }

        SourceId = tempSourceId;
        ContentTypeId = new ContentReference(siteCatalogEntry.ContentTypeId!.Value);
    }
}