using System.Runtime.Serialization;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using EPiServer.Events;

namespace Delaware.Optimizely.Sitemap.Core.Events;

[DataContract]
[EventsServiceKnownType]
public sealed class PublishSiteCatalogRequest
{
    public PublishSiteCatalogRequest(string siteId)
    {
        SiteId = siteId;
    }

    public PublishSiteCatalogRequest(ISiteCatalog siteCatalog)
    {
        SiteCatalog = siteCatalog;
        SiteId = siteCatalog.SiteId;
    }

    [DataMember(Order = 1, IsRequired = true)]
    public string SiteId { get; init; }

    // For backwards compatibility. Site catalog is not serialized in the event, but can be set by the publisher before raising the event.
    // Remove in a future release.
    [IgnoreDataMember]
    public ISiteCatalog? SiteCatalog { get; set; }
}

[DataContract]
[EventsServiceKnownType]
public class PublishSiteCatalogResponse
{
    public PublishSiteCatalogResponse(ISiteCatalog siteCatalog)
    {
        SiteCatalog = siteCatalog;
    }

    public ISiteCatalog SiteCatalog { get; set; }

    public bool Success { get; set; }
}