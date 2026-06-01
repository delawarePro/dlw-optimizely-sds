using Delaware.Optimizely.Testing;

// Disable parallel for now test runs.
// Optimizely CMS cannot startup in parallel due to statics. For ex. 'EPiServer.Hosting.Internal.AssemblyScanner'.
//[assembly: Parallelize(Workers = 4, Scope = ExecutionScope.MethodLevel)]
[assembly: Parallelize(Workers = 1, Scope = ExecutionScope.MethodLevel)]

namespace Dlw.EpiBase.IntegrationTests;

[TestClass]
public abstract class TestClassBase
{
    private static readonly Func<MSTestInfraRoot> _createTestInfra = () => MSTestInfraRoot.Create<TestClassBase>();

    private readonly MSTestInfraRoot _testInfra = _createTestInfra();

    /// <summary>
    /// Test infrastructure to use by tests.
    /// </summary>
    public ITestInfraRoot TestInfra => _testInfra;

    /// <summary>
    /// Test context that will be injected by MS test framework, forward it to test infra ASAP.
    /// </summary>
    public TestContext TestContext
    {
        get => _testInfra.TestContext;
        set => _testInfra.TestContext = value;
    }

    /// <summary>
    /// Allows creating test infrastructure on-demand (exceptional cases).
    /// </summary>
    public static ITestInfraRoot CreateTestInfra() => _createTestInfra();

    [TestCleanup]
    public virtual Task TestCleanup()
    {
        return _testInfra.PerformTestCleanup();
    }

    [AssemblyCleanup]
    public static Task AssemblyCleanup()
    {
        return MSTestInfraRoot.Create<TestClassBase>().PerformTestRunCleanup();
    }
}