using System.Collections.Concurrent;
using System.Diagnostics.CodeAnalysis;

namespace Delaware.Optimizely.Testing;

internal record Shared<T>(T Value, bool Reused);

public static class TestInfraExtensions
{
    private record ExtensionWrapper(object Instance, bool IsDisposed = false)
    {
        public bool IsDisposed { get; set; } = IsDisposed;
    }

    private static readonly ConcurrentDictionary<string, ExtensionWrapper> _extensions = new(StringComparer.OrdinalIgnoreCase);
    private static readonly ConcurrentDictionary<string, SemaphoreSlim> _initLocks = new(StringComparer.OrdinalIgnoreCase);

    internal static Task<Shared<T>> Share<T>(this ITestInfraRoot testInfra, Func<T> factory, string? key = null, bool dispose = true)
        => testInfra.Share(() => Task.FromResult(factory()), key, dispose);

    internal static async Task<Shared<T>> Share<T>(this ITestInfraRoot testInfra, Func<Task<T>> factory, string? key = null, bool dispose = true)
    {
        var typeKey = typeof(T).FullName ?? throw new InvalidOperationException("Type name is null.");
        key = key == null ? typeKey : $"{typeKey}:{key.ToLowerInvariant()}";

        if (TryReadCached(key, out var value))
            return new((T)value.Instance, true);

        var initLock = _initLocks.GetOrAdd(key, _ => new SemaphoreSlim(1, 1));
        await initLock.WaitAsync();
        try
        {
            if (TryReadCached(key, out value))
                return new((T)value.Instance, true);

            var instance = await factory();
            var wrapper = new ExtensionWrapper(instance!);
            _extensions[key] = wrapper;

            if (dispose && instance is IAsyncDisposable asyncDisposable)
                testInfra.AddTestRunCleanup(async _ => { wrapper.IsDisposed = true; await asyncDisposable.DisposeAsync(); });
            else if (dispose && instance is IDisposable disposable)
                testInfra.AddTestRunCleanup(_ => { wrapper.IsDisposed = true; disposable.Dispose(); return Task.CompletedTask; });

            return new(instance, false);
        }
        finally
        {
            initLock.Release();
            _initLocks.TryRemove(key, out _);
        }

        static bool TryReadCached(string key, [NotNullWhen(true)] out ExtensionWrapper? value)
        {
            if (_extensions.TryGetValue(key, out value))
            {
                if (value.IsDisposed)
                    throw new InvalidOperationException("Shared extension cannot be used after it has been disposed.");
                return true;
            }
            return false;
        }
    }
}
