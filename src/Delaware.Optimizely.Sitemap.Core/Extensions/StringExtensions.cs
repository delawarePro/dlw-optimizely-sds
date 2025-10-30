namespace Delaware.Optimizely.Sitemap.Core.Extensions;

public static class StringExtensions
{
    public static string EnsureNoPrefix(this string value, string prefix)
    {
        if (value == null) throw new ArgumentException(nameof(value));
        if (prefix == null) throw new ArgumentException(nameof(prefix));

        return !value.StartsWith(prefix) ? value : value.Remove(0, prefix.Length);
    }

    public static string EnsurePrefix(this string value, string prefix)
    {
        if (value == null) throw new ArgumentException(nameof(value));
        if (prefix == null) throw new ArgumentException(nameof(prefix));

        if (value.StartsWith(prefix)) return value;

        return $"{prefix}{value}";
    }

    public static string EnsureEndsWithSuffix(this string str, string suffix)
    {
        if (str == null) throw new ArgumentException(nameof(str));
        if (suffix == null) throw new ArgumentException(nameof(suffix));

        return !str.EndsWith(suffix) ? $"{str}{suffix}" : str;
    }
}