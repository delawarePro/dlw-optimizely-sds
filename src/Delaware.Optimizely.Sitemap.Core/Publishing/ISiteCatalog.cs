using Delaware.Optimizely.Sitemap.Shared.Models;
using EPiServer.Core;
using EPiServer.Web;

namespace Delaware.Optimizely.Sitemap.Core.Publishing;

public interface ISiteCatalog
{
    string SiteId { get; }

    SiteDefinition SiteDefinition { get; }

    IReadOnlyCollection<SitemapLanguageGroup> LanguageGroups { get; }

    Task<SiteCatalogEntriesResult> GetPageEntries(IOperationContext context, ContentReference rootPage, string? continuationToken = null);
    
    Task<SiteCatalogEntriesResult> GetBlockEntries(IOperationContext context, string? next = null);

    Task<SiteCatalogEntriesResult> GetEntries(IOperationContext context, params IContent[] contentItems);

    IList<int> GetBlockRoots();

    /// <summary>
    /// Tries to get the matching <see cref="SitemapLanguageGroup"/> for a given <see cref="SitemapLanguageGroupKey"/>.
    /// </summary>
    /// <param name="key">The language group key.</param>
    /// <param name="languageGroup">The matching language group.</param>
    /// <returns>True if found.</returns>
    bool TryGetLanguageGroup(SitemapLanguageGroupKey key, out SitemapLanguageGroup? languageGroup);
}