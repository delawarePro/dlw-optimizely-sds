using Alloy;
using Delaware.Optimizely.Testing;
using EPiServer.Framework.Initialization;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Dlw.EpiBase.IntegrationTests;

public static class OptimizelyTestExtensions
{
    internal static async Task<TestWebApp<Program>> CreateOptimizelyCmsTestWebApp(this ITestInfraRoot testInfra,
        bool shared = false,
        bool disposeHost = true,
        Action<IServiceCollection>? configureServices = null    )
    {
        // For all this below, mind the casing. Linux paths are case-sensitive!
        var webApp = await testInfra.CreateTestWebApp<Program>(builder =>
        {
            // When running inttests, read environment variables with a specific prefix.
            // These variables are injected by the build pipeline, so that we can use mssql hosted test container.
            builder.ConfigureAppConfiguration((_, config) => { config.AddEnvironmentVariables("inttest_"); });

            builder.ConfigureServices(services =>
            {
                configureServices?.Invoke(services);
            });
        },
            contentRootPath: testInfra.ResolveSolutionRelativePath("test/Alloy"),
            environment: "Development",
            shared: shared,
            sharingKey: "optimizelycms"
        );

        testInfra.AddTestRunCleanup(async infra =>
        {
            webApp
                .Services
                .GetService<InitializationEngine>()
                ?.Uninitialize();
        });

        // Dispose at end of test run when not shared.
        // In case of shared instance, the container will be disposed when the test infra is disposed.
        if (disposeHost && !shared)
            testInfra.AddTestCleanup(webApp);

        return webApp;
    }
}