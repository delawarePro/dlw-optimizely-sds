namespace Alloy.Infrastructure.LocalDb.Databases;

public class CmsDatabaseInfo : AbstractDatabaseInfo
{
    public override string ConnectionStringId
        => "EPiServerDB";

    public override string UpdateSchemaDbResourceRelativePath
        => "Scripts.EPiServer.Cms.Core.sql";

    public CmsDatabaseInfo(IConfiguration configuration) : base(configuration)
    {
    }
}