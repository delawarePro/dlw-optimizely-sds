using EPiServer.Core;

namespace Delaware.Optimizely.Sitemap.SitemapXml.DynamicContent;

/// <summary>
/// To add dynamic/external data to the sitemap, which is normally routed to a given page using partial routers,
/// create an implementation for this interface.
/// </summary>
public interface IDynamicContentRootProcessor
{
    /// <summary>
    /// Entry point for expanding dynamic/external content. Considers <param name="pageId">a given page</param>
    /// of <param name="contentTypeId">template</param> a dynamic page to which certain dynamic content is resolved.
    /// This entry point allows to expand this dynamic content.
    /// </summary>
    /// <param name="pageId">The ContentReference of the page currently being processed.</param>
    /// <param name="contentTypeId">The content type ID for the page currently being processed.</param>
    /// <param name="languages">Array of languages for which the page is being processed.
    /// These are the languages set during the configuration of the site catalog.</param>
    /// <returns>
    /// <para>Any implementation will return DynamicContentProcessingResult objects.</para>
    /// <para>The results are aggregated by their <see cref="DynamicContentSourceId"/>,
    /// meaning the order in which they are returned is not important.</para>
    /// <para>OK:
    ///     <list type="bullet">
    ///          <item><description>product1 -> 'en' '/en/products/1'</description></item>
    ///          <item><description>product1 -> 'fr' '/fr/produits/1'</description></item>
    ///          <item><description>product2 -> 'en' '/en/products/2'</description></item>
    ///          <item><description>product2 -> 'fr' '/fr/produits/2'</description></item>
    ///     </list>
    /// </para>
    /// <para>Also OK:
    ///     <list type="bullet">
    ///          <item><description>product1 -> 'en' '/en/products/1'</description></item>
    ///          <item><description>product2 -> 'fr' '/fr/produits/2'</description></item>
    ///          <item><description>product1 -> 'fr' '/fr/produits/1'</description></item>
    ///          <item><description>product2 -> 'en' '/en/products/2'</description></item>
    ///     </list>
    /// </para>
    /// </returns>
    IAsyncEnumerable<DynamicContentProcessingResult?> ExpandForPageAsync(
        ContentReference pageId,
        ContentReference contentTypeId,
        string[] languages);
}