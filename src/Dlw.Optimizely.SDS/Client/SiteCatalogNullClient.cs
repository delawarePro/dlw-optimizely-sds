using Dlw.Optimizely.Sds.Publishing;

namespace Dlw.Optimizely.SDS.Client
{
    public class SiteCatalogNullClient : ISiteCatalogClient
    {
        public void UpdateCatalog(string siteId, SiteCatalogEntriesResult entriesResult)
        {
            throw new InvalidOperationException(
                $"No valid {nameof(ISiteCatalogClient)} instance was configured. " +
                $"Either upgrade to the full SDS setup or enable the embedded client - see README.md for details.");
        }
    }
}
