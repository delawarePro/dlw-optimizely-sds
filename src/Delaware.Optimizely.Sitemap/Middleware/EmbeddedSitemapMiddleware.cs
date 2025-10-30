using System.IO.Compression;
using Delaware.Optimizely.Sitemap.Client;
using Delaware.Optimizely.Sitemap.Core.Extensions;
using Delaware.Optimizely.Sitemap.Shared.Models;
using Delaware.Optimizely.Sitemap.SitemapXml.Models;
using Delaware.Optimizely.Sitemap.SitemapXml.Output;
using EPiServer;
using EPiServer.Core;
using EPiServer.Framework.Blobs;
using EPiServer.Web;
using EPiServer.Web.Routing;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

namespace Delaware.Optimizely.Sitemap.Middleware;

public class EmbeddedSitemapMiddleware(
    RequestDelegate next,
    ISitemapXmlWriter sitemapXmlWriter,
    IEmbeddedSiteCatalogClient embeddedSiteCatalogClient,
    IUrlResolver urlResolver,
    IOptions<EmbeddedSitemapOptions> options)
{
    public async Task InvokeAsync(HttpContext context)
    {
        SitemapState state;

        if (context.Request.Path.StartsWithSegments(options.Value.SitemapEntryPath, StringComparison.InvariantCultureIgnoreCase))
        {
            state = embeddedSiteCatalogClient.GetState(SiteDefinition.Current.Name);

            // Serve sitemap index.
            await WriteSitemapIndexAsync(context, state);

            context.Request.ContentType = "text/xml";

            return;
        }

        if (context.Request.Path.Value != null && context.Request.Path.Value.EndsWith(".xml"))
        {
            state = embeddedSiteCatalogClient.GetState(SiteDefinition.Current.Name);

            // Serve sitemap page.
            if (TryParseSitemapPageNumber(context.Request.Path, out var sitemapPageIndex, out var isDelta)
                && isDelta != null && sitemapPageIndex != null)
            {
                if (TryGetPageLocation(state, isDelta.Value, sitemapPageIndex.Value, out var location)
                    && location != null
                    && TryGetMediaByUrl(location, out var blob)
                    && blob != null)
                {
                    await using var stream = blob.OpenRead();
                    await using var gzipStream = new GZipStream(context.Response.Body, CompressionMode.Compress);

                    context.Response.ContentType = "application/xml"; 
                    context.Response.Headers["Content-Encoding"] = "gzip";

                    await stream.CopyToAsync(gzipStream);

                    return;
                }
            }
        }

        await next(context);
    }

    #region Helper Methods

    private bool TryGetMediaByUrl(string location, out Blob? blob)
    {
        if (string.IsNullOrWhiteSpace(location))
        {
            blob = null;

            return false;
        }
        var content = urlResolver.Route(new UrlBuilder(location));

        if (content is MediaData mediaData)
        {
            blob = mediaData.BinaryData;

            return true;
        }

        blob = null;

        return false;
    }

    private static bool TryGetPageLocation(SitemapState state, bool isDelta, int sitemapPageIndex, out string? location)
    {
        location = null;

        if (isDelta)
        {
            if (state.DeltaPages.TryGetValue(sitemapPageIndex, out var delta))
            {
                location = delta;
                return true;
            }

            return false;
        }

        if (state.FullPages.TryGetValue(sitemapPageIndex, out var page))
        {
            location = page;

            return true;
        }

        return false;
    }

    private static bool TryParseSitemapPageNumber(PathString path, out int? sitemapIndex, out bool? isDelta)
    {
        if (path == null || string.IsNullOrWhiteSpace(path.Value))
        {
            sitemapIndex = null;
            isDelta = false;

            return false;
        }

        var possiblePageNumberString = path.Value.Split('/').Last().Replace(".xml", string.Empty);

        if (possiblePageNumberString.StartsWith("d", StringComparison.InvariantCultureIgnoreCase))
        {
            possiblePageNumberString = possiblePageNumberString.Replace("d", string.Empty, StringComparison.InvariantCultureIgnoreCase);
            isDelta = true;
        }
        else
        {
            isDelta = false;
        }

        if (int.TryParse(possiblePageNumberString, out var pageMapIndex))
        {
            sitemapIndex = pageMapIndex;

            return true;
        }

        sitemapIndex = null;
        isDelta = null;

        return false;
    }

    private async Task<bool> WriteSitemapIndexAsync(HttpContext context, SitemapState state)
    {
        var totalEntryCount = embeddedSiteCatalogClient.GetCatalogEntryCount(SiteDefinition.Current.Name);

        if (totalEntryCount <= 0)
        {
            return false;
        }

        var sitemapUrls = GenerateSitemapUrls(SiteDefinition.Current.SiteUrl, state);
        var index = new SitemapIndex(sitemapUrls.ToList());

        using var memory = new MemoryStream();

        // Write the XML.
        await sitemapXmlWriter.WriteSitemapIndex(index, memory);

        memory.Seek(0, SeekOrigin.Begin); // Reset the stream position.

        // Convert stream to string.
        using var reader = new StreamReader(memory);
        var result = await reader.ReadToEndAsync();

        // Ensure no caching.
        EnsureNoCaching(context);

        await context.Response.WriteAsync(result);

        return true;
    }

    private static void EnsureNoCaching(HttpContext httpContext)
    {
        httpContext.Response.Headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0";
        httpContext.Response.Headers["Pragma"] = "no-cache";
        httpContext.Response.Headers["Expires"] = "0";
    }

    private static IEnumerable<SitemapUrl> GenerateSitemapUrls(Uri baseUrl, SitemapState? state)
    {
        if (state == null || state.FullPages.Count <= 0)
        {
            yield break;
        }

        var cleanBaseUrl = baseUrl.ToString().EnsureEndsWithSuffix("/");

        var i = 0;

        foreach (var page in state.FullPages.Values)
        {
            yield return new SitemapUrl($"{cleanBaseUrl}sitemap/{i++}.xml");
        }

        i = 0;

        foreach (var deltaPageUrl in state.DeltaPages.Values)
        {
            yield return new SitemapUrl($"{cleanBaseUrl}sitemap/d{i++}.xml");
        }
    }

    #endregion
}