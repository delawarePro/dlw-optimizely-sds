using System.Text.Json.Serialization;

namespace Dlw.Optimizely.SDS.Shared.Models;

public class Url : AbstractUrl
{
    public IReadOnlyList<LanguageAlternative>? LanguageAlternatives { get; set; }

    [JsonConstructor]
    public Url(string location)
        : base(location)
    {
    }
}