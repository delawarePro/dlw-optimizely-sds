using System.Reflection;
using System.Threading.Tasks.Dataflow;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Testing;

public class MSTestInfraRoot : TestInfraRoot
{
    private TestContext? _testContext;

    public TestContext TestContext
    {
        get => _testContext ?? throw new InvalidOperationException("Test context has not been set.");
        set => _testContext = value;
    }

    public override CancellationToken Cancellation => TestContext.CancellationTokenSource.Token;

    protected override bool? IsTestPassed => TestContext.CurrentTestOutcome == UnitTestOutcome.Passed;

    private MSTestInfraRoot(Assembly testAssembly) : base(testAssembly)
    {
        SetupLogging = builder => builder
            .SetMinimumLevel(LogLevel.Trace)
            .AddConfiguration(Configuration.GetSection(LoggingConfigurationSection))
            .AddProvider(new LogProvider(TestContext));
    }

    public static MSTestInfraRoot Create<TTestClass>(Action<MSTestInfraRoot>? configure = null)
    {
        var testInfra = new MSTestInfraRoot(typeof(TTestClass).Assembly);
        configure?.Invoke(testInfra);
        return testInfra;
    }

    private sealed class LogProvider : ILoggerProvider
    {
        private readonly TestContext _context;
        private readonly BufferBlock<string> _logs;

        public LogProvider(TestContext context)
        {
            _context = context;
            _logs = new BufferBlock<string>();

            // Workaround for AsyncLocal issue in MSTest, see https://github.com/microsoft/testfx/issues/1083
            Task.Run(async () =>
            {
                try
                {
                    while (await _logs.OutputAvailableAsync())
                        _context.WriteLine(await _logs.ReceiveAsync());
                }
                catch (OperationCanceledException) { }
            });
        }

        public ILogger CreateLogger(string categoryName) => new Logger(categoryName, _logs);

        public void Dispose() { }

        private sealed class Logger(string categoryName, BufferBlock<string> logs) : ILogger
        {
            public bool IsEnabled(LogLevel logLevel) => logLevel != LogLevel.None;

            public IDisposable? BeginScope<TState>(TState state) where TState : notnull => null;

            public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception? exception, Func<TState, Exception?, string> formatter)
            {
                logs.Post($"{Level(logLevel)}: {categoryName} [{eventId}]{Environment.NewLine}      {formatter(state, exception)}");
                if (exception != null)
                    logs.Post($"{Level(logLevel)}: {categoryName} [{eventId}]{Environment.NewLine}      {exception}");
            }

            private static string Level(LogLevel l) => l switch
            {
                LogLevel.Trace => "trce",
                LogLevel.Debug => "dbug",
                LogLevel.Information => "info",
                LogLevel.Warning => "warn",
                LogLevel.Error => "fail",
                LogLevel.Critical => "crit",
                _ => throw new ArgumentOutOfRangeException(nameof(l))
            };
        }
    }
}
