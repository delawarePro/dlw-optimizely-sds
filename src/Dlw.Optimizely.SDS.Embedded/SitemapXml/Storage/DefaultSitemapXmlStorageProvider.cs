using Dlw.Optimizely.SDS.Embedded.SitemapXml.Models;
using Dlw.Optimizely.SDS.Shared.Models;
using EPiServer;
using EPiServer.Core;
using EPiServer.DataAbstraction;
using EPiServer.DataAccess;
using EPiServer.Framework.Blobs;
using EPiServer.Security;
using EPiServer.Web;
using EPiServer.Web.Routing;
using Microsoft.Extensions.Logging;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Storage;

/// <summary>
/// Stores generated sitemap XML files as .sdssitemapxml media blocks.
/// Note: there is no default media type for .xml files. Introducing a .xml media type for storing sitemaps,
/// would link .xml media types to sitemap items for all XML files - hence: .sdssitemapxml
/// </summary>
public class DefaultSitemapXmlStorageProvider : ISitemapXmlStorageProvider
{
    private readonly IContentTypeRepository _contentTypeRepository;
    private readonly IContentRepository _contentRepository;
    private readonly IBlobFactory _blobFactory;
    private readonly IUrlResolver _urlResolver;
    private readonly ILogger _logger;

    private ContentReference? _sitemapRootForSite;
    private ContentType? _sitemapMediaContentType;

    public DefaultSitemapXmlStorageProvider(
        IContentRepository contentRepository,
        IBlobFactory blobFactory, 
        IUrlResolver urlResolver, 
        IContentTypeRepository contentTypeRepository,
        ILoggerFactory loggerFactory)
    {
        _contentRepository = contentRepository;
        _blobFactory = blobFactory;
        _urlResolver = urlResolver;
        _contentTypeRepository = contentTypeRepository;
        _logger = loggerFactory.CreateLogger<DefaultSitemapXmlStorageProvider>();
    }

    public string Store(SiteDefinition siteDefinition, Stream inputStream, int pageNumber, bool isDelta)
    {
        EnsureInitialized(siteDefinition);

        var urlSegment = $"{(isDelta ? "D" : string.Empty)}{pageNumber}";
        var existing = _contentRepository.GetBySegment(_sitemapRootForSite, urlSegment,
            LanguageSelector.MasterLanguage());

        if (existing != null)
        {
            try
            {
                _contentRepository.Delete(existing.ContentLink, true, AccessLevel.NoAccess);
            }
            catch
            {
                _logger.LogWarning($"Could not delete sitemap XML page file.");
            }
        }

        var file = _contentRepository.GetDefault<MediaData>(_sitemapRootForSite, _sitemapMediaContentType!.ID);
        file.Name = urlSegment;

        var blob = _blobFactory.CreateBlob(file.BinaryDataContainer, Constants.SdsSitemapFileExtension);
        inputStream.Seek(0, SeekOrigin.Begin);
        blob.Write(inputStream);
        inputStream.Seek(0, SeekOrigin.Begin);

        file.BinaryData = blob;

        _contentRepository.Save(file, SaveAction.Publish, AccessLevel.NoAccess);

        var urlResolverArgs = new UrlResolverArguments { ForceAbsolute = true };

        return _urlResolver
            .GetUrl(file.ContentLink, null, urlResolverArgs);
    }

    public void Clean(SiteDefinition siteDefinition, SitemapState forState)
    {
        EnsureInitialized(siteDefinition);

        var alLFilesForSite = _contentRepository
            .GetChildren<MediaData>(_sitemapRootForSite)
            .ToList();

        foreach (var mediaData in alLFilesForSite)
        {
            if (!int.TryParse(mediaData.RouteSegment, out var i) || !forState.FullPages.ContainsKey(i))
            {
                // Blob is unknown to sitemap state.
                _contentRepository.Delete(mediaData.ContentLink, false, AccessLevel.NoAccess);
            }
        }
    }

    private void EnsureInitialized(SiteDefinition siteDefinition)
    {
        var loaderOptions = LanguageSelector.MasterLanguage();

        // Ensure sitemap root folder.
        var sitemapRoot = _contentRepository.GetBySegment(siteDefinition.GlobalAssetsRoot, "sitemaps", loaderOptions) as ContentFolder;

        if (sitemapRoot == null)
        {
            sitemapRoot = _contentRepository.GetDefault<ContentFolder>(siteDefinition.GlobalAssetsRoot);
            sitemapRoot.Name = "sitemaps";

            _contentRepository.Save(sitemapRoot, SaveAction.Publish, AccessLevel.NoAccess);
        }

        // Ensure folder for this site's sitemap files.
        var sitemapFolderForSite = _contentRepository.GetBySegment(sitemapRoot.ContentLink, siteDefinition.Name, loaderOptions) as ContentFolder;

        if (sitemapFolderForSite == null)
        {
            sitemapFolderForSite = _contentRepository.GetDefault<ContentFolder>(sitemapRoot.ContentLink);
            sitemapFolderForSite.Name = siteDefinition.Name;

            _sitemapRootForSite = _contentRepository.Save(sitemapFolderForSite, SaveAction.Publish, AccessLevel.NoAccess);
        }
        else
        {
            _sitemapRootForSite = sitemapFolderForSite.ContentLink;
        }

        _sitemapMediaContentType = _contentTypeRepository.Load(typeof(SitemapFile));
    }
}