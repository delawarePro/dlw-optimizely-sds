using System.Runtime.Serialization;
using Dlw.Optimizely.Sds.Publishing;
using EPiServer.Events;

namespace Dlw.Optimizely.Sds.Events;

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