using System.Text.Json.Serialization;

namespace Delaware.Optimizely.Sitemap.Shared.Models;

public class Url : AbstractUrl
{
    public IReadOnlyList<LanguageAlternative>? LanguageAlternatives { get; set; }

    [JsonConstructor]
    public Url(string location)
        : base(location)
    {
    }
}