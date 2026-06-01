using System.Diagnostics;
using System.Net.Http.Headers;
using System.Text;
using Microsoft.Extensions.Logging;

namespace Delaware.Optimizely.Testing;

internal class HttpContentLoggerHandler : DelegatingHandler
{
    private readonly ILogger? _logger;

    public LogLevel HeaderLevel { get; set; } = LogLevel.Debug;
    public LogLevel ContentLevel { get; set; } = LogLevel.Trace;
    public bool IndentContent { get; set; } = true;

    public HttpContentLoggerHandler(ILogger? logger)
    {
        _logger = logger;
    }

    protected override async Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
    {
        if (_logger?.IsEnabled(HeaderLevel) == true)
        {
            var output = new StringBuilder()
                .Append("Sending HTTP request ").Append(request.Method).Append(" ").Append(request.RequestUri);

            WriteHeaders(output, request.Headers, request.Content?.Headers);

            if (_logger.IsEnabled(ContentLevel) && request.Content != null)
                WriteContent(output, await request.Content.ReadAsStringAsync(cancellationToken));

            _logger.Log(HeaderLevel, output.ToString());
        }

        var sw = Stopwatch.StartNew();
        var response = await base.SendAsync(request, cancellationToken);
        var responseLevel = HeaderLevel;

        if (_logger?.IsEnabled(responseLevel) == true)
        {
            var output = new StringBuilder()
                .Append("Received ")
                .Append((int)response.StatusCode).Append(" (").Append(response.StatusCode).Append(") from ")
                .Append(request.Method).Append(" ").Append(request.RequestUri)
                .Append(" after ").Append(sw.ElapsedMilliseconds).Append("ms");

            WriteHeaders(output, response.Headers, response.Content?.Headers);

            if (_logger.IsEnabled(ContentLevel) && response.Content != null)
                WriteContent(output, await response.Content.ReadAsStringAsync(cancellationToken));

            _logger.Log(responseLevel, output.ToString());
        }

        return response;
    }

    private static void WriteHeaders(StringBuilder output, params HttpHeaders?[] headers)
    {
        var firstHeader = true;

        foreach (var collection in headers)
        {
            if (collection == null) continue;

            foreach (var header in collection)
            {
                if (firstHeader)
                {
                    output.AppendLine().AppendLine("Headers: (");
                    firstHeader = false;
                }

                output.Append("  ").Append(header.Key);
                var firstValue = true;
                foreach (var value in header.Value)
                {
                    output.Append(firstValue ? ": " : ",");
                    firstValue = false;
                    output.Append(value);
                }
                output.AppendLine();
            }
        }

        if (!firstHeader)
            output.Append(')');
    }

    private void WriteContent(StringBuilder output, string content)
    {
        output.AppendLine().AppendLine("Content: (");

        if (IndentContent)
        {
            foreach (var line in content.Split(Environment.NewLine))
                output.Append("  ").AppendLine(line);
        }
        else
        {
            output.AppendLine(content);
        }

        output.Append(')');
    }
}
