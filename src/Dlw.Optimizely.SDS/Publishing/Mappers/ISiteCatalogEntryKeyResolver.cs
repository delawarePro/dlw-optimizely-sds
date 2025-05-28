using Dlw.Optimizely.SDS.Client;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing.Mappers;

public interface ISiteCatalogEntryKeyResolver
{
    SiteCatalogEntryKey Resolve(string siteId, IContent content, IOperationContext context);
}