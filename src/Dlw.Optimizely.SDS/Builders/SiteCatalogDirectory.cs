using System.Collections.Concurrent;
using Dlw.Optimizely.Sds.Publishing;
using EPiServer;
using EPiServer.Core;
using EPiServer.Web;
using Microsoft.Extensions.DependencyInjection;

namespace Dlw.Optimizely.Sds.Builders;

public class SiteCatalogDirectory
{
    private readonly IDictionary<string, ISiteCatalog> _siteCatalogs = new Dictionary<string, ISiteCatalog>(StringComparer.OrdinalIgnoreCase);

    private readonly ConcurrentDictionary<int, List<SiteDefinition>> _blockRootMap = new ConcurrentDictionary<int, List<SiteDefinition>>();

    private readonly IServiceProvider _serviceProvider;
    private readonly IContentLoader _contentLoader;

    public IReadOnlyCollection<string> SiteIds
        => _siteCatalogs.Keys.ToArray();

    public SiteCatalogDirectory(IServiceProvider serviceProvider)
    {
        _serviceProvider = serviceProvider;
        _contentLoader = serviceProvider.GetRequiredService<IContentLoader>();
    }

    /// <summary>
    ///  Add a site catalog to publish to Sds.
    /// </summary>
    /// <returns></returns>
    public SiteCatalogDirectory AddSiteCatalog(
        SiteDefinition siteDefinition,
        Action<ISiteCatalogBuilder>? configure = null)
    {
        var siteCatalog = new DefaultSiteCatalogBuilder(_serviceProvider, siteDefinition);
        configure?.Invoke(siteCatalog);

        var catalog = siteCatalog.Build();

        AddSiteCatalog(siteDefinition, catalog);
        
        return this;
    }

    /// <summary>
    ///  Add a site catalog to publish to Sds.
    /// </summary>
    /// <returns></returns>
    public SiteCatalogDirectory AddSiteCatalog(SiteDefinition siteDefinition, ISiteCatalog siteCatalog)
    {
        _siteCatalogs[siteDefinition.Name] = siteCatalog;
       
        foreach (var item in siteCatalog.GetBlockRoots())
        {
            if (_blockRootMap.TryGetValue(item, out var existingMap))
            {
                if (!existingMap.Contains(siteDefinition))
                {
                    _blockRootMap[item].Add(siteDefinition);
                }
            }
            else
            {
                _blockRootMap[item] = new List<SiteDefinition> { siteDefinition };
            }
        }

        return this;
    }

    public bool TryGetSiteCatalog(string siteName, out ISiteCatalog? value)
    {
        return _siteCatalogs.TryGetValue(siteName, out value);
    }

    public bool TryGetSiteUsages(IContent forBlock, out IList<SiteDefinition> bySites)
    {
        if (forBlock is not BlockData)
        {
            throw new ArgumentException(nameof(forBlock));
        }

        var result = new List<SiteDefinition>();
        var ancestorsAndSelf = _contentLoader
            .GetAncestors(forBlock.ContentLink)
            .Select(c=> c.ContentLink.ID)
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

        bySites = result.DistinctBy(d => d.Id).ToList();

        return result.Count > 0;
    }
}