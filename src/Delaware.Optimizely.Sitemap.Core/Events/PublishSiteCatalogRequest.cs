using System.Runtime.Serialization;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using EPiServer.Events;

namespace Delaware.Optimizely.Sitemap.Core.Events;

[DataContract]
[EventsServiceKnownType]
public class PublishSiteCatalogRequest
{
    public PublishSiteCatalogRequest(ISiteCatalog siteCatalog)
    {
        SiteCatalog = siteCatalog;
    }

    public ISiteCatalog SiteCatalog { get; set; }
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