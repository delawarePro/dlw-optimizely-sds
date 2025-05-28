namespace Dlw.Optimizely.Sds.Values;

/// <summary>
/// Allows resolving values from any data that supports it.
/// </summary>
public interface IValueResolver
{
    object? GetValue(ISiteResource data);

    IReadOnlyList<object> GetValues(ISiteResource data);
}