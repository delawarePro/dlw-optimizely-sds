using Dlw.Optimizely.SDS.Client;

namespace Dlw.Optimizely.Sds.Publishing;

public class SiteCatalogEntriesResult(
    IReadOnlyCollection<SiteCatalogEntry>? entries,
    IReadOnlyCollection<SiteCatalogEntry>? filteredOut,
    string? next)
{
    public IReadOnlyCollection<SiteCatalogEntry>? Entries { get; } = entries;

    public IReadOnlyCollection<SiteCatalogEntry>? FilteredOut { get; set; } = filteredOut;

    public string? Next { get; } = next;

    public bool HasNext => !string.IsNullOrEmpty(Next);
}