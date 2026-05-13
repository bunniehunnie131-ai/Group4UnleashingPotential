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
                "INSERT INTO AuditLogs (AdminName, Action, Description, LogDate) " +
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
                    lblTotalBookings.Text = new SqlCommand(
                        "SELECT COUNT(*) FROM Bookings", conn)
                        .ExecuteScalar().ToString();

                    // Revenue from completed bookings
                    object rev = new SqlCommand(
                        "SELECT ISNULL(SUM(Amount),0) FROM Bookings WHERE Status='Complete'", conn)
                        .ExecuteScalar();
                    lblRevenue.Text = Convert.ToDecimal(rev).ToString("N2");

                    // Active providers
                    lblActiveProviders.Text = new SqlCommand(
                        "SELECT COUNT(*) FROM ServiceProviders WHERE Status='Active' OR Status='Verified'", conn)
                        .ExecuteScalar().ToString();

                    // Completion rate
                    int total = Convert.ToInt32(new SqlCommand(
                        "SELECT COUNT(*) FROM Bookings", conn).ExecuteScalar());
                    int completed = Convert.ToInt32(new SqlCommand(
                        "SELECT COUNT(*) FROM Bookings WHERE Status='Complete'", conn).ExecuteScalar());

                    lblCompletionRate.Text = total > 0
                        ? ((completed * 100) / total).ToString()
                        : "0";
                }

                // Recent 10 bookings
                DataTable dt = FillTable(
                    "SELECT TOP 10 b.BookingID, " +
                    "u.FullName AS ClientName, " +
                    "c.CategoryName AS ServiceName, " +
                    "sp.FullName AS ProviderName, " +
                    "b.BookingDate, b.Status " +
                    "FROM Bookings b " +
                    "JOIN Users u ON b.UserID = u.UserID " +
                    "JOIN Categories c ON b.CategoryID = c.CategoryID " +
                    "JOIN ServiceProviders sp ON b.ProviderID = sp.ProviderID " +
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
                "SELECT ProviderID, FullName, Category, Township, DateCreated " +
                "FROM ServiceProviders WHERE Status = 'Pending' ORDER BY DateCreated DESC");

            DataTable active = FillTable(
                "SELECT ProviderID, FullName, Category, Township " +
                "FROM ServiceProviders WHERE Status = 'Active'");

            DataTable verified = FillTable(
                "SELECT ProviderID, FullName, Category, Township " +
                "FROM ServiceProviders WHERE Status = 'Verified'");

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
                        "UPDATE ServiceProviders SET Status = @Status WHERE ProviderID = @ID", conn);
                    cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 20).Value = newStatus;
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
                "SELECT b.BookingID, " +
                "u.FullName AS ClientName, " +
                "c.CategoryName AS ServiceName, " +
                "sp.FullName AS ProviderName, " +
                "b.BookingDate, b.Status " +
                "FROM Bookings b " +
                "JOIN Users u ON b.UserID = u.UserID " +
                "JOIN Categories c ON b.CategoryID = c.CategoryID " +
                "JOIN ServiceProviders sp ON b.ProviderID = sp.ProviderID " +
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
                Button btn = r.FindControl("") as Button;
                if (r.Cells[0].Text == bookingID.ToString()) { row = r; break; }
            }

            // Locate the row by iterating
            foreach (GridViewRow r in gvBookings.Rows)
            {
                DropDownList ddl = r.FindControl("ddlStatus") as DropDownList;
                Button updateBtn = null;
                foreach (Control ctrl in r.Controls)
                    foreach (Control inner in ctrl.Controls)
                        if (inner is Button b && b.CommandName == "UpdateStatus"
                            && b.CommandArgument == bookingID.ToString())
                        { row = r; break; }

                if (row != null)
                {
                    DropDownList statusDdl = row.FindControl("ddlStatus") as DropDownList;
                    if (statusDdl == null) break;

                    string newStatus = statusDdl.SelectedValue;

                    try
                    {
                        using (SqlConnection conn = new SqlConnection(ConnStr))
                        {
                            conn.Open();
                            SqlCommand cmd = new SqlCommand(
                                "UPDATE Bookings SET Status = @Status WHERE BookingID = @ID", conn);
                            cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 20).Value = newStatus;
                            cmd.Parameters.Add("@ID", SqlDbType.Int).Value = bookingID;
                            cmd.ExecuteNonQuery();
                        }

                        WriteAuditLog("BOOKING_UPDATED",
                            $"Booking {bookingID} status set to {newStatus}");

                        ShowMessage("Booking status updated.");
                        LoadBookings();
                    }
                    catch (SqlException ex)
                    {
                        ShowMessage("Error: " + ex.Message, false);
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

                try
                {
                    using (SqlConnection conn = new SqlConnection(ConnStr))
                    {
                        conn.Open();
                        SqlCommand cmd = new SqlCommand(
                            "UPDATE Users SET Password = @PW WHERE UserID = @ID", conn);
                        cmd.Parameters.Add("@PW", SqlDbType.NVarChar, 256).Value = tempPassword;
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
                "SELECT c.CategoryID, c.CategoryName, c.Description, " +
                "COUNT(sp.ProviderID) AS ProviderCount " +
                "FROM Categories c " +
                "LEFT JOIN ServiceProviders sp ON c.CategoryName = sp.Category " +
                "GROUP BY c.CategoryID, c.CategoryName, c.Description " +
                "ORDER BY c.CategoryName");

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
                        "INSERT INTO Categories (CategoryName, Description) " +
                        "VALUES (@Name, @Desc)", conn);
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
                        "DELETE FROM Categories WHERE CategoryID = @ID", conn);
                    cmd.Parameters.Add("@ID", SqlDbType.Int).Value = categoryID;
                    cmd.ExecuteNonQuery();
                }

                WriteAuditLog("CATEGORY_DELETED", $"Category ID {categoryID} deleted");
                ShowMessage("Category deleted.");
                LoadCategories();
            }
            catch (SqlException ex)
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
                "SELECT c.CategoryName AS Category, " +
                "COUNT(*) AS TotalBookings, " +
                "SUM(CASE WHEN b.Status='Complete' THEN 1 ELSE 0 END) AS Completed, " +
                "SUM(CASE WHEN b.Status='Cancelled' THEN 1 ELSE 0 END) AS Cancelled, " +
                "ISNULL(SUM(b.Amount),0) AS Revenue " +
                "FROM Bookings b " +
                "JOIN Categories c ON b.CategoryID = c.CategoryID " +
                "GROUP BY c.CategoryName ORDER BY TotalBookings DESC");

            WriteAuditLog("REPORT_GENERATED", "Bookings report generated");
            gvReport.DataSource = dt;
            gvReport.Visible = true;
            gvReport.DataBind();
        }

        protected void btnRptProviders_Click(object sender, EventArgs e)
        {
            DataTable dt = FillTable(
                "SELECT sp.FullName AS Provider, sp.Category, sp.Township, sp.Status, " +
                "COUNT(b.BookingID) AS TotalJobs, " +
                "SUM(CASE WHEN b.Status='Complete' THEN 1 ELSE 0 END) AS Completed " +
                "FROM ServiceProviders sp " +
                "LEFT JOIN Bookings b ON sp.ProviderID = b.ProviderID " +
                "GROUP BY sp.FullName, sp.Category, sp.Township, sp.Status " +
                "ORDER BY Completed DESC");

            WriteAuditLog("REPORT_GENERATED", "Provider report generated");
            gvReport.DataSource = dt;
            gvReport.Visible = true;
            gvReport.DataBind();
        }

        protected void btnRptRevenue_Click(object sender, EventArgs e)
        {
            DataTable dt = FillTable(
                "SELECT YEAR(BookingDate) AS Year, MONTH(BookingDate) AS Month, " +
                "c.CategoryName AS Category, " +
                "COUNT(*) AS Bookings, " +
                "ISNULL(SUM(Amount),0) AS Revenue " +
                "FROM Bookings b " +
                "JOIN Categories c ON b.CategoryID = c.CategoryID " +
                "WHERE Status = 'Complete' " +
                "GROUP BY YEAR(BookingDate), MONTH(BookingDate), c.CategoryName " +
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
                "SELECT TOP 100 LogDate, AdminName, Action, Description " +
                "FROM AuditLogs ORDER BY LogDate DESC");

            gvAudit.DataSource = dt;
            gvAudit.DataBind();
        }
    }
}