namespace Delaware.Optimizely.Sitemap.Shared.Models;

public abstract class AbstractUrl
{
    public string Location { get; set; }

    public DateTime? Modified { get; set; }

    protected AbstractUrl(string location)
    {
        Location = location;
    }

    public override bool Equals(object? obj)
    {
        return obj is AbstractUrl url
               && Location == url.Location;
    }

    public override int GetHashCode()
    {
        return HashCode.Combine(Location);
    }

    public override string ToString()
    {
        return Location;
    }
}