using Delaware.Optimizely.Sitemap.Shared.Models;
using Delaware.Optimizely.Sitemap.SitemapXml.Models;
using EPiServer;
using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAccess;
using EPiServer.Framework.Blobs;
using EPiServer.Security;
using EPiServer.Web;
using EPiServer.Web.Routing;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Storage;

/// <summary>
/// Stores generated sitemap XML files as .sdssitemapxml media blocks.
/// Note: there is no default media type for .xml files. Introducing a .xml media type for storing sitemaps,
/// would link .xml media types to sitemap items for all XML files - hence: .sdssitemapxml
/// </summary>
public class DefaultSitemapXmlStorageProvider(
    IContentRepository contentRepository,
    IBlobFactory blobFactory,
    IUrlResolver urlResolver,
    IContentTypeRepository contentTypeRepository,
    ILoggerFactory loggerFactory)
    : ISitemapXmlStorageProvider
{
    private readonly ILogger _logger = loggerFactory.CreateLogger<DefaultSitemapXmlStorageProvider>();

    private ContentReference? _sitemapRootForSite;
    private ContentType? _sitemapMediaContentType;

    public string Store(SiteDefinition siteDefinition, Stream inputStream, int pageNumber, bool isDelta)
    {
        EnsureInitialized(siteDefinition);

        var urlSegment = $"{(isDelta ? "D" : string.Empty)}{pageNumber}";
        var existing = contentRepository.GetBySegment(_sitemapRootForSite, urlSegment,
            LanguageSelector.MasterLanguage());

        if (existing != null)
        {
            try
            {
                contentRepository.Delete(existing.ContentLink, true, AccessLevel.NoAccess);
            }
            catch
            {
                _logger.LogWarning($"Could not delete sitemap XML page file.");
            }
        }

        var file = contentRepository.GetDefault<MediaData>(_sitemapRootForSite, _sitemapMediaContentType!.ID);
        file.Name = urlSegment;

        var blob = blobFactory.CreateBlob(file.BinaryDataContainer, Constants.SdsSitemapFileExtension);
        inputStream.Seek(0, SeekOrigin.Begin);
        blob.Write(inputStream);
        inputStream.Seek(0, SeekOrigin.Begin);

        file.BinaryData = blob;

        contentRepository.Save(file, SaveAction.Publish, AccessLevel.NoAccess);

        var urlResolverArgs = new UrlResolverArguments { ForceAbsolute = true };

        return urlResolver
            .GetUrl(file.ContentLink, null, urlResolverArgs);
    }

    public void Clean(SiteDefinition siteDefinition, SitemapState forState)
    {
        EnsureInitialized(siteDefinition);

        var alLFilesForSite = contentRepository
            .GetChildren<MediaData>(_sitemapRootForSite)
            .ToList();

        foreach (var mediaData in alLFilesForSite)
        {
            if (!int.TryParse(mediaData.RouteSegment, out var i) || !forState.FullPages.ContainsKey(i))
            {
                // Blob is unknown to sitemap state.
                contentRepository.Delete(mediaData.ContentLink, false, AccessLevel.NoAccess);
            }
        }
    }

    private void EnsureInitialized(SiteDefinition siteDefinition)
    {
        var loaderOptions = LanguageSelector.MasterLanguage();

        // Ensure sitemap root folder.
        var sitemapRoot = contentRepository.GetBySegment(siteDefinition.GlobalAssetsRoot, "sitemaps", loaderOptions) as ContentFolder;

        if (sitemapRoot == null)
        {
            sitemapRoot = contentRepository.GetDefault<ContentFolder>(siteDefinition.GlobalAssetsRoot);
            sitemapRoot.Name = "sitemaps";

            contentRepository.Save(sitemapRoot, SaveAction.Publish, AccessLevel.NoAccess);
        }

        // Ensure folder for this site's sitemap files.
        var sitemapFolderForSite = contentRepository.GetBySegment(sitemapRoot.ContentLink, siteDefinition.Name, loaderOptions) as ContentFolder;

        if (sitemapFolderForSite == null)
        {
            sitemapFolderForSite = contentRepository.GetDefault<ContentFolder>(sitemapRoot.ContentLink);
            sitemapFolderForSite.Name = siteDefinition.Name;

            _sitemapRootForSite = contentRepository.Save(sitemapFolderForSite, SaveAction.Publish, AccessLevel.NoAccess);
        }
        else
        {
            _sitemapRootForSite = sitemapFolderForSite.ContentLink;
        }

        _sitemapMediaContentType = contentTypeRepository.Load(typeof(SitemapFile));
    }
}