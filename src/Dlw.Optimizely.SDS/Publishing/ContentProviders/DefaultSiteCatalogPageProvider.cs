﻿using EPiServer;
using EPiServer.Core;

namespace Dlw.Optimizely.Sds.Publishing.ContentProviders;

public class DefaultSiteCatalogPageProvider : SiteCatalogContentProviderBase, ISiteCatalogPageProvider
{
    public DefaultSiteCatalogPageProvider(IContentLoader contentLoader) : base(contentLoader)
    {
    }

    public async Task<SiteCatalogItemsResult> GetPages(ContentReference root, string? next, IOperationContext context)
    {
        // Skip if specified.
        int? skip = null;
        if (!string.IsNullOrEmpty(next))
        {
            // Throw if 'next' value is provided but could not parse to integer, to avoid infinite loop.
            skip = int.Parse(next);
        }

        var take = context.BatchSizeHint ?? DefaultBatchSize;

        // Gets a batch of id's.
        var descendants = ContentLoader
            .GetDescendents(root)
            .Skip(skip.GetValueOrDefault())
            .Take(take)
            .ToList();

        // If the first page, add the root itself as well.
        if (string.IsNullOrEmpty(next))
        {
            descendants.Add(root);
        }

        var items = descendants.Any() ? ContentLoader
                .GetItems(descendants, LanguageSelector.MasterLanguage())
            : null;

        var pages = items != null
            ? await GetContent(items.ToArray())
            : null;

        // Skip previous count + current page count for next iteration.
        // If there are no more results, we're at the end.
        skip = descendants.Any() ? (skip ?? 0) + descendants.Count : null;

        return new SiteCatalogItemsResult(pages, skip?.ToString());
    }
}