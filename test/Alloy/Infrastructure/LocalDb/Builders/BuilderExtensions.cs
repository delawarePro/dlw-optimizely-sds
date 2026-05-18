#nullable enable

using Microsoft.Extensions.Options;

namespace Alloy.Infrastructure.LocalDb.Builders;

public static class BuilderExtensions
{
    public static IServiceCollection AddLocalDbHost(this IServiceCollection services, IConfiguration configuration,
        Action<ILocalDbHostBuilder>? configureBuilder = null)
    {
        services.Configure<LocalDbOptions>(configuration.GetSection("LocalDb"));

        return services.AddHostedService(sp =>
        {
            var options = sp.GetRequiredService<IOptions<LocalDbOptions>>().Value;
            var builder = new LocalDbHostBuilder(configuration);

            if (options.EnsureCms)
                builder.WithCms();

            configureBuilder?.Invoke(builder);

            return (LocalDbHost)builder.Build();
        });
    }
}