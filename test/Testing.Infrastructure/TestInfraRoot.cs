using System.Reflection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Testing;

public abstract class TestInfraRoot : ITestInfraRoot
{
    private static IConfigurationRoot? _sharedConfiguration;
    private static readonly IList<Func<ITestInfraRoot, Task>> _testRunCleanup = [];
    private readonly IList<(Func<ITestInfraRoot, Task> cleanup, bool skipWhenNotPassed)> _testCleanup = [];

    private IConfigurationRoot? _configuration;
    private ILoggerFactory? _loggerFactory;
    private ILogger? _logger;

    public string TestSettingsFileName { get; set; } = "appsettings.inttest.json";
    public bool TestSettingsFileRequired { get; set; } = true;
    public string LoggingConfigurationSection { get; set; } = "Logging";
    public string LoggerCategoryName { get; set; } = "Test";
    public Assembly TestAssembly { get; set; }
    public bool SharedConfiguration { get; set; } = true;
    public Func<IConfigurationBuilder, IConfigurationBuilder> SetupConfiguration { get; set; }
    public Func<ILoggingBuilder, ILoggingBuilder> SetupLogging { get; set; }

    protected abstract bool? IsTestPassed { get; }

    protected TestInfraRoot(Assembly testAssembly)
    {
        TestAssembly = testAssembly;

        SetupConfiguration = builder => builder
            .AddJsonFile(TestSettingsFileName, optional: !TestSettingsFileRequired)
            .AddUserSecrets(TestAssembly, optional: true)
            .AddEnvironmentVariables();

        SetupLogging = builder => builder
            .SetMinimumLevel(LogLevel.Trace)
            .AddConfiguration(Configuration.GetSection(LoggingConfigurationSection))
            .AddConsole();
    }

    public virtual async Task PerformTestCleanup()
    {
        foreach (var (cleanup, skipWhenNotPassed) in _testCleanup.Reverse())
        {
            if (skipWhenNotPassed && IsTestPassed != true)
                continue;

            await cleanup(this);
        }

        TestLoggerFactory?.Dispose();
    }

    public virtual async Task PerformTestRunCleanup()
    {
        foreach (var cleanup in _testRunCleanup.Reverse())
        {
            await cleanup(this);
        }
    }

    public IConfigurationRoot Configuration => SharedConfiguration
        ? _sharedConfiguration ??= SetupConfiguration(new ConfigurationBuilder()).Build()
        : _configuration ??= SetupConfiguration(new ConfigurationBuilder()).Build();

    public ILoggerFactory TestLoggerFactory => _loggerFactory ??= LoggerFactory.Create(builder => SetupLogging(builder));

    public ILogger Logger => _logger ??= TestLoggerFactory.CreateLogger(LoggerCategoryName);

    public abstract CancellationToken Cancellation { get; }

    public IConfigurationBuilder ApplyConfigurationSetup(IConfigurationBuilder builder) => SetupConfiguration(builder);

    public ILoggingBuilder ApplyLoggingSetup(ILoggingBuilder builder) => SetupLogging(builder);

    public void AddTestCleanup(Func<ITestInfraRoot, Task> cleanup, bool skipWhenNotPassed = false) => _testCleanup.Add((cleanup, skipWhenNotPassed));

    public void AddTestRunCleanup(Func<ITestInfraRoot, Task> cleanup) => _testRunCleanup.Add(cleanup);
}
