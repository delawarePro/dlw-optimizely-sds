namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.DynamicContent;

/// <summary>
/// Result object for a custom <see cref="IDynamicContentRootProcessor"/> implementation.
/// </summary>
/// <param name="DynamicContentSourceId">
///     <para>Unique ID of the expanded dynamic content, e.g.: an external product ID.</para>
///     <para>This allows for grouping objects of type <see cref="DynamicContentProcessingResult"/> together by their original dynamic content.</para>
/// </param>
/// <param name="Language">The language for which the current processing path was resolved.</param>
/// <param name="Path">The resolved path for the dynamic content routed to a given page.</param>
/// <param name="PathType">
///     <para>Relative (default) or absolute path resolved.</para>
///     <para>Tip: use <see cref="DynamicContentPathType.Relative"/> mainly when manually constructing the paths for the dynamic content.</para>
///     <para>Tip: use <see cref="DynamicContentPathType.Absolute"/> when using the <see cref="EPiServer.Web.Routing.IUrlResolver"/> which might
///     be returning absolute paths already anyway.</para>
/// </param>
public record DynamicContentProcessingResult(
    DynamicContentSourceId DynamicContentSourceId, 
    string Language, 
    string Path,
    DynamicContentPathType PathType);

public record DynamicContentSourceId(string SourceId);

public enum DynamicContentPathType
{
    Absolute,
    Relative
}