using EPiServer;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;

namespace Delaware.Optimizely.Sitemap.Core.Publishing;

public class OperationContext : IOperationContext
{
    public int? BatchSizeHint { get; }

    public ILogger Logger { get; }

    public ContentEventArgs? EventArgs { get; }

    public OperationContext(int? batchSizeHint = null, ILogger? logger = null, ContentEventArgs? eventArgs = null)
    {
        Logger = logger ?? NullLogger.Instance;
        BatchSizeHint = batchSizeHint;
        EventArgs = eventArgs;
    }
}