namespace Delaware.Optimizely.Sitemap.Shared.Utilities;

internal static class IEnumerableExtensions
{
    public static IEnumerable<TSource> Do<TSource>(
        this IEnumerable<TSource> source,
        Action<TSource> action)
    {
        if (source == null)
        {
            throw new ArgumentNullException(nameof(source));
        }

        if (action == null)
        {
            throw new ArgumentNullException(nameof(action));
        }

        foreach (var source1 in source)
        {
            action(source1);
            yield return source1;
        }
    }

    public static async IAsyncEnumerable<T> ToAsync<T>(this IEnumerable<T> source)
    {
        foreach (var item in source)
        {
            yield return item;
        }
        await Task.CompletedTask;
    }

    public static (IEnumerable<T> Matches, IEnumerable<T> NonMatches) Partition<T>(this IEnumerable<T> source, Func<T, bool> predicate)
    {
        var matches = new List<T>();
        var nonMatches = new List<T>();

        foreach (var item in source)
        {
            if (predicate(item))
            {
                matches.Add(item);
            }
            else
            {
                nonMatches.Add(item);
            }
        }

        return (matches, nonMatches);
    }

    public static IEnumerable<TSource> EmptyWhenNull<TSource>(this IEnumerable<TSource> source)
    {
        return source ?? [];
    }
}