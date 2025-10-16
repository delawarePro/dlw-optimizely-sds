using System.Text.Json.Serialization;
using Delaware.Optimizely.Sitemap.Shared.Models;

namespace Delaware.Optimizely.Sitemap.SitemapXml.Models
{
    public class SitemapIndex
    {
        public IList<SitemapUrl> Sitemaps { get; set; }

        /// <summary>
        /// Optional sitemap for which this sitemap index is generated.
        /// </summary>
        /// <remarks>This is additional data that is not supported in the sitemap standard.</remarks>
        public string? SitemapId { get; set; }

        /// <summary>
        /// Optional source for which this sitemap index is generated.
        /// </summary>
        /// <remarks>This is additional data that is not supported in the sitemap standard.</remarks>
        public string? SourceId { get; set; }

        /// <summary>
        /// Optional shard for which this sitemap index is generated.
        /// </summary>
        /// <remarks>This is additional data that is not supported in the sitemap standard.</remarks>
        public string? ShardId { get; set; }

        /// <summary>
        /// Whether this sitemap index contains all data, or if it only contains updates.
        /// </summary>
        /// <remarks>This is additional data that is not supported in the sitemap standard.</remarks>
        public bool? IsDelta { get; set; }

        public DateTime? Modified { get; set; }

        public bool? IsIndexOfIndexes { get; set; }

        [JsonConstructor]
        public SitemapIndex(IList<SitemapUrl> sitemaps)
        {
            Sitemaps = sitemaps;
        }

        public SitemapIndex()
        {
            Sitemaps = new List<SitemapUrl>();
            Modified = DateTime.UtcNow;
        }

        /// <summary>
        /// Prepends base path to all locations that are relative urls.
        /// </summary>
        /// <param name="basePath">Base path to prepend.</param>
        public void SetBasePath(string basePath)
        {
            if (basePath.EndsWith('/'))
                basePath = basePath[0..^1];

            foreach (var url in Sitemaps)
            {
                if (!url.Location.StartsWith("http://", StringComparison.OrdinalIgnoreCase)
                    && !url.Location.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
                {
                    url.Location = url.Location.StartsWith('/')
                        ? $"{basePath}{url.Location}"
                        : $"{basePath}/{url.Location}";
                }
            }
        }

        /// <summary>
        /// Creates an sitemap index file of index files.
        /// </summary>
        /// <param name="indexes">Indexes to reference.</param>
        /// <param name="locator">Function to generate location for index files.</param>
        public static SitemapIndex Index(IReadOnlyCollection<SitemapIndex> indexes,
            Func<SitemapIndex, string> locator)
        {
            return new SitemapIndex
            {
                Sitemaps = indexes
                    .Select(x => new SitemapUrl(locator(x))
                    {
                        Modified = x.Modified
                    })
                    .ToList(),
                Modified = indexes.Max(x => x.Modified),
                IsIndexOfIndexes = true
            };
        }

        /// <summary>
        /// Creates an sitemap index file by combining other index files.
        /// </summary>
        /// <param name="indexes">Indexes to combine.</param>
        /// <remarks>
        /// Although the sitemap.xml spec allows index of indexes, Google doesn't.
        /// See https://developers.google.com/search/blog/2006/10/multiple-sitemaps-in-same-directory#:~:text=Since%20Sitemap%20index%20files%20can%27t%20contain%20other%20index%20files%2C%20you%20would%20need%20to%20submit%20each%20Sitemap%20index%20file%20to%20your%20account%20separately
        /// and https://support.google.com/webmasters/answer/7451001#zippy=%2Ccomplete-error-list
        /// So we expand/combine all the indexes in to a single index.
        /// </remarks>
        public static SitemapIndex Combine(IReadOnlyCollection<SitemapIndex> indexes)
        {
            return new SitemapIndex
            {
                Sitemaps = indexes
                    .SelectMany(index => index.Sitemaps)
                    .ToList(),
                Modified = indexes.Max(x => x.Modified)
            };
        }
    }
}
