using System.Text.Json;
using EPiServer.Data;
using EPiServer.Data.Dynamic;

namespace Dlw.Optimizely.SDS.Client;

public record SiteCatalogEntryKey(string Shard, string Id);

public class LocalizedSiteCatalogEntry
{
    /// <summary>
    /// Url to the entry in the site for the specific locale.
    /// This is typically only a relative (slug) url.
    /// </summary>
    public string? Url { get; set; }

    /// <summary>
    /// Optional archival date for this localization only.
    /// This allows to remove a locale from the catalog logically.
    /// </summary>
    public DateTime? Archived { get; set; }
}

[EPiServerDataStore(AutomaticallyCreateStore = false, AutomaticallyRemapStore = true)]
public class SiteCatalogEntry : IDynamicData
{
    /// <summary>
    /// Uniquely identifies the entry within the catalog.
    /// </summary>
    public string? SourceId { get; set; }

    /// <summary>
    /// Last modification date of the content that this entry represents.
    /// This is not the technical modification date of the entry itself.
    /// </summary>
    public DateTime? Modified { get; set; }

    /// <summary>
    /// Optional archival date, this allows to remove an entry from the catalog logically.
    /// </summary>
    public DateTime? Archived { get; set; }

    /// <summary>
    /// Localized / per-locale data.
    /// </summary>
    [EPiServerIgnoreDataMember]
    public IDictionary<string, LocalizedSiteCatalogEntry>? Localized { get; set; }

    /// <summary>
    /// JSON representation of the <see cref="Localized"/> property, to avoid having the DDS store this over multiple rows.
    /// </summary>
    public string LocalizedJson
    {
        get => Localized != null ? JsonSerializer.Serialize(Localized) : string.Empty;
        set => Localized = !string.IsNullOrEmpty(value)
            ? JsonSerializer.Deserialize<Dictionary<string, LocalizedSiteCatalogEntry>>(value)
            : new Dictionary<string, LocalizedSiteCatalogEntry>();
    }

    public SiteCatalogEntry(SiteCatalogEntryKey key, string siteName)
    {
        Key = key;
        SiteName = siteName;
        SourceId = key.Id;
    }

    public SiteCatalogEntry()
    {
        // Required CTOR for Embedded store, which uses DDS.        
    }

    public override string ToString()
    {
        return $"{SiteName}-{SourceId}";
    }

    public SiteCatalogEntry Merge(SiteCatalogEntry source)
    {
        Localized = source.Localized;

        // Make sure it gets picked up, one if its parents may have changed these URLs.
        Modified = DateTime.UtcNow;

        return this;
    }

    [EPiServerIgnoreDataMember] // Not required for storing.
    public SiteCatalogEntryKey? Key { get; }

    [EPiServerDataIndex]
    public string? SiteName { get; set; }

    public Identity Id { get; set; } = null!;

    public int? ContentTypeId { get; set; }

    public string? Path { get; set; }
}