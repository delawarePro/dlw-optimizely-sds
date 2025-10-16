using Delaware.Optimizely.Sitemap.Core.Publishing;

namespace Delaware.Optimizely.Sitemap.Core.Client
{
    public class SiteCatalogNullClient : ISiteCatalogClient
    {
        public void UpdateCatalog(string siteId, SiteCatalogEntriesResult entriesResult)
        {
            throw new InvalidOperationException(
                $"No valid {nameof(ISiteCatalogClient)} instance was configured. " +
                $"Either upgrade to the full sitemap setup or enable the embedded client - see README.md for details.");
        }
    }
}
