namespace Delaware.Optimizely.Sitemap.Shared.Utilities
{
    internal static class IDictionaryExtensions
    {
        public static TValue? GetValueOrDefault<TKey, TValue>(
            this IDictionary<TKey, TValue?> dictionary,
            TKey key,
            TValue? defaultValue)
        {
            return !dictionary.TryGetValue(key, out var obj) ? defaultValue : obj;
        }
    }
}
