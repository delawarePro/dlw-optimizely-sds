using System.Text.Json;
using EPiServer.Data;
using EPiServer.Data.Dynamic;

namespace Delaware.Optimizely.Sitemap.Shared.Models;

[EPiServerDataStore(AutomaticallyCreateStore = false, AutomaticallyRemapStore = true)]
public class SitemapState : IDynamicData
{
    [EPiServerIgnoreDataMember]
    public IDictionary<int, string> FullPages { get; set; } = new Dictionary<int, string>();   
    
    [EPiServerIgnoreDataMember]
    public IDictionary<int, string> DeltaPages { get; set; } = new Dictionary<int, string>();

    /// <summary>
    /// JSON representation of the <see cref="FullPages"/> property, to avoid having the DDS store this over multiple rows.
    /// </summary>
    public string FullPagesJson
    {
        get => JsonSerializer.Serialize(FullPages);
        set => FullPages = (!string.IsNullOrEmpty(value)
            ? JsonSerializer.Deserialize<Dictionary<int, string>>(value)!
            : new Dictionary<int, string>()) ;
    }
    /// <summary>
    /// JSON representation of the <see cref="DeltaPages"/> property, to avoid having the DDS store this over multiple rows.
    /// </summary>
    public string DeltaPagesJson
    {
        get => JsonSerializer.Serialize(DeltaPages);
        set => DeltaPages = (!string.IsNullOrEmpty(value)
            ? JsonSerializer.Deserialize<Dictionary<int, string>>(value)!
            : new Dictionary<int, string>()) ;
    }

    public Identity Id { get; set; } = null!;

    public string? SiteName { get; set; }

    public DateTime? LastDeltaGenerationUtc { get; set; }

    public DateTime? LastFullGenerationUtc { get; set; }
}