namespace Delaware.Optimizely.Testing;

public static class TestInfraHelpers
{
    public static string ResolveSolutionRelativePath(
        this ITestInfraRoot testInfra,
        string? solutionRelativePath,
        string solutionName = "*.sln*")
    {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        do
        {
            if (Directory.EnumerateFiles(dir.FullName, solutionName).Any())
                return Path.GetFullPath(Path.Combine(dir.FullName, solutionRelativePath ?? string.Empty));
            dir = dir.Parent;
        }
        while (dir != null);

        throw new InvalidOperationException($"Solution root could not be located from {AppContext.BaseDirectory}.");
    }

    public static string ResolveProjectRelativePath(
        this ITestInfraRoot testInfra,
        string? projectRelativePath,
        string projectName = "*.csproj")
    {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        do
        {
            if (Directory.EnumerateFiles(dir.FullName, projectName).Any())
                return Path.GetFullPath(Path.Combine(dir.FullName, projectRelativePath ?? string.Empty));
            dir = dir.Parent;
        }
        while (dir != null);

        throw new InvalidOperationException($"Project root could not be located from {AppContext.BaseDirectory}.");
    }

    public static void AddTestCleanup(this ITestInfraRoot test, IAsyncDisposable disposable, bool skipWhenNotPassed = true)
        => test.AddTestCleanup(async _ => await disposable.DisposeAsync(), skipWhenNotPassed);

    public static void AddTestCleanup(this ITestInfraRoot test, IDisposable disposable, bool skipWhenNotPassed = true)
        => test.AddTestCleanup(_ => { disposable.Dispose(); return Task.CompletedTask; }, skipWhenNotPassed);
}
