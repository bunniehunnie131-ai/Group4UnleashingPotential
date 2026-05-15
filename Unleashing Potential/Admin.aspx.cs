using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm4 : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["ProjectDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Only admins may access this page
            if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadDashboard();
                LoadApprovals();
                LoadBookings();
                LoadUsers();
                LoadCategories();
                LoadAuditLog();
            }
        }

        // ════════════════════════════════════════════
        // HELPERS
        // ════════════════════════════════════════════
        private void ShowMessage(string text, bool success = true)
        {
            lblAdminMsg.Text = text;
            lblAdminMsg.CssClass = "admin-msg show " + (success ? "success" : "error");
        }

        private void WriteAuditLog(string action, string description)
        {
            string sql =
                "INSERT INTO AuditLogs (UserName, Action, Description, LogDate) " +
                "VALUES (@Admin, @Action, @Desc, @Date)";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.Add("@Admin", SqlDbType.NVarChar, 100).Value =
                        Session["FullName"]?.ToString() ?? "Admin";
                    cmd.Parameters.Add("@Action", SqlDbType.NVarChar, 50).Value = action;
                    cmd.Parameters.Add("@Desc", SqlDbType.NVarChar, 500).Value = description;
                    cmd.Parameters.Add("@Date", SqlDbType.DateTime).Value = DateTime.Now;
                    cmd.ExecuteNonQuery();
                }
            }
            catch { /* Never let logging break the main flow */ }
        }

        private DataTable FillTable(string sql, Action<SqlCommand> addParams = null)
        {
            DataTable dt = new DataTable();
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    addParams?.Invoke(cmd);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    da.Fill(dt);
                }
            }
            catch (SqlException ex)
            {
                ShowMessage("Database error: " + ex.Message, false);
            }
            return dt;
        }

        // ════════════════════════════════════════════
        // DASHBOARD KPIs
        // ════════════════════════════════════════════
        private void LoadDashboard()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // Total bookings
                    int totalBookings = Convert.ToInt32(new SqlCommand(
                        "SELECT COUNT(*) FROM Booking", conn)
                        .ExecuteScalar());

                    // Revenue from completed bookings
                    decimal completedRevenue = Convert.ToDecimal(new SqlCommand(
                        "SELECT ISNULL(SUM(CASE WHEN b.BookingStatusID = 3 " +
                        "THEN CAST(ISNULL(bi.UnitPrice, 0) * ISNULL(bi.Quantity, 1) AS DECIMAL(18,2)) " +
                        "ELSE 0 END), 0) " +
                        "FROM Booking b " +
                        "LEFT JOIN BookingItem bi ON bi.BookingID = b.BookingID", conn)
                        .ExecuteScalar());
                    lblRevenue.Text = completedRevenue.ToString("N2");

                    // Active providers
                    lblActiveProviders.Text = new SqlCommand(
                        "SELECT COUNT(*) " +
                        "FROM ServiceProviders sp " +
                        "INNER JOIN Users u ON sp.UserID = u.UserID " +
                        "WHERE u.IsActive = 1", conn)
                        .ExecuteScalar().ToString();

                    // Completion rate
                    int completed = Convert.ToInt32(new SqlCommand(
                        "SELECT COUNT(*) FROM Booking WHERE BookingStatusID = 3", conn).ExecuteScalar());

                    lblCompletionRate.Text = totalBookings > 0
                        ? Math.Round((completed * 100m) / totalBookings, 1).ToString("0.#")
                        : "0";

                    lblTotalBookings.Text = totalBookings.ToString();
                }

                // Recent 10 bookings
                DataTable dt = FillTable(
                    "SELECT TOP 10 b.BookingID, b.ReferenceNumber, b.CustomerID, b.LocationID, " +
                    "b.BookingStatusID, b.BookingDate, b.AppointmentDate, b.Notes, b.ReviewLeft " +
                    "FROM Booking b " +
                    "ORDER BY b.BookingDate DESC");

                gvRecentBookings.DataSource = dt;
                gvRecentBookings.DataBind();
            }
            catch (SqlException ex)
            {
                ShowMessage("Could not load dashboard: " + ex.Message, false);
            }
        }

        // ════════════════════════════════════════════
        // APPROVALS — KANBAN
        // ════════════════════════════════════════════
        private void LoadApprovals()
        {
            DataTable pending = FillTable(
                "SELECT sp.ProviderID, sp.Name AS FullName, sp.Category, sp.Location AS Township, u.DateCreated " +
                "FROM ServiceProviders sp " +
                "INNER JOIN Users u ON sp.UserID = u.UserID " +
                "WHERE u.IsActive = 0 " +
                "ORDER BY u.DateCreated DESC");

            DataTable active = FillTable(
                "SELECT sp.ProviderID, sp.Name AS FullName, sp.Category, sp.Location AS Township " +
                "FROM ServiceProviders sp " +
                "INNER JOIN Users u ON sp.UserID = u.UserID " +
                "WHERE u.IsActive = 1 AND ISNULL(sp.Rating, 0) < 4 " +
                "ORDER BY sp.Name");

            DataTable verified = FillTable(
                "SELECT sp.ProviderID, sp.Name AS FullName, sp.Category, sp.Location AS Township " +
                "FROM ServiceProviders sp " +
                "INNER JOIN Users u ON sp.UserID = u.UserID " +
                "WHERE u.IsActive = 1 AND ISNULL(sp.Rating, 0) >= 4 " +
                "ORDER BY sp.Name");

            rptPending.DataSource = pending; rptPending.DataBind();
            rptActive.DataSource = active; rptActive.DataBind();
            rptVerified.DataSource = verified; rptVerified.DataBind();

            lblPendingCount.Text = pending.Rows.Count.ToString();
            lblActiveCount.Text = active.Rows.Count.ToString();
            lblVerifiedCount.Text = verified.Rows.Count.ToString();
            lblPendingBadge.Text = pending.Rows.Count.ToString();
            lblPendingBadge.Visible = pending.Rows.Count > 0;
        }

        protected void ProviderAction_Command(object sender, CommandEventArgs e)
        {
            int providerID = Convert.ToInt32(e.CommandArgument);
            string newStatus = e.CommandName == "Approve" ? "Active" : "Rejected";

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(
                        "UPDATE u SET IsActive = @Active " +
                        "FROM Users u INNER JOIN ServiceProviders sp ON sp.UserID = u.UserID " +
                        "WHERE sp.ProviderID = @ID", conn);
                    cmd.Parameters.Add("@Active", SqlDbType.Bit).Value = newStatus == "Active";
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = providerID;
                    cmd.ExecuteNonQuery();
                }

                WriteAuditLog(e.CommandName == "Approve" ? "PROVIDER_APPROVED" : "PROVIDER_REJECTED",
                    $"Provider ID {providerID} set to {newStatus}");

                ShowMessage($"Provider {newStatus.ToLower()} successfully.");
                LoadApprovals();
            }
            catch (SqlException ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        // ════════════════════════════════════════════
        // BOOKINGS
        // ════════════════════════════════════════════
        private void LoadBookings()
        {
            DataTable dt = FillTable(
                "SELECT b.BookingID, b.ReferenceNumber, b.CustomerID, b.LocationID, " +
                "b.BookingStatusID, b.BookingDate, b.AppointmentDate, b.Notes, b.ReviewLeft " +
                "FROM Booking b " +
                "ORDER BY b.BookingDate DESC");

            gvBookings.DataSource = dt;
            gvBookings.DataBind();
        }

        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "UpdateStatus") return;

            int bookingID = Convert.ToInt32(e.CommandArgument);

            // Find the row and its dropdown
            GridViewRow row = null;
            foreach (GridViewRow r in gvBookings.Rows)
            {
                if (r.Cells[0].Text == bookingID.ToString()) { row = r; break; }
            }

            // Locate the row by iterating
            foreach (GridViewRow r in gvBookings.Rows)
            {
                foreach (Control ctrl in r.Controls)
                    foreach (Control inner in ctrl.Controls)
                        if (inner is Button b && b.CommandName == "UpdateStatus"
                            && b.CommandArgument == bookingID.ToString())
                        { row = r; break; }

                if (row != null)
                {
                    DropDownList statusDdl = row.FindControl("ddlStatus") as DropDownList;
                    if (statusDdl == null) break;

                    int newStatusId = Convert.ToInt32(statusDdl.SelectedValue);

                    try
                    {
                        using (SqlConnection conn = new SqlConnection(ConnStr))
                        {
                            conn.Open();
                            SqlCommand cmd = new SqlCommand(
                                "UPDATE Booking SET BookingStatusID = @StatusID WHERE BookingID = @ID", conn);
                            cmd.Parameters.Add("@StatusID", SqlDbType.Int).Value = newStatusId;
                            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = bookingID;
                            cmd.ExecuteNonQuery();
                        }

                    WriteAuditLog("BOOKING_UPDATED",
                            $"Booking {bookingID} status set to {newStatusId}");

                        ShowMessage("Booking status updated.");
                        LoadBookings();
                    }
                    catch (SqlException)
                    {
                        ShowMessage("Error updating booking status.", false);
                    }
                    break;
                }
            }
        }

        // ════════════════════════════════════════════
        // USER ACCOUNTS
        // ════════════════════════════════════════════
        private void LoadUsers()
        {
            DataTable dt = FillTable(
                "SELECT UserID, FullName, Email, Phone, DateCreated, IsActive " +
                "FROM Users ORDER BY DateCreated DESC");

            gvUsers.DataSource = dt;
            gvUsers.DataBind();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int userID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ToggleUser")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();

                        // Read current state
                        SqlCommand readCmd = new SqlCommand(
                            "SELECT IsActive FROM Users WHERE UserID = @ID", conn);
                        readCmd.Parameters.Add("@ID", SqlDbType.Int).Value = userID;
                        bool isActive = Convert.ToBoolean(readCmd.ExecuteScalar());

                        // Toggle
                        SqlCommand updCmd = new SqlCommand(
                            "UPDATE Users SET IsActive = @Active WHERE UserID = @ID", conn);
                        updCmd.Parameters.Add("@Active", SqlDbType.Bit).Value = !isActive;
                        updCmd.Parameters.Add("@ID", SqlDbType.Int).Value = userID;
                        updCmd.ExecuteNonQuery();

                        WriteAuditLog(isActive ? "USER_DEACTIVATED" : "USER_ACTIVATED",
                            $"User ID {userID} set to {(!isActive ? "active" : "inactive")}");

                        ShowMessage($"User account {(!isActive ? "activated" : "deactivated")}.");
                    }

                    LoadUsers();
                }
                catch (SqlException ex)
                {
                    ShowMessage("Error: " + ex.Message, false);
                }
            }
            else if (e.CommandName == "ResetPW")
            {
                // Set a temporary password — in production this would email the user
                string tempPassword = "Temp@" + DateTime.Now.ToString("ddMM");
                string tempPasswordHash = BookingDB.HashPassword(tempPassword);

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();
                        SqlCommand cmd = new SqlCommand(
                            "UPDATE Users SET PasswordHash = @PW WHERE UserID = @ID", conn);
                        cmd.Parameters.Add("@PW", SqlDbType.NVarChar, 256).Value = tempPasswordHash;
                        cmd.Parameters.Add("@ID", SqlDbType.Int).Value = userID;
                        cmd.ExecuteNonQuery();
                    }

                    WriteAuditLog("PASSWORD_RESET",
                        $"Temporary password set for User ID {userID}");

                    ShowMessage($"Password reset. Temporary password: {tempPassword}");
                }
                catch (SqlException ex)
                {
                    ShowMessage("Error: " + ex.Message, false);
                }
            }
        }

        // ════════════════════════════════════════════
        // SERVICE CATEGORIES
        // ════════════════════════════════════════════
        private void LoadCategories()
        {
            DataTable dt = FillTable(
                "SELECT c.CategoryID, c.Name AS CategoryName, c.Description, c.IsActive, " +
                "COUNT(sp.ProviderID) AS ProviderCount " +
                "FROM Category c " +
                "LEFT JOIN ServiceProviders sp ON c.Name = sp.Category " +
                "WHERE c.IsActive = 1 " +
                "GROUP BY c.CategoryID, c.Name, c.Description, c.IsActive " +
                "ORDER BY c.Name");

            gvCategories.DataSource = dt;
            gvCategories.DataBind();
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            string name = txtCatName.Text.Trim();
            string desc = txtCatDesc.Text.Trim();

            if (string.IsNullOrWhiteSpace(name))
            {
                ShowMessage("Please enter a category name.", false);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(
                        "INSERT INTO Category (Name, Description, IsActive, DateCreated) " +
                        "VALUES (@Name, @Desc, 1, GETDATE())", conn);
                    cmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = name;
                    cmd.Parameters.Add("@Desc", SqlDbType.NVarChar, 500).Value = desc;
                    cmd.ExecuteNonQuery();
                }

                WriteAuditLog("CATEGORY_ADDED", $"New category added: {name}");
                ShowMessage($"Category '{name}' added successfully.");
                txtCatName.Text = string.Empty;
                txtCatDesc.Text = string.Empty;
                LoadCategories();
            }
            catch (SqlException ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "DeleteCat") return;

            int categoryID = Convert.ToInt32(e.CommandArgument);

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    SqlCommand cmd = new SqlCommand(
                        "DELETE FROM Category WHERE CategoryID = @ID", conn);
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = categoryID;
                    cmd.ExecuteNonQuery();
                }

                WriteAuditLog("CATEGORY_DELETED", $"Category ID {categoryID} deleted");
                ShowMessage("Category deleted.");
                LoadCategories();
            }
            catch (SqlException)
            {
                ShowMessage("Cannot delete — this category may have providers linked to it.", false);
            }
        }

        // ════════════════════════════════════════════
        // REPORTS
        // ════════════════════════════════════════════
        protected void btnRptBookings_Click(object sender, EventArgs e)
        {
            DataTable dt = FillTable(
                "SELECT COUNT(*) AS TotalBookings, " +
                "SUM(CASE WHEN BookingStatusID = 3 THEN 1 ELSE 0 END) AS Completed, " +
                "SUM(CASE WHEN BookingStatusID = 4 THEN 1 ELSE 0 END) AS Cancelled, " +
                "0 AS Revenue " +
                "FROM Booking");

            WriteAuditLog("REPORT_GENERATED", "Bookings report generated");
            gvReport.DataSource = dt;
            gvReport.Visible = true;
            gvReport.DataBind();
        }

        protected void btnRptProviders_Click(object sender, EventArgs e)
        {
            DataTable dt = FillTable(
                "SELECT sp.Name AS Provider, sp.Category, sp.Location AS Township, " +
                "CASE WHEN u.IsActive = 1 AND ISNULL(sp.Rating, 0) >= 4 THEN 'Verified' " +
                "     WHEN u.IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status, " +
                "sp.Rating, sp.ReviewCount, u.DateCreated " +
                "FROM ServiceProviders sp " +
                "INNER JOIN Users u ON sp.UserID = u.UserID " +
                "ORDER BY sp.Rating DESC, sp.ReviewCount DESC, sp.Name");

            WriteAuditLog("REPORT_GENERATED", "Provider report generated");
            gvReport.DataSource = dt;
            gvReport.Visible = true;
            gvReport.DataBind();
        }

        protected void btnRptRevenue_Click(object sender, EventArgs e)
        {
            DataTable dt = FillTable(
                "SELECT YEAR(BookingDate) AS Year, MONTH(BookingDate) AS Month, " +
                "COUNT(*) AS Bookings, " +
                "0 AS Revenue " +
                "FROM Booking " +
                "WHERE BookingStatusID = 3 " +
                "GROUP BY YEAR(BookingDate), MONTH(BookingDate) " +
                "ORDER BY Year DESC, Month DESC");

            WriteAuditLog("REPORT_GENERATED", "Revenue report generated");
            gvReport.DataSource = dt;
            gvReport.Visible = true;
            gvReport.DataBind();
        }

        // ════════════════════════════════════════════
        // AUDIT LOG
        // ════════════════════════════════════════════
        private void LoadAuditLog()
        {
            DataTable dt = FillTable(
                "SELECT TOP 100 LogDate, UserName AS AdminName, Action, Description " +
                "FROM AuditLogs ORDER BY LogDate DESC");

            gvAudit.DataSource = dt;
            gvAudit.DataBind();
        }
    }
}
