using System.Collections.Concurrent;
using Delaware.Optimizely.Sitemap.Core.Publishing;
using EPiServer;
using EPiServer.Applications;
using EPiServer.Core;
using Microsoft.Extensions.DependencyInjection;

namespace Delaware.Optimizely.Sitemap.Core.Builders;

public class SiteCatalogDirectory(IServiceProvider serviceProvider)
{
    private readonly IDictionary<string, ISiteCatalog> _siteCatalogs = new Dictionary<string, ISiteCatalog>(StringComparer.OrdinalIgnoreCase);

    private readonly ConcurrentDictionary<int, List<InProcessWebsite>> _blockRootMap = new();

    private readonly IContentLoader _contentLoader = serviceProvider.GetRequiredService<IContentLoader>();

    public IReadOnlyCollection<string> SiteIds
        => _siteCatalogs.Keys.ToArray();

    /// <summary>
    ///  Add a site catalog to publish to sitemap processing.
    /// </summary>
    /// <returns></returns>
    public SiteCatalogDirectory AddSiteCatalog(InProcessWebsite application,
        Action<ISiteCatalogBuilder>? configure = null, string[]? languages = null)
    {
        if (application == null)
        {
            throw new ArgumentNullException(nameof(application), "Application cannot be null.");
        }

        var siteCatalog = new DefaultSiteCatalogBuilder(serviceProvider, application, languages);
        configure?.Invoke(siteCatalog);

        var catalog = siteCatalog.Build();

        AddSiteCatalog(application, catalog);

        return this;
    }

    /// <summary>
    ///  Add a site catalog to publish to sitemap processing.
    /// </summary>
    /// <returns></returns>
    public SiteCatalogDirectory AddSiteCatalog(InProcessWebsite application, ISiteCatalog siteCatalog)
    {
        if (application == null)
        {
            throw new ArgumentNullException(nameof(application), "Application cannot be null.");
        }

        _siteCatalogs[application.Name] = siteCatalog;

        foreach (var item in siteCatalog.GetBlockRoots())
        {
            if (_blockRootMap.TryGetValue(item, out var existingMap))
            {
                if (!existingMap.Contains(application))
                {
                    _blockRootMap[item].Add(application);
                }
            }
            else
            {
                _blockRootMap[item] = new List<InProcessWebsite> { application };
            }
        }

        return this;
    }

    public bool TryGetSiteCatalog(string siteName, out ISiteCatalog? value)
    {
        return _siteCatalogs.TryGetValue(siteName, out value);
    }

    public bool TryGetSiteUsages(IContent forBlock, out IList<InProcessWebsite> bySites)
    {
        if (forBlock is not BlockData)
        {
            throw new ArgumentException(nameof(forBlock));
        }

        var result = new List<InProcessWebsite>();
        var ancestorsAndSelf = _contentLoader
            .GetAncestors(forBlock.ContentLink)
            .Select(c => c.ContentLink.ID)
            .ToList();

        // Add content item itself.
        ancestorsAndSelf.Add(forBlock.ContentLink.ID);

        foreach (var ancestor in ancestorsAndSelf)
        {
            if (_blockRootMap.TryGetValue(ancestor, out var match))
            {
                result.AddRange(match);
            }
        }

        bySites = result.DistinctBy(d => d.Name).ToList();

        return result.Count > 0;
    }
}