using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;

namespace Unleashing_Potential
{
    public static class BookingDB
    {
        private static string ConnStr
            => ConfigurationManager.ConnectionStrings["ProjectDB"].ConnectionString;

        // ═══════════════════════════════════════════════
        // AUDIT LOG
        // ═══════════════════════════════════════════════
        public static void WriteAuditLog(string userName, string action, string description)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "INSERT INTO AuditLogs (UserName, Action, Description, LogDate) " +
                        "VALUES (@UserName, @Action, @Description, @LogDate)", conn);

                    cmd.Parameters.Add("@UserName", SqlDbType.NVarChar, 100).Value =
                        string.IsNullOrEmpty(userName) ? (object)DBNull.Value : userName;
                    cmd.Parameters.Add("@Action", SqlDbType.NVarChar, 50).Value = action;
                    cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value = description;
                    cmd.Parameters.Add("@LogDate", SqlDbType.DateTime).Value = DateTime.Now;
                    cmd.ExecuteNonQuery();
                }
            }
            catch { /* Never let logging break the main flow */ }
        }

        // ═══════════════════════════════════════════════
        // AUTHENTICATION
        // ═══════════════════════════════════════════════

        public static bool FullNameExists(string fullName)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Users WHERE LOWER(FullName) = LOWER(@FullName)", conn);
                    cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = fullName;
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                throw;
            }
        }

        public static bool EmailExists(string email)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Users WHERE Email = @Email", conn);
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                throw;
            }
        }

        public static string HashPassword(string password)
        {
            using (var sha = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = System.Text.Encoding.UTF8.GetBytes(password);
                byte[] hash = sha.ComputeHash(bytes);

                var sb = new System.Text.StringBuilder();
                foreach (byte b in hash)
                    sb.Append(b.ToString("x2"));

                return sb.ToString();
            }
        }

        private static string ReadStringOrEmpty(SqlDataReader reader, string columnName)
        {
            if (!HasColumn(reader, columnName))
                return string.Empty;

            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? string.Empty : reader.GetString(ordinal);
        }

        private static bool HasColumn(SqlDataReader reader, string columnName)
        {
            try
            {
                reader.GetOrdinal(columnName);
                return true;
            }
            catch (IndexOutOfRangeException)
            {
                return false;
            }
        }

        private static int? ReadIntOrNull(SqlDataReader reader, string columnName)
        {
            if (!HasColumn(reader, columnName))
                return null;

            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? (int?)null : Convert.ToInt32(reader.GetValue(ordinal));
        }

        private static decimal? ReadDecimalOrNull(SqlDataReader reader, string columnName)
        {
            if (!HasColumn(reader, columnName))
                return null;

            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? (decimal?)null : Convert.ToDecimal(reader.GetValue(ordinal));
        }

        private static DateTime? ReadDateTimeOrNull(SqlDataReader reader, string columnName)
        {
            if (!HasColumn(reader, columnName))
                return null;

            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? (DateTime?)null : reader.GetDateTime(ordinal);
        }

        private static bool ReadBoolOrFalse(SqlDataReader reader, string columnName)
        {
            if (!HasColumn(reader, columnName))
                return false;

            int ordinal = reader.GetOrdinal(columnName);
            return !reader.IsDBNull(ordinal) && reader.GetBoolean(ordinal);
        }

        private static int? GetCurrentUserId()
        {
            object value = HttpContext.Current?.Session?["UserID"];
            if (value == null || value == DBNull.Value)
                return null;

            try
            {
                return Convert.ToInt32(value);
            }
            catch
            {
                return null;
            }
        }

        private static int ResolveOrCreateCustomerId(SqlConnection conn, SqlTransaction tx, int userId, string preferredPaymentMethod)
        {
            using (var lookupCmd = new SqlCommand(
                "SELECT TOP 1 CustomerID FROM Customer WHERE UserID = @UserID", conn, tx))
            {
                lookupCmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                object result = lookupCmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    return Convert.ToInt32(result);
            }

            using (var insertCmd = new SqlCommand(
                "INSERT INTO Customer (UserID, PreferredPaymentMethod, DateJoined) OUTPUT INSERTED.CustomerID " +
                "VALUES (@UserID, @PreferredPaymentMethod, @DateJoined)", conn, tx))
            {
                insertCmd.Parameters.Add("@UserID", SqlDbType.Int).Value = userId;
                insertCmd.Parameters.Add("@PreferredPaymentMethod", SqlDbType.NVarChar, 50).Value =
                    string.IsNullOrWhiteSpace(preferredPaymentMethod) ? "PayOnCompletion" : preferredPaymentMethod.Trim();
                insertCmd.Parameters.Add("@DateJoined", SqlDbType.DateTime).Value = DateTime.Now;
                object result = insertCmd.ExecuteScalar();
                if (result != null && result != DBNull.Value)
                    return Convert.ToInt32(result);
            }

            throw new InvalidOperationException("The customer profile could not be resolved.");
        }

        private static bool TableExists(SqlConnection conn, string tableName)
        {
            using (var cmd = new SqlCommand(
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName", conn))
            {
                cmd.Parameters.Add("@TableName", SqlDbType.NVarChar, 128).Value = tableName;
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }

        private static string FirstExistingTable(SqlConnection conn, params string[] tableNames)
        {
            foreach (string tableName in tableNames)
            {
                if (TableExists(conn, tableName))
                    return tableName;
            }

            return null;
        }

        private static string FirstExistingColumn(SqlConnection conn, string tableName, params string[] columnNames)
        {
            foreach (string columnName in columnNames)
            {
                using (var cmd = new SqlCommand(
                    "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS " +
                    "WHERE TABLE_NAME = @TableName AND COLUMN_NAME = @ColumnName", conn))
                {
                    cmd.Parameters.Add("@TableName", SqlDbType.NVarChar, 128).Value = tableName;
                    cmd.Parameters.Add("@ColumnName", SqlDbType.NVarChar, 128).Value = columnName;

                    if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                        return columnName;
                }
            }

            return null;
        }

        private static string NormalizeStatus(string status)
        {
            if (string.IsNullOrWhiteSpace(status))
                return string.Empty;

            string trimmed = status.Trim();
            if (trimmed.Equals("Complete", StringComparison.OrdinalIgnoreCase))
                return "Completed";
            if (trimmed.Equals("Accepted", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";
            if (trimmed.Equals("InProcess", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";
            if (trimmed.Equals("In Progress", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";
            if (trimmed.Equals("AppointmentDay", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";
            return trimmed;
        }

        private static string NormalizeLookupKey(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                return string.Empty;

            var builder = new StringBuilder(value.Length);
            foreach (char ch in value.Trim())
            {
                if (char.IsWhiteSpace(ch) || ch == '-' || ch == '_')
                    continue;

                builder.Append(char.ToLowerInvariant(ch));
            }

            return builder.ToString();
        }

        private static string StatusNameFromId(int? statusId)
        {
            if (!statusId.HasValue)
                return "Pending";

            switch (statusId.Value)
            {
                case 1: return "Pending";
                case 2: return "Confirmed";
                case 3: return "Completed";
                case 4: return "Cancelled";
                default: return statusId.Value.ToString();
            }
        }

        private static string QuoteIdentifier(string identifier)
        {
            return "[" + (identifier ?? string.Empty).Replace("]", "]]") + "]";
        }

        private static int? ResolveCategoryId(SqlConnection conn, string categoryName)
        {
            if (string.IsNullOrWhiteSpace(categoryName))
                return null;

            using (var cmd = new SqlCommand(
                "SELECT TOP 1 CategoryID " +
                "FROM Category " +
                "WHERE IsActive = 1 " +
                "AND LOWER(REPLACE(REPLACE(REPLACE(Name, ' ', ''), '-', ''), '_', '')) = @NormalizedName", conn))
            {
                cmd.Parameters.Add("@NormalizedName", SqlDbType.NVarChar, 100).Value = NormalizeLookupKey(categoryName);
                object result = cmd.ExecuteScalar();
                if (result == null || result == DBNull.Value)
                    return null;

                return Convert.ToInt32(result);
            }
        }

        private static Service ResolveServiceForCategory(SqlConnection conn, string categoryName)
        {
            if (conn == null || string.IsNullOrWhiteSpace(categoryName))
                return null;

            int? categoryId = ResolveCategoryId(conn, categoryName);
            if (categoryId.HasValue)
            {
                using (var cmd = new SqlCommand(
                    "SELECT TOP 1 ServiceID, CategoryID, Name, Description, MinPrice, MaxPrice, PriceUnit, IsActive, DateCreated " +
                    "FROM Service " +
                    "WHERE IsActive = 1 AND CategoryID = @CategoryID " +
                    "ORDER BY ServiceID", conn))
                {
                    cmd.Parameters.Add("@CategoryID", SqlDbType.Int).Value = categoryId.Value;
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                            return MapService(reader);
                    }
                }
            }

            string normalizedName = NormalizeLookupKey(categoryName);
            if (string.IsNullOrWhiteSpace(normalizedName))
                return null;

            using (var cmd = new SqlCommand(
                "SELECT TOP 1 ServiceID, CategoryID, Name, Description, MinPrice, MaxPrice, PriceUnit, IsActive, DateCreated " +
                "FROM Service " +
                "WHERE IsActive = 1 " +
                "AND LOWER(REPLACE(REPLACE(REPLACE(Name, ' ', ''), '-', ''), '_', '')) = @NormalizedName " +
                "ORDER BY ServiceID", conn))
            {
                cmd.Parameters.Add("@NormalizedName", SqlDbType.NVarChar, 100).Value = normalizedName;
                using (var reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                        return MapService(reader);
                }
            }

            return null;
        }

        public static Service GetActiveServiceForCategory(string categoryName)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    return ResolveServiceForCategory(conn, categoryName);
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                return null;
            }
        }

        private static int? ResolveServiceId(SqlConnection conn, BasketItem item)
        {
            if (item == null)
                return null;

            if (item.ServiceID.HasValue)
                return item.ServiceID;

            Service categoryService = ResolveServiceForCategory(conn, item.Category);
            if (categoryService != null)
                return categoryService.ServiceID;

            string serviceName = (item.Service ?? string.Empty).Trim();
            if (!string.IsNullOrWhiteSpace(serviceName))
            {
                using (var cmd = new SqlCommand(
                    "SELECT TOP 1 ServiceID FROM Service " +
                    "WHERE IsActive = 1 AND (LOWER(Name) = LOWER(@Name) OR LOWER(Description) = LOWER(@Name)) " +
                    "ORDER BY ServiceID", conn))
                {
                    cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = serviceName;
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        return Convert.ToInt32(result);
                }
            }

            using (var cmd = new SqlCommand(
                "SELECT TOP 1 ServiceID FROM Service WHERE IsActive = 1 ORDER BY ServiceID", conn))
            {
                object result = cmd.ExecuteScalar();
                return result == null || result == DBNull.Value ? (int?)null : Convert.ToInt32(result);
            }
        }

        private static string BuildBookingSelectSql(string whereClause)
        {
            var sql = new StringBuilder();
            sql.AppendLine("SELECT");
            sql.AppendLine("    b.BookingID,");
            sql.AppendLine("    b.ReferenceNumber,");
            sql.AppendLine("    b.CustomerID,");
            sql.AppendLine("    b.LocationID,");
            sql.AppendLine("    b.BookingStatusID,");
            sql.AppendLine("    b.BookingDate,");
            sql.AppendLine("    b.AppointmentDate,");
            sql.AppendLine("    b.Notes,");
            sql.AppendLine("    b.ReviewLeft,");
            sql.AppendLine("    ISNULL(u.FullName, '') AS CustomerName,");
            sql.AppendLine("    ISNULL(u.Phone, '') AS CustomerPhone,");
            sql.AppendLine("    ISNULL(u.Township, '') AS CustomerAddress,");
            sql.AppendLine("    ISNULL(bs.Name, '') AS Status,");
            sql.AppendLine("    ISNULL(pay.PaymentMethod, '') AS PaymentMethod,");
            sql.AppendLine("    ISNULL(pay.TotalAmount, 0) AS TotalAmount,");
            sql.AppendLine("    ISNULL(pay.AmountPaid, 0) AS AmountPaid");
            sql.AppendLine("FROM Booking b");
            sql.AppendLine("LEFT JOIN Customer c ON b.CustomerID = c.CustomerID");
            sql.AppendLine("LEFT JOIN Users u ON c.UserID = u.UserID");
            sql.AppendLine("LEFT JOIN BookingStatus bs ON b.BookingStatusID = bs.BookingStatusID");
            sql.AppendLine("OUTER APPLY (");
            sql.AppendLine("    SELECT TOP 1");
            sql.AppendLine("        pm.Name AS PaymentMethod,");
            sql.AppendLine("        p.TotalAmount,");
            sql.AppendLine("        p.AmountPaid");
            sql.AppendLine("    FROM Payment p");
            sql.AppendLine("    LEFT JOIN PaymentMethod pm ON p.PaymentMethodID = pm.PaymentMethodID");
            sql.AppendLine("    WHERE p.BookingID = b.BookingID");
            sql.AppendLine("    ORDER BY p.PaymentDate DESC, p.PaymentID DESC");
            sql.AppendLine(") pay");

            if (!string.IsNullOrWhiteSpace(whereClause))
            {
                sql.Append(" ").Append(whereClause.Trim()).AppendLine();
            }

            sql.AppendLine("ORDER BY b.BookingDate DESC, b.BookingID DESC");
            return sql.ToString();
        }

        public static bool RegisterUser(
            string fullName, string email, string phone,
            DateTime dob, string township, string passwordHash,
            string securityQuestion, string securityAnswerHash)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "INSERT INTO Users (FullName, Email, Phone, DateOfBirth, Township, " +
                        "PasswordHash, SecurityQuestion, SecurityAnswerHash, DateCreated, IsActive) " +
                        "VALUES (@FullName, @Email, @Phone, @DOB, @Township, " +
                        "@PasswordHash, @SecurityQuestion, @SecurityAnswerHash, @DateCreated, @IsActive)",
                        conn);

                    cmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = fullName;
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    cmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 20).Value = phone;
                    cmd.Parameters.Add("@DOB", SqlDbType.Date).Value = dob;
                    cmd.Parameters.Add("@Township", SqlDbType.NVarChar, 100).Value = township;
                    cmd.Parameters.Add("@PasswordHash", SqlDbType.NVarChar, 64).Value = passwordHash;
                    cmd.Parameters.Add("@SecurityQuestion", SqlDbType.NVarChar, 200).Value = securityQuestion;
                    cmd.Parameters.Add("@SecurityAnswerHash", SqlDbType.NVarChar, 64).Value = securityAnswerHash;
                    cmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = DateTime.Now;
                    cmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = true;

                    return cmd.ExecuteNonQuery() == 1;
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(fullName, "DB_ERROR", ex.Message);
                throw;
            }
        }

        public static string GetSecurityQuestion(string email)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT SecurityQuestion FROM Users WHERE Email = @Email", conn);
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;

                    object result = cmd.ExecuteScalar();
                    return result == null || result == DBNull.Value
                        ? null
                        : result.ToString();
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                throw;
            }
        }

        public static bool ValidateSecurityAnswer(string email, string answerHash)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM Users " +
                        "WHERE Email = @Email AND SecurityAnswerHash = @AnswerHash", conn);
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    cmd.Parameters.Add("@AnswerHash", SqlDbType.NVarChar, 64).Value = answerHash;
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                throw;
            }
        }

        public static bool ResetPassword(string email, string newPasswordHash)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "UPDATE Users SET PasswordHash = @PasswordHash WHERE Email = @Email", conn);
                    cmd.Parameters.Add("@PasswordHash", SqlDbType.NVarChar, 64).Value = newPasswordHash;
                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    return cmd.ExecuteNonQuery() == 1;
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                throw;
            }
        }

        public static Users LoginUser(string email, string passwordHash)
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT UserID, FullName, Email, Phone, Township, Role " +
                        "FROM Users " +
                        "WHERE Email = @Email AND PasswordHash = @PasswordHash AND IsActive = 1",
                        conn);

                    cmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    cmd.Parameters.Add("@PasswordHash", SqlDbType.NVarChar, 64).Value = passwordHash;

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (!reader.Read()) return null;

                        return new Users
                        {
                            UserID = reader.GetInt32(reader.GetOrdinal("UserID")),
                            FullName = ReadStringOrEmpty(reader, "FullName"),
                            Email = ReadStringOrEmpty(reader, "Email"),
                            Phone = ReadStringOrEmpty(reader, "Phone"),
                            Township = ReadStringOrEmpty(reader, "Township"),
                            Role = ReadStringOrEmpty(reader, "Role")
                        };
                    }
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                throw;
            }
        }

        // ═══════════════════════════════════════════════
        // SERVICE PROVIDERS
        // ═══════════════════════════════════════════════
        public static List<ServiceProvider> GetProvidersByCategory(string category)
        {
            var list = new List<ServiceProvider>();
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT * FROM ServiceProviders " +
                        "WHERE Category = @Category " +
                        "ORDER BY Rating DESC", conn);

                    cmd.Parameters.Add("@Category", SqlDbType.NVarChar, 50).Value = category;

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                            list.Add(MapProvider(reader));
                    }
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
            }
            return list;
        }

        public static ServiceProvider GetProviderByID(int providerID)
        {
            ServiceProvider provider = null;
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT * FROM ServiceProviders WHERE ProviderID = @ProviderID", conn);
                    cmd.Parameters.Add("@ProviderID", SqlDbType.Int).Value = providerID;

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                            provider = MapProvider(reader);
                    }
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
            }
            return provider;
        }

        private static void UpdateProviderRating(int providerID, SqlConnection conn,
                                                  SqlTransaction transaction)
        {
            var cmd = new SqlCommand(
                "UPDATE ServiceProviders " +
                "SET Rating = (SELECT AVG(CAST(Rating AS DECIMAL(3,1))) FROM Reviews WHERE ProviderID = @ProviderID), " +
                "    ReviewCount = (SELECT COUNT(*) FROM Reviews WHERE ProviderID = @ProviderID) " +
                "WHERE ProviderID = @ProviderID", conn);
            cmd.Transaction = transaction;
            cmd.Parameters.Add("@ProviderID", SqlDbType.Int).Value = providerID;
            cmd.ExecuteNonQuery();
        }

        private static ServiceProvider MapProvider(SqlDataReader reader)
        {
            return new ServiceProvider
            {
                ProviderID = reader.GetInt32(reader.GetOrdinal("ProviderID")),
                Name = reader.GetString(reader.GetOrdinal("Name")),
                Category = reader.GetString(reader.GetOrdinal("Category")),
                Specialty = reader.GetString(reader.GetOrdinal("Specialty")),
                Description = reader.GetString(reader.GetOrdinal("Description")),
                Price = reader.GetDecimal(reader.GetOrdinal("Price")),
                PriceUnit = reader.GetString(reader.GetOrdinal("PriceUnit")),
                Rating = (double)reader.GetDecimal(reader.GetOrdinal("Rating")),
                ReviewCount = reader.GetInt32(reader.GetOrdinal("ReviewCount")),
                Location = reader.GetString(reader.GetOrdinal("Location")),
                Phone = reader.GetString(reader.GetOrdinal("Phone")),
                YearsExperience = reader.GetInt32(reader.GetOrdinal("YearsExperience"))
            };
        }

        private static Service MapService(SqlDataReader reader)
        {
            return new Service
            {
                ServiceID = reader.GetInt32(reader.GetOrdinal("ServiceID")),
                CategoryID = ReadIntOrNull(reader, "CategoryID"),
                Name = ReadStringOrEmpty(reader, "Name"),
                Description = ReadStringOrEmpty(reader, "Description"),
                MinPrice = reader.GetDecimal(reader.GetOrdinal("MinPrice")),
                MaxPrice = reader.GetDecimal(reader.GetOrdinal("MaxPrice")),
                PriceUnit = ReadStringOrEmpty(reader, "PriceUnit"),
                IsActive = ReadBoolOrFalse(reader, "IsActive"),
                DateCreated = reader.GetDateTime(reader.GetOrdinal("DateCreated"))
            };
        }

        // ═══════════════════════════════════════════════
        // REVIEWS
        // ═══════════════════════════════════════════════
        public static List<Review> GetReviewsByProvider(int providerID)
        {
            var list = new List<Review>();
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        "SELECT * FROM Reviews WHERE ProviderID = @ProviderID " +
                        "ORDER BY ReviewDate DESC", conn);
                    cmd.Parameters.Add("@ProviderID", SqlDbType.Int).Value = providerID;

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                            list.Add(MapReview(reader));
                    }
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
            }
            return list;
        }

        public static void AddReviews(List<Review> reviews, string bookingReference)
        {
            if (reviews == null || reviews.Count == 0) return;

            SqlTransaction transaction = null;
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    transaction = conn.BeginTransaction();

                    foreach (var review in reviews)
                    {
                        var cmd = new SqlCommand(
                            "INSERT INTO Reviews (ProviderID, BookingReference, ReviewerName, " +
                            "Rating, Comment, ReviewDate) " +
                            "VALUES (@ProviderID, @BookingRef, @ReviewerName, " +
                            "@Rating, @Comment, @ReviewDate)", conn);
                        cmd.Transaction = transaction;

                        cmd.Parameters.Add("@ProviderID", SqlDbType.Int).Value = review.ProviderID;
                        cmd.Parameters.Add("@BookingRef", SqlDbType.NVarChar, 20).Value = bookingReference;
                        cmd.Parameters.Add("@ReviewerName", SqlDbType.NVarChar, 100).Value = review.ReviewerName;
                        cmd.Parameters.Add("@Rating", SqlDbType.Int).Value = review.Rating;
                        cmd.Parameters.Add("@Comment", SqlDbType.NVarChar, 1000).Value = review.Comment;
                        cmd.Parameters.Add("@ReviewDate", SqlDbType.DateTime).Value = DateTime.Now;
                        cmd.ExecuteNonQuery();

                        UpdateProviderRating(review.ProviderID, conn, transaction);
                    }

                    var updateCmd = new SqlCommand(
                        "UPDATE Booking SET ReviewLeft = 1 " +
                        "WHERE ReferenceNumber = @Ref", conn);
                    updateCmd.Transaction = transaction;
                    updateCmd.Parameters.Add("@Ref", SqlDbType.NVarChar, 20).Value = bookingReference;
                    updateCmd.ExecuteNonQuery();

                    transaction.Commit();
                }
            }
            catch (SqlException ex)
            {
                if (transaction != null)
                    try { transaction.Rollback(); } catch { }
                WriteAuditLog(null, "DB_ERROR", ex.Message);
                throw;
            }
        }

        private static Review MapReview(SqlDataReader reader)
        {
            return new Review
            {
                ReviewID = reader.GetInt32(reader.GetOrdinal("ReviewID")),
                ProviderID = reader.GetInt32(reader.GetOrdinal("ProviderID")),
                BookingReference = reader.GetString(reader.GetOrdinal("BookingReference")),
                ReviewerName = reader.GetString(reader.GetOrdinal("ReviewerName")),
                Rating = reader.GetInt32(reader.GetOrdinal("Rating")),
                Comment = reader.GetString(reader.GetOrdinal("Comment")),
                ReviewDate = reader.GetDateTime(reader.GetOrdinal("ReviewDate"))
            };
        }

        // ═══════════════════════════════════════════════
        // BOOKINGS
        // ═══════════════════════════════════════════════
        public static string SaveBooking(Booking booking)
        {
            if (booking == null)
                throw new ArgumentNullException(nameof(booking));

            string refNumber = GenerateReference();
            booking.ReferenceNumber = refNumber;

            int? currentUserId = GetCurrentUserId();
            if (!currentUserId.HasValue)
                throw new InvalidOperationException("The booking could not be saved because the customer was not identified.");

            int statusId = booking.BookingStatusID ?? 1;
            DateTime bookingDate = booking.BookingDate == default(DateTime) ? DateTime.Now : booking.BookingDate;
            DateTime appointmentDate = booking.AppointmentDate;
            string notes = string.IsNullOrWhiteSpace(booking.Notes) ? string.Empty : booking.Notes.Trim();

            var preparedItems = new List<BasketItem>();
            foreach (var item in booking.Items ?? new List<BasketItem>())
            {
                if (item == null)
                    continue;

                if (!item.ServiceID.HasValue)
                    throw new InvalidOperationException("One of the booking items is missing a service ID.");
                if (item.ProviderID <= 0)
                    throw new InvalidOperationException("One of the booking items is missing a provider ID.");

                preparedItems.Add(new BasketItem
                {
                    ServiceID = item.ServiceID,
                    ProviderID = item.ProviderID,
                    ProviderName = item.ProviderName,
                    Service = item.Service,
                    Category = item.Category,
                    Price = item.Price,
                    PriceUnit = item.PriceUnit,
                    Quantity = 1
                });
            }

            if (preparedItems.Count == 0)
                throw new InvalidOperationException("The booking could not be saved because there are no booking items.");

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    using (var tx = conn.BeginTransaction())
                    {
                        try
                        {
                            int customerId = ResolveOrCreateCustomerId(
                                conn, tx, currentUserId.Value, booking.PaymentMethod);

                            string insertBooking =
                                "INSERT INTO Booking (ReferenceNumber, CustomerID, LocationID, BookingStatusID, " +
                                "AppointmentDate, BookingDate, Notes, ReviewLeft) " +
                                "VALUES (@Ref, @CustomerID, @LocationID, @StatusID, @AppDate, @BookDate, @Notes, 0); " +
                                "SELECT SCOPE_IDENTITY();";

                            using (var cmd = new SqlCommand(insertBooking, conn, tx))
                            {
                                cmd.Parameters.Add("@Ref", SqlDbType.NVarChar, 20).Value = refNumber;
                                cmd.Parameters.Add("@CustomerID", SqlDbType.Int).Value = customerId;
                                cmd.Parameters.Add("@LocationID", SqlDbType.Int).Value = DBNull.Value;
                                cmd.Parameters.Add("@StatusID", SqlDbType.Int).Value = statusId;
                                cmd.Parameters.Add("@BookDate", SqlDbType.DateTime).Value = bookingDate;
                                cmd.Parameters.Add("@AppDate", SqlDbType.Date).Value = appointmentDate;
                                cmd.Parameters.Add("@Notes", SqlDbType.NVarChar, 500).Value = notes;

                                int newBookingID = Convert.ToInt32(cmd.ExecuteScalar());

                                foreach (var item in preparedItems)
                                {
                                    using (var itemCmd = new SqlCommand(
                                        "INSERT INTO BookingItem (BookingID, ServiceID, ProviderID, Quantity, UnitPrice) " +
                                        "VALUES (@BookingID, @ServiceID, @ProviderID, @Quantity, @UnitPrice)", conn, tx))
                                    {
                                        itemCmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = newBookingID;
                                        itemCmd.Parameters.Add("@ServiceID", SqlDbType.Int).Value = item.ServiceID.Value;
                                        itemCmd.Parameters.Add("@ProviderID", SqlDbType.Int).Value = item.ProviderID;
                                        itemCmd.Parameters.Add("@Quantity", SqlDbType.Int).Value = 1;
                                        var unitPriceParam = itemCmd.Parameters.Add("@UnitPrice", SqlDbType.Decimal);
                                        unitPriceParam.Precision = 18;
                                        unitPriceParam.Scale = 2;
                                        unitPriceParam.Value = item.Price;

                                        itemCmd.ExecuteNonQuery();
                                    }
                                }
                            }

                            tx.Commit();
                        }
                        catch
                        {
                            try { tx.Rollback(); } catch { }
                            throw;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                WriteAuditLog(null, "BOOKING_SAVE_FAILED", ex.Message);
                throw;
            }

            return refNumber;
        }

        public static Booking GetBookingByReference(string referenceNumber)
        {
            Booking booking = null;
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    var cmd = new SqlCommand(
                        BuildBookingSelectSql("WHERE b.ReferenceNumber = @Ref"), conn);
                    cmd.Parameters.Add("@Ref", SqlDbType.NVarChar, 20).Value = referenceNumber;

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                            booking = MapBooking(reader);
                    }

                    if (booking == null) return null;

                    booking.Items = GetBookingItems(booking.BookingID, conn);
                    FinalizeBookingSummary(booking);
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
            }
            return booking;
        }

        public static List<Booking> GetBookingsByCustomer(string customerName)
        {
            var list = new List<Booking>();
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    var cmd = new SqlCommand(
                        BuildBookingSelectSql(
                            "WHERE u.FullName = @CustomerName OR u.Email = @CustomerName"), conn);
                    cmd.Parameters.Add("@CustomerName", SqlDbType.NVarChar, 100).Value = customerName;

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                            list.Add(MapBooking(reader));
                    }

                    foreach (var b in list)
                    {
                        b.Items = GetBookingItems(b.BookingID, conn);
                        FinalizeBookingSummary(b);
                    }
                }
            }
            catch (SqlException ex)
            {
                WriteAuditLog(null, "DB_ERROR", ex.Message);
            }
            return list;
        }

        private static List<BasketItem> GetBookingItems(int bookingID, SqlConnection conn)
        {
            var items = new List<BasketItem>();
            var cmd = new SqlCommand(
                "SELECT bi.ItemID, bi.BookingID, bi.ServiceID, bi.ProviderID, bi.Quantity, bi.UnitPrice, " +
                "       ISNULL(sp.Name, '') AS ProviderName, " +
                "       ISNULL(s.Name, sp.Specialty) AS Service, " +
                "       ISNULL(s.CategoryID, 0) AS CategoryID, " +
                "       ISNULL(sp.Category, '') AS Category, " +
                "       ISNULL(COALESCE(s.PriceUnit, sp.PriceUnit), '') AS PriceUnit " +
                "FROM BookingItem bi " +
                "LEFT JOIN ServiceProviders sp ON bi.ProviderID = sp.ProviderID " +
                "LEFT JOIN Service s ON bi.ServiceID = s.ServiceID " +
                "WHERE bi.BookingID = @BookingID " +
                "ORDER BY bi.ItemID", conn);
            cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingID;

            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    items.Add(new BasketItem
                    {
                        ServiceID = ReadIntOrNull(reader, "ServiceID"),
                        ProviderID = reader.GetInt32(reader.GetOrdinal("ProviderID")),
                        ProviderName = ReadStringOrEmpty(reader, "ProviderName"),
                        Service = ReadStringOrEmpty(reader, "Service"),
                        Category = ReadStringOrEmpty(reader, "Category"),
                        Price = reader.GetDecimal(reader.GetOrdinal("UnitPrice")),
                        PriceUnit = ReadStringOrEmpty(reader, "PriceUnit"),
                        Quantity = reader.GetInt32(reader.GetOrdinal("Quantity"))
                    });
                }
            }
            return items;
        }

        private static void FinalizeBookingSummary(Booking booking)
        {
            if (booking == null)
                return;

            decimal lineTotal = 0m;
            if (booking.Items != null && booking.Items.Count > 0)
                lineTotal = booking.Items.Sum(i => i.LineTotal);

            if (booking.TotalAmount <= 0m && lineTotal > 0m)
                booking.TotalAmount = lineTotal;

            if (string.IsNullOrWhiteSpace(booking.PaymentMethod))
                booking.PaymentMethod = "Pay on Completion";

            if (booking.AmountPaid <= 0m &&
                string.Equals(NormalizeStatus(booking.Status), "Completed", StringComparison.OrdinalIgnoreCase))
            {
                booking.AmountPaid = booking.TotalAmount;
            }
        }

        private static Booking MapBooking(SqlDataReader reader)
        {
            int notesCol = HasColumn(reader, "Notes") ? reader.GetOrdinal("Notes") : -1;
            string status = NormalizeStatus(ReadStringOrEmpty(reader, "Status"));
            if (string.IsNullOrWhiteSpace(status))
                status = StatusNameFromId(ReadIntOrNull(reader, "BookingStatusID"));

            return new Booking
            {
                BookingID = reader.GetInt32(reader.GetOrdinal("BookingID")),
                ReferenceNumber = reader.GetString(reader.GetOrdinal("ReferenceNumber")),
                CustomerID = ReadIntOrNull(reader, "CustomerID"),
                LocationID = ReadIntOrNull(reader, "LocationID"),
                BookingStatusID = ReadIntOrNull(reader, "BookingStatusID"),
                Status = status,
                BookingDate = reader.GetDateTime(reader.GetOrdinal("BookingDate")),
                AppointmentDate = reader.GetDateTime(reader.GetOrdinal("AppointmentDate")),
                CustomerName = ReadStringOrEmpty(reader, "CustomerName"),
                CustomerPhone = ReadStringOrEmpty(reader, "CustomerPhone"),
                CustomerAddress = ReadStringOrEmpty(reader, "CustomerAddress"),
                Notes = notesCol < 0 || reader.IsDBNull(notesCol) ? "" : reader.GetString(notesCol),
                ReviewLeft = ReadBoolOrFalse(reader, "ReviewLeft"),
                PaymentMethod = ReadStringOrEmpty(reader, "PaymentMethod"),
                TotalAmount = ReadDecimalOrNull(reader, "TotalAmount") ?? 0m,
                AmountPaid = ReadDecimalOrNull(reader, "AmountPaid") ?? 0m
            };
        }

        public static string GenerateReference()
        {
            return "BK"
                + DateTime.Now.ToString("yyMMddHHmmssfff")
                + Guid.NewGuid().ToString("N").Substring(0, 3).ToUpperInvariant();
        }
    }

    // ═══════════════════════════════════════════════
    // MODEL CLASSES
    // ═══════════════════════════════════════════════

    [Serializable]
    public class ServiceProvider
    {
        public int ProviderID { get; set; }
        public string Name { get; set; }
        public string Category { get; set; }
        public string Specialty { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public string PriceUnit { get; set; }
        public double Rating { get; set; }
        public int ReviewCount { get; set; }
        public string Location { get; set; }
        public string Phone { get; set; }
        public int YearsExperience { get; set; }
    }

    [Serializable]
    public class Review
    {
        public int ReviewID { get; set; }
        public int ProviderID { get; set; }
        public string BookingReference { get; set; }
        public string ReviewerName { get; set; }
        public int Rating { get; set; }
        public string Comment { get; set; }
        public DateTime ReviewDate { get; set; }
    }

    [Serializable]
    public class BasketItem
    {
        public int? ServiceID { get; set; }
        public int ProviderID { get; set; }
        public string ProviderName { get; set; }
        public string Service { get; set; }
        public string Category { get; set; }
        public decimal Price { get; set; }
        public string PriceUnit { get; set; }
        public int Quantity { get; set; }

        public decimal LineTotal => Price * Quantity;
    }

    [Serializable]
    public class Service
    {
        public int ServiceID { get; set; }
        public int? CategoryID { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public decimal MinPrice { get; set; }
        public decimal MaxPrice { get; set; }
        public string PriceUnit { get; set; }
        public bool IsActive { get; set; }
        public DateTime DateCreated { get; set; }
    }

    [Serializable]
    public class Booking
    {
        public int BookingID { get; set; }
        public string ReferenceNumber { get; set; }
        public int? CustomerID { get; set; }
        public int? LocationID { get; set; }
        public string ServiceAddress { get; set; }
        public int? BookingStatusID { get; set; }
        public string Status { get; set; }
        public DateTime BookingDate { get; set; }
        public DateTime AppointmentDate { get; set; }
        public string CustomerName { get; set; }
        public string CustomerPhone { get; set; }
        public string CustomerAddress { get; set; }
        public string Notes { get; set; }
        public bool ReviewLeft { get; set; }
        public string PaymentMethod { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal AmountPaid { get; set; }
        public List<BasketItem> Items { get; set; } = new List<BasketItem>();
    }

    [Serializable]
    public class Users
    {
        public int UserID { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string Township { get; set; }
        public string Role { get; set; }
    }
}
