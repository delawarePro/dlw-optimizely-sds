using EPiServer;
using Microsoft.Extensions.Logging;

namespace Dlw.Optimizely.Sds.Publishing;

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