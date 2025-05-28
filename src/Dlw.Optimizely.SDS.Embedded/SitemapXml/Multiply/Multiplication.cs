namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Multiply;

/// <summary>
/// A multiplication instance which is the result of the multiplication process (multiply operation).
/// </summary>
public class Multiplication
{
    /// <summary>
    /// Variables for this multiplication instance.
    /// </summary>
    public IDictionary<string, object?> Variables { get; }

    /// <summary>
    /// Optional set of languages to use for urls in this multiplication instance.
    /// If the resource contains only a single language,
    /// this set can be used to generate language alternatives.
    /// </summary>
    public string[]? AllLanguages { get; }

    public Multiplication(IDictionary<string, object?>? variables = null, string[]? allLanguages = null)
    {
        Variables = variables ?? new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);
        AllLanguages = allLanguages;
    }

    public Multiplication Combine(Multiplication multiplication)
    {
        var newVariables = new Dictionary<string, object?>(this.Variables, StringComparer.OrdinalIgnoreCase);
        foreach (var pair in multiplication.Variables)
        {
            newVariables[pair.Key] = pair.Value;
        }
        return new Multiplication(newVariables, multiplication.AllLanguages ?? AllLanguages);
    }

    public IEnumerable<Multiplication> Combine(IEnumerable<Multiplication> multiplications)
    {
        return multiplications.Select(x => Combine(x));
    }
}