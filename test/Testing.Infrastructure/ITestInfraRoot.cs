using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Testing;

public interface ITestInfraRoot
{
    IConfigurationRoot Configuration { get; }
    ILoggerFactory TestLoggerFactory { get; }
    ILogger Logger { get; }
    CancellationToken Cancellation { get; }
    IConfigurationBuilder ApplyConfigurationSetup(IConfigurationBuilder builder);
    ILoggingBuilder ApplyLoggingSetup(ILoggingBuilder builder);
    void AddTestCleanup(Func<ITestInfraRoot, Task> cleanup, bool skipWhenNotPassed = false);
    void AddTestRunCleanup(Func<ITestInfraRoot, Task> cleanup);
}
