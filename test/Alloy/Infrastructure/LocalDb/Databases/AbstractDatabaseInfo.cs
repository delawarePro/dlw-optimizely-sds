#nullable enable

using System.Data;
using Alloy.Infrastructure.Sql;
using Microsoft.Data.SqlClient;

namespace Alloy.Infrastructure.LocalDb.Databases;

public interface IDatabaseInfo
{
    string ConnectionStringId { get; }

    void CreateIfNotExists();
}

public abstract class AbstractDatabaseInfo : IDatabaseInfo
{
    private readonly IConfiguration _configuration;

    private const string CreateDatabaseCommand = @"
            IF NOT EXISTS (SELECT * FROM sys.databases WHERE NAME=@dbName)
            BEGIN
            DECLARE @sql nvarchar(500);
            SET @sql = N'CREATE DATABASE ' + QUOTENAME(@dbName) 
            EXECUTE sp_executesql @sql;
            END
            ";

    private const string CheckDbScript = "SELECT CAST(CASE count(*) WHEN 1 THEN 1 ELSE 0 END AS BIT) FROM sys.databases WHERE name = '{0}'";

    public abstract string ConnectionStringId { get; }

    public abstract string UpdateSchemaDbResourceRelativePath { get; }

    protected AbstractDatabaseInfo(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public virtual void CreateIfNotExists()
    {
        var connectionString = _configuration.GetConnectionString(ConnectionStringId);

        if (string.IsNullOrEmpty(connectionString))
            return;

        if (!TryGetDatabaseName(connectionString, out var databaseName) || string.IsNullOrEmpty(databaseName))
            throw new ArgumentException($"Unable to extract the database name from the provided connection string '{connectionString}'.");

        CreateEmptyDbIfNotExists(connectionString, databaseName);
        UpdateDbSchema(connectionString, UpdateSchemaDbResourceRelativePath);
    }

    private void UpdateDbSchema(string connectionString, string resourceRelativePath)
    {
        using var stream = GetEmbeddedFileAsStream(resourceRelativePath);
        using var reader = new StreamReader(stream);

        var result = reader.ReadToEnd();

        using var connection = new SqlConnection(connectionString);

        connection.ExecuteBatchNonQuery(result);
    }

    private bool DbExists(string masterConnectionString, string name)
    {
        using var connection = new SqlConnection(masterConnectionString);

        connection.Open();

        using var command = connection.CreateCommand();

        command.CommandText = string.Format(CheckDbScript, name);

        return (bool)command.ExecuteScalar();
    }

    private void CreateEmptyDbIfNotExists(string connectionString, string databaseName)
    {
        var masterConnectionString = MasterConnectionString(connectionString);

        if (DbExists(masterConnectionString, databaseName))
            return;

        using (var con = new SqlConnection(masterConnectionString))
        {
            con.Open();
            using (var cmd = con.CreateCommand())
            {
                cmd.CommandText = CreateDatabaseCommand;
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = 300;
                cmd.Parameters.Add(new SqlParameter { ParameterName = "dbName", Value = databaseName });

                cmd.ExecuteNonQuery();
            }
        }

        // Clearing the connection pool seems to help avoid login errors directly after creation
        SqlConnection.ClearAllPools();
    }

    private Stream GetEmbeddedFileAsStream(string resourceRelativePath)
    {
        var type = GetType();
        if (type == null)
            throw new NullReferenceException(nameof(type));

        return type.Assembly.GetManifestResourceStream(type, $"{resourceRelativePath}")
               ?? throw new Exception($"Could not locate embedded resource '{type.Namespace}.{resourceRelativePath}' in '{type.Assembly}'.");
    }

    private static bool TryGetDatabaseName(string connectionString, out string? name)
    {
        var builder = new SqlConnectionStringBuilder(connectionString);

        if (!string.IsNullOrEmpty(builder.AttachDBFilename))
        {
            name = null;
            return false;
        }

        name = builder.InitialCatalog;
        return !string.IsNullOrWhiteSpace(name);
    }

    private static string MasterConnectionString(string connectionString)
    {
        return new SqlConnectionStringBuilder(connectionString)
        {
            InitialCatalog = "master"
        }.ConnectionString;
    }
}