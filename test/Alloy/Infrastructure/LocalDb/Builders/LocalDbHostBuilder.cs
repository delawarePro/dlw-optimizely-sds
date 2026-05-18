using Alloy.Infrastructure.LocalDb.Databases;

namespace Alloy.Infrastructure.LocalDb.Builders;

public interface ILocalDbHostBuilder
{
    ILocalDbHostBuilder WithCms();

    ILocalDbHostBuilder WithDatabase(IDatabaseInfo database);
}

public class LocalDbHostBuilder : ILocalDbHostBuilder
{
    private readonly IConfiguration _configuration;
    private readonly IDictionary<string, IDatabaseInfo> _databases;

    public LocalDbHostBuilder(IConfiguration configuration)
    {
        _configuration = configuration;
        _databases = new Dictionary<string, IDatabaseInfo>(StringComparer.OrdinalIgnoreCase);
    }

    public virtual ILocalDbHostBuilder WithCms()
    {
        var cms = new CmsDatabaseInfo(_configuration);

        _databases[cms.ConnectionStringId] = cms;
        return this;
    }

    public virtual ILocalDbHostBuilder WithDatabase(IDatabaseInfo database)
    {
        _databases[database.ConnectionStringId] = database;
        return this;
    }

    public virtual ILocalDbHost Build()
    {
        return new LocalDbHost(_databases.Values);
    }
}