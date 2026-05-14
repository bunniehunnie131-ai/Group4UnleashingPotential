using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
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
            int ordinal = reader.GetOrdinal(columnName);
            return reader.IsDBNull(ordinal) ? string.Empty : reader.GetString(ordinal);
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
                        "UPDATE Bookings SET ReviewLeft = 1 " +
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
            string refNumber = GenerateReference();
            SqlTransaction tx = null;

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    tx = conn.BeginTransaction();

                    string insertBooking =
                        "INSERT INTO Bookings (ReferenceNumber, PaymentMethod, TotalAmount, " +
                        "AmountPaid, Status, BookingDate, AppointmentDate, CustomerName, " +
                        "CustomerPhone, CustomerAddress, Notes, ReviewLeft) " +
                        "VALUES (@Ref, @PayMethod, @Total, @AmtPaid, @Status, @BookDate, " +
                        "@AppDate, @CustName, @CustPhone, @CustAddr, @Notes, 0); " +
                        "SELECT SCOPE_IDENTITY();";

                    var cmd = new SqlCommand(insertBooking, conn);
                    cmd.Transaction = tx;

                    cmd.Parameters.Add("@Ref", SqlDbType.NVarChar, 20).Value = refNumber;
                    cmd.Parameters.Add("@PayMethod", SqlDbType.NVarChar, 50).Value = booking.PaymentMethod;
                    cmd.Parameters.Add("@Total", SqlDbType.Decimal).Value = booking.TotalAmount;
                    cmd.Parameters.Add("@AmtPaid", SqlDbType.Decimal).Value = booking.AmountPaid;
                    cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 30).Value = "Pending";
                    cmd.Parameters.Add("@BookDate", SqlDbType.DateTime).Value = DateTime.Now;
                    cmd.Parameters.Add("@AppDate", SqlDbType.Date).Value = booking.AppointmentDate;
                    cmd.Parameters.Add("@CustName", SqlDbType.NVarChar, 100).Value = booking.CustomerName;
                    cmd.Parameters.Add("@CustPhone", SqlDbType.NVarChar, 20).Value = booking.CustomerPhone;
                    cmd.Parameters.Add("@CustAddr", SqlDbType.NVarChar, 200).Value = booking.CustomerAddress;
                    cmd.Parameters.Add("@Notes", SqlDbType.NVarChar, 500).Value =
                        string.IsNullOrEmpty(booking.Notes) ? (object)DBNull.Value : booking.Notes;

                    int newBookingID = Convert.ToInt32(cmd.ExecuteScalar());

                    foreach (var item in booking.Items)
                    {
                        var itemCmd = new SqlCommand(
                            "INSERT INTO BookingItems (BookingID, ProviderID, ProviderName, " +
                            "Service, Category, Price, PriceUnit, Quantity) " +
                            "VALUES (@BookingID, @ProviderID, @ProviderName, " +
                            "@Service, @Category, @Price, @PriceUnit, @Quantity)", conn);
                        itemCmd.Transaction = tx;

                        itemCmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = newBookingID;
                        itemCmd.Parameters.Add("@ProviderID", SqlDbType.Int).Value = item.ProviderID;
                        itemCmd.Parameters.Add("@ProviderName", SqlDbType.NVarChar, 100).Value = item.ProviderName;
                        itemCmd.Parameters.Add("@Service", SqlDbType.NVarChar, 100).Value = item.Service;
                        itemCmd.Parameters.Add("@Category", SqlDbType.NVarChar, 50).Value = item.Category;
                        itemCmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = item.Price;
                        itemCmd.Parameters.Add("@PriceUnit", SqlDbType.NVarChar, 50).Value = item.PriceUnit;
                        itemCmd.Parameters.Add("@Quantity", SqlDbType.Int).Value = item.Quantity;
                        itemCmd.ExecuteNonQuery();
                    }

                    tx.Commit();
                }
            }
            catch (SqlException ex)
            {
                if (tx != null) try { tx.Rollback(); } catch { }
                WriteAuditLog(booking.CustomerName, "DB_ERROR", ex.Message);
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
                        "SELECT * FROM Bookings WHERE ReferenceNumber = @Ref", conn);
                    cmd.Parameters.Add("@Ref", SqlDbType.NVarChar, 20).Value = referenceNumber;

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                            booking = MapBooking(reader);
                    }

                    if (booking == null) return null;

                    booking.Items = GetBookingItems(booking.BookingID, conn);
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
                        "SELECT * FROM Bookings WHERE CustomerName = @CustomerName " +
                        "ORDER BY BookingDate DESC", conn);
                    cmd.Parameters.Add("@CustomerName", SqlDbType.NVarChar, 100).Value = customerName;

                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                            list.Add(MapBooking(reader));
                    }

                    foreach (var b in list)
                        b.Items = GetBookingItems(b.BookingID, conn);
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
                "SELECT * FROM BookingItems WHERE BookingID = @BookingID", conn);
            cmd.Parameters.Add("@BookingID", SqlDbType.Int).Value = bookingID;

            using (var reader = cmd.ExecuteReader())
            {
                while (reader.Read())
                {
                    items.Add(new BasketItem
                    {
                        ProviderID = reader.GetInt32(reader.GetOrdinal("ProviderID")),
                        ProviderName = reader.GetString(reader.GetOrdinal("ProviderName")),
                        Service = reader.GetString(reader.GetOrdinal("Service")),
                        Category = reader.GetString(reader.GetOrdinal("Category")),
                        Price = reader.GetDecimal(reader.GetOrdinal("Price")),
                        PriceUnit = reader.GetString(reader.GetOrdinal("PriceUnit")),
                        Quantity = reader.GetInt32(reader.GetOrdinal("Quantity"))
                    });
                }
            }
            return items;
        }

        private static Booking MapBooking(SqlDataReader reader)
        {
            int notesCol = reader.GetOrdinal("Notes");
            return new Booking
            {
                BookingID = reader.GetInt32(reader.GetOrdinal("BookingID")),
                ReferenceNumber = reader.GetString(reader.GetOrdinal("ReferenceNumber")),
                PaymentMethod = reader.GetString(reader.GetOrdinal("PaymentMethod")),
                TotalAmount = reader.GetDecimal(reader.GetOrdinal("TotalAmount")),
                AmountPaid = reader.GetDecimal(reader.GetOrdinal("AmountPaid")),
                Status = reader.GetString(reader.GetOrdinal("Status")),
                BookingDate = reader.GetDateTime(reader.GetOrdinal("BookingDate")),
                AppointmentDate = reader.GetDateTime(reader.GetOrdinal("AppointmentDate")),
                CustomerName = reader.GetString(reader.GetOrdinal("CustomerName")),
                CustomerPhone = reader.GetString(reader.GetOrdinal("CustomerPhone")),
                CustomerAddress = reader.GetString(reader.GetOrdinal("CustomerAddress")),
                Notes = reader.IsDBNull(notesCol) ? "" : reader.GetString(notesCol),
                ReviewLeft = reader.GetBoolean(reader.GetOrdinal("ReviewLeft"))
            };
        }

        private static readonly Random _rng = new Random();
        public static string GenerateReference()
            => "UP-" + DateTime.Now.Year + "-" + _rng.Next(1000, 9999);
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
    public class Booking
    {
        public int BookingID { get; set; }
        public string ReferenceNumber { get; set; }
        public string PaymentMethod { get; set; }
        public decimal TotalAmount { get; set; }
        public decimal AmountPaid { get; set; }
        public string Status { get; set; }
        public DateTime BookingDate { get; set; }
        public DateTime AppointmentDate { get; set; }
        public string CustomerName { get; set; }
        public string CustomerPhone { get; set; }
        public string CustomerAddress { get; set; }
        public string Notes { get; set; }
        public bool ReviewLeft { get; set; }
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
