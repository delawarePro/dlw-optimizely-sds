namespace Delaware.Optimizely.Sitemap.Shared.Models;

public class LanguageAlternative
{
    public string Language { get; }

    public string Location { get; }

    public LanguageAlternative(string language, string location)
    {
        Language = language;
        Location = location;
    }

    public override string ToString()
    {
        return $"{Language}: {Location}";
    }
}