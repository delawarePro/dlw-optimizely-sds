using System.Text.Json;
using EPiServer.Data;
using EPiServer.Data.Dynamic;

namespace Delaware.Optimizely.Sitemap.Shared.Models;

[EPiServerDataStore(AutomaticallyCreateStore = false, AutomaticallyRemapStore = true)]
public class SitemapState : IDynamicData
{
    #region Deprecated

    [EPiServerIgnoreDataMember, Obsolete($"Deprecated in favor of {nameof(FullPagesPerLanguageGroup)}", false)]
    public IDictionary<int, string> FullPages { get; set; } = new Dictionary<int, string>();

    [EPiServerIgnoreDataMember, Obsolete($"Deprecated in favor of {nameof(DeltaPagesPerLanguageGroup)}", false)]
    public IDictionary<int, string> DeltaPages { get; set; } = new Dictionary<int, string>();

    /// <summary>
    /// JSON representation of the <see cref="FullPages"/> property, to avoid having the DDS store this over multiple rows.
    /// </summary>
    [Obsolete($"Deprecated in favor of {nameof(FullPagesPerLanguageGroupJson)}", false)]
    public string FullPagesJson
    {
        get => JsonSerializer.Serialize(FullPages);
        set => FullPages = (!string.IsNullOrEmpty(value)
            ? JsonSerializer.Deserialize<Dictionary<int, string>>(value)!
            : new Dictionary<int, string>());
    }

    /// <summary>
    /// JSON representation of the <see cref="DeltaPages"/> property, to avoid having the DDS store this over multiple rows.
    /// </summary>
    [Obsolete($"Deprecated in favor of {nameof(DeltaPagesPerLanguageGroupJson)}", false)]
    public string DeltaPagesJson
    {
        get => JsonSerializer.Serialize(DeltaPages);
        set => DeltaPages = (!string.IsNullOrEmpty(value)
            ? JsonSerializer.Deserialize<Dictionary<int, string>>(value)!
            : new Dictionary<int, string>());
    }

    #endregion Deprecated

    /// <summary>
    /// Maps language group keys to sitemap page indexes and their corresponding URLs.
    /// </summary>
    [EPiServerIgnoreDataMember]
    public IDictionary<string, IDictionary<int, string>> FullPagesPerLanguageGroup { get; set; } = new Dictionary<string, IDictionary<int, string>>();

    /// <summary>
    /// Maps language group keys to delta sitemap page indexes and their corresponding URLs.
    /// </summary>
    [EPiServerIgnoreDataMember]
    public IDictionary<string, IDictionary<int, string>> DeltaPagesPerLanguageGroup { get; set; } = new Dictionary<string, IDictionary<int, string>>();

    /// <summary>
    /// JSON representation of the <see cref="FullPagesPerLanguageGroup"/> property, to avoid having the DDS store this over multiple rows.
    /// </summary>
    public string FullPagesPerLanguageGroupJson
    {
        get => JsonSerializer.Serialize(FullPagesPerLanguageGroup);
        set => FullPagesPerLanguageGroup = !string.IsNullOrEmpty(value)
            ? JsonSerializer.Deserialize<Dictionary<string, IDictionary<int, string>>>(value)!
            : new Dictionary<string, IDictionary<int, string>>();
    }

    /// <summary>
    /// JSON representation of the <see cref="DeltaPagesPerLanguageGroup"/> property, to avoid having the DDS store this over multiple rows.
    /// </summary>
    public string DeltaPagesPerLanguageGroupJson
    {
        get => JsonSerializer.Serialize(DeltaPagesPerLanguageGroup);
        set => DeltaPagesPerLanguageGroup = !string.IsNullOrEmpty(value)
            ? JsonSerializer.Deserialize<Dictionary<string, IDictionary<int, string>>>(value)!
            : new Dictionary<string, IDictionary<int, string>>();
    }

    public Identity Id { get; set; } = null!;

    public string? SiteName { get; set; }

    public DateTime? LastDeltaGenerationUtc { get; set; }

    public DateTime? LastFullGenerationUtc { get; set; }
}