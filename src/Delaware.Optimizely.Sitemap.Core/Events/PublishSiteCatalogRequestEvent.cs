using System.Runtime.Serialization;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using EPiServer.Events;

namespace Delaware.Optimizely.Sitemap.Core.Events;

[DataContract]
[EventData("059399ef-cb1e-4409-a908-d88a6916bb3c", Broadcast = true)]
public sealed class PublishSiteCatalogRequestEvent : IEventData
{
    public PublishSiteCatalogRequestEvent(string siteId)
    {
        SiteId = siteId;
    }

    public PublishSiteCatalogRequestEvent(ISiteCatalog siteCatalog)
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
