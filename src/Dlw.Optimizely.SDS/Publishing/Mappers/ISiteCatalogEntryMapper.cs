using Dlw.Optimizely.SDS.Client;

namespace Dlw.Optimizely.Sds.Publishing.Mappers;

public interface ISiteCatalogEntryMapper
{
    SiteCatalogEntry Map(string siteName, SiteCatalogItem item, IOperationContext context);
}