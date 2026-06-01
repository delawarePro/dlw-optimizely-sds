using System.Net;
using System.Net.Sockets;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.Mvc.Testing.Handlers;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Testing;

public class TestWebApp<TEntryPoint> : IAsyncDisposable
    where TEntryPoint : class
{
    private readonly WebApplicationFactory<TEntryPoint> _factory;

    public IServiceProvider Services => _factory.Services;
    public string BaseAddress => _factory.ClientOptions.BaseAddress.ToString();

    public TestWebApp(string environment, IConfiguration configuration, Action<IWebHostBuilder>? configureBuilder = null, string[]? urls = null)
    {
        _factory = urls?.Length > 0
            ? new KestrelHostFactory(urls, ConfigureWebHostBuilder)
            : new WebApplicationFactory<TEntryPoint>().WithWebHostBuilder(ConfigureWebHostBuilder);

        _factory.StartServer();
        using var _ = _factory.CreateClient();

        void ConfigureWebHostBuilder(IWebHostBuilder builder)
        {
            builder.UseEnvironment(environment);
            builder.UseConfiguration(configuration);
            configureBuilder?.Invoke(builder);
        }
    }

    public HttpClient CreateTestClient(
        ILogger? logger = null,
        bool followRedirects = true,
        bool configureReferrer = true,
        bool supportCookies = true,
        IReadOnlyCollection<DelegatingHandler>? additionalHandlers = null)
    {
        var handlers = new List<DelegatingHandler>();
        if (followRedirects) handlers.Add(new RedirectHandler());
        if (configureReferrer) handlers.Add(new ReferrerHandler());
        if (supportCookies) handlers.Add(new CookieContainerHandler());
        if (logger != null) handlers.Add(new HttpContentLoggerHandler(logger));
        if (additionalHandlers != null) handlers.AddRange(additionalHandlers);
        return _factory.CreateDefaultClient([.. handlers]);
    }

    public async ValueTask DisposeAsync()
    {
        await _factory.DisposeAsync();
        GC.SuppressFinalize(this);
    }

    // Runs the web app on a real Kestrel endpoint instead of TestServer.
    // See https://github.com/dotnet/aspnetcore/issues/4892
    private sealed class KestrelHostFactory : WebApplicationFactory<TEntryPoint>
    {
        private readonly string[] _urls;
        private readonly Action<IWebHostBuilder>? _configure;

        public KestrelHostFactory(string[] urls, Action<IWebHostBuilder>? configure)
        {
            if (urls.Length == 0) throw new ArgumentException("At least one URL must be provided.", nameof(urls));
            _urls = urls;
            _configure = configure;
            UseKestrel();
        }

        protected override void ConfigureWebHost(IWebHostBuilder builder)
        {
            base.ConfigureWebHost(builder);
            builder.UseUrls(_urls);
            _configure?.Invoke(builder);
        }
    }

    private sealed class ReferrerHandler : DelegatingHandler
    {
        private Uri? _referrer;

        protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            request.Headers.Referrer ??= _referrer;
            var response = await base.SendAsync(request, cancellationToken);
            _referrer = request.RequestUri;
            return response;
        }
    }
}

public static class TestWebAppExtensions
{
    public static async Task<TestWebApp<TEntryPoint>> CreateTestWebApp<TEntryPoint>(
        this ITestInfraRoot testInfra,
        Action<IWebHostBuilder>? configure = null,
        string environment = "Development",
        string? contentRootPath = null,
        bool withRealIP = false,
        bool shared = false,
        string? sharingKey = null,
        bool dispose = true)
        where TEntryPoint : class
    {
        contentRootPath ??= testInfra.ResolveProjectRelativePath(null);

        TestWebApp<TEntryPoint> DoCreate() => new(
            environment,
            testInfra.Configuration,
            configureBuilder: host =>
            {
                host.UseContentRoot(contentRootPath);
                host.ConfigureLogging(logging =>
                {
                    logging.ClearProviders();
                    testInfra.ApplyLoggingSetup(logging);
                });
                configure?.Invoke(host);
            },
            urls: withRealIP ? [GetAvailableLocalhost()] : null
        );

        if (!shared)
        {
            var app = DoCreate();
            if (dispose) testInfra.AddTestCleanup(app);
            return app;
        }

        return (await testInfra.Share(DoCreate, key: sharingKey, dispose: dispose)).Value;
    }

    private static string GetAvailableLocalhost(string scheme = "http")
    {
        using var socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        socket.Bind(new IPEndPoint(IPAddress.Loopback, 0));
        return $"{scheme}://localhost:{((IPEndPoint)socket.LocalEndPoint!).Port}";
    }
}
