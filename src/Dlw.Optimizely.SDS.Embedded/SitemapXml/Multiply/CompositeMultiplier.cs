using Dlw.Optimizely.Sds;

namespace Dlw.Optimizely.SDS.Embedded.SitemapXml.Multiply;

public class CompositeMultiplier : IMultiplier
{
    private IList<IMultiplier> Multipliers { get; }

    public CompositeMultiplier(IList<IMultiplier>? multipliers = null)
    {
        Multipliers = multipliers ?? new List<IMultiplier>();
    }

    public void Add(IMultiplier multiplier)
    {
        Multipliers.Add(multiplier);
    }

    public async IAsyncEnumerable<Multiplication> Multiply(ISiteResource source, Multiplication? factor = null)
    {
        if (Multipliers.Count == 0)
        {
            // If no multipliers have been configured, we multiply by 1 so that we have exactly one result.
            yield return new Multiplication();
            yield break;
        }

        var multiplications = new List<Multiplication>();

        for (var i = 0; i < Multipliers.Count; i++)
        {
            if (i == 0)
            {
                await foreach (var multiplication in Multipliers[i].Multiply(source))
                    multiplications.Add(multiplication);
            }
            else
            {
                var newMultiplications = new List<Multiplication>();
                foreach (var existing in multiplications)
                {
                    var calculated = new List<Multiplication>();
                    await foreach (var multiplication in Multipliers[i].Multiply(source, existing))
                        calculated.Add(multiplication);

                    // 0 results should result in no multiplications.                        
                    if (calculated.Count > 0)
                        newMultiplications.AddRange(existing.Combine(calculated));
                }
                multiplications = newMultiplications;
            }
        }

        foreach (var multiplication in multiplications)
        {
            yield return multiplication;
        }
    }
}