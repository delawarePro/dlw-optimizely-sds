namespace Dlw.Optimizely.Sds;

public record SourceSet(IReadOnlyCollection<ISiteResource> Resources, Source Source);