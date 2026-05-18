namespace Alloy.Extensions;

public static class HostEnvironmentEnvExtensions
{
    /// <summary>
    /// Checks whether the current host environment is 'development' or an automated test.
    /// </summary>
    public static bool IsDevOrAutomatedTest(this IHostEnvironment hostEnvironment)
    {
        return hostEnvironment.IsDevelopment() || hostEnvironment.IsAnAutomatedTest();
    }
        
    /// <summary>
    /// Checks whether the current host environment is an automated test. (IntTests, WebTests, ...)
    /// If environment name ends with 'test' or 'tests'.
    /// </summary>
    public static bool IsAnAutomatedTest(this IHostEnvironment hostEnvironment)
    {
        return hostEnvironment.EnvironmentName.EndsWith("test", StringComparison.OrdinalIgnoreCase)
               || hostEnvironment.EnvironmentName.EndsWith("tests", StringComparison.OrdinalIgnoreCase);
    }
}