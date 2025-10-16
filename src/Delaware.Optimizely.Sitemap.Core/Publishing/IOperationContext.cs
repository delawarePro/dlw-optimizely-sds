using EPiServer;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Sitemap.Core.Publishing;

public interface IOperationContext
{
    /// <summary>
    /// Optional batch size hint to process site entries.
    /// </summary>
    int? BatchSizeHint { get; }

    ILogger Logger { get; }

    /// <summary>
    /// Content event that triggered the publish.
    /// </summary>
    ContentEventArgs? EventArgs { get; }
}