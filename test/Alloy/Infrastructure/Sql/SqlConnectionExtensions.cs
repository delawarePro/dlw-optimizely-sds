#nullable enable

using Microsoft.Data.SqlClient;

namespace Alloy.Infrastructure.Sql;

public static class SqlConnectionExtensions
{
    public static void ExecuteBatchNonQuery(this SqlConnection conn, string sql)
    {
        string sqlBatch = string.Empty;

        sql += "\nGO";   // make sure last batch is executed.
        SqlTransaction? transaction = null;

        try
        {
            conn.Open();

            transaction = conn.BeginTransaction();

            var cmd = new SqlCommand(string.Empty, conn) { CommandTimeout = 180, Transaction = transaction };

            foreach (string line in sql.Split(new string[2] { "\n", "\r" }, StringSplitOptions.RemoveEmptyEntries))
            {
                if (line.ToUpperInvariant().Trim() == "GO")
                {
                    if (string.IsNullOrWhiteSpace(sqlBatch))
                    {
                        sqlBatch = string.Empty;
                        continue;
                    }

                    cmd.CommandText = sqlBatch;
                    cmd.ExecuteNonQuery();
                    sqlBatch = string.Empty;
                }
                else
                {
                    sqlBatch += line + "\n";
                }
            }

            transaction.Commit();
        }
        catch
        {
            transaction?.Rollback();
        }
        finally
        {
            transaction?.Dispose();
            conn.Close();
        }
    }
}