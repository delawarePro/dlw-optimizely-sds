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
    private ContentType? _sitemapMediaContentType;

    public string Store(
        SiteDefinition siteDefinition,
        KeyValuePair<string, IReadOnlyCollection<string>> languageGroup,
        Stream inputStream, 
        int pageNumber,
        bool isDelta)
    {
        EnsureInitialized(siteDefinition, languageGroup, out var target);

        var urlSegment = $"{(isDelta ? "D" : string.Empty)}{pageNumber}";
        var existing = contentRepository.GetBySegment(target, urlSegment, LanguageSelector.MasterLanguage());

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

        var file = contentRepository.GetDefault<MediaData>(target, _sitemapMediaContentType!.ID);
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

    private void EnsureInitialized(
        SiteDefinition siteDefinition,
        KeyValuePair<string, IReadOnlyCollection<string>> languageGroup,
        out ContentReference mostSpecificFolder)
    {
        var loaderOptions = LanguageSelector.MasterLanguage();
        ContentReference? languageGroupFolderContentReference = null;

        // Ensure sitemap root folder.
        var sitemapRoot = contentRepository.GetBySegment(siteDefinition.GlobalAssetsRoot, "sitemaps", loaderOptions) as ContentFolder;
        ContentReference? sitemapRootForSite = null;
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

            sitemapRootForSite = contentRepository.Save(sitemapFolderForSite, SaveAction.Publish, AccessLevel.NoAccess);
        }
        else
        {
            sitemapRootForSite = sitemapFolderForSite.ContentLink;
        }

        if (!string.IsNullOrWhiteSpace(languageGroup.Key))
        {
            var languageGroupName = languageGroup.Key;

            // Ensure folder for this site's sitemap files.
            var sitemapFolderForLanguageGroup = contentRepository.GetBySegment(sitemapRootForSite, languageGroupName, loaderOptions) as ContentFolder;

            if (sitemapFolderForLanguageGroup == null)
            {
                sitemapFolderForLanguageGroup = contentRepository.GetDefault<ContentFolder>(sitemapFolderForSite.ContentLink);
                sitemapFolderForLanguageGroup.Name = languageGroupName;

                languageGroupFolderContentReference = contentRepository.Save(sitemapFolderForLanguageGroup, SaveAction.Publish, AccessLevel.NoAccess);
            }
            else
            {
                languageGroupFolderContentReference = sitemapFolderForLanguageGroup.ContentLink;
            }
        }

        // Set the most specific folder for the given site/language group to store sitemap files in.
        mostSpecificFolder = languageGroupFolderContentReference ?? sitemapRootForSite ?? sitemapRoot.ContentLink;

        _sitemapMediaContentType = contentTypeRepository.Load(typeof(SitemapFile));
    }
}