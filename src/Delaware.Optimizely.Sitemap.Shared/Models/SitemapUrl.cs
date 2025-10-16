using System.Text.Json.Serialization;

namespace Delaware.Optimizely.Sitemap.Shared.Models;

/// <summary>
/// Used in sitemap index files.
/// </summary>
public class SitemapUrl : AbstractUrl
{
    /// <summary>
    /// Uncompressed size in bytes of the referenced sitemap file.
    /// </summary>
    /// <remarks>This is additional data that is not supported in the sitemap standard.</remarks>
    public long? Size { get; set; }

    /// <summary>
    /// Number of files contains in the referenced sitemap file.
    /// </summary>
    /// <remarks>This is additional data that is not supported in the sitemap standard.</remarks>
    public int? NumberOfUrls { get; set; }

    [JsonConstructor]
    public SitemapUrl(string location)
        : base(location)
    {
        Location = location;
    }
}