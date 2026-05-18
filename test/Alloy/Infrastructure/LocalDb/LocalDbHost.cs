using Alloy.Infrastructure.LocalDb.Databases;

namespace Alloy.Infrastructure.LocalDb;

// This needs to be an IHostedLifecycleService instead of a IHostedService to ensure that the StartingAsync method is called
// before Optimizely checks for database compatibility.
// If we used IHostedService, the StartAsync method would be called after, which would be too late.
public interface ILocalDbHost : IHostedLifecycleService
{

}

public class LocalDbHost : ILocalDbHost
{
    private readonly ICollection<IDatabaseInfo> _databases;

    public LocalDbHost(ICollection<IDatabaseInfo> databases)
    {
        _databases = databases;
    }

    public Task StartedAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    public Task StartingAsync(CancellationToken cancellationToken)
    {
        foreach (var database in _databases)
        {
            database.CreateIfNotExists();
        }

        return Task.CompletedTask;
    }

    public Task StoppedAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    public Task StoppingAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    public Task StartAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }

    public Task StopAsync(CancellationToken cancellationToken)
    {
        return Task.CompletedTask;
    }
}