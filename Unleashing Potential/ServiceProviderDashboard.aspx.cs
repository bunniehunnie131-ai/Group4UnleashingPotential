using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class ServiceProviderDashboard : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["ProjectDB"].ConnectionString;

        private int CurrentUserID => Convert.ToInt32(Session["UserID"] ?? 0);

        // Cached provider ID for the logged-in user
        private int ProviderID
        {
            get { return Convert.ToInt32(hfProviderID.Value); }
            set { hfProviderID.Value = value.ToString(); }
        }

        // ══════════════════════════════════════════════════════════════════════
        // PAGE LOAD
        // ══════════════════════════════════════════════════════════════════════
        protected void Page_Load(object sender, EventArgs e)
        {
            // Auth guard
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }
            string role = Session["Role"]?.ToString() ?? "";
            if (role != "ServiceProvider" && role != "Provider")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                int pid = GetProviderID();
                if (pid == 0)
                {
                    // Provider profile not yet created – redirect to register page
                    Response.Redirect("~/RegisterServiceProvider.aspx");
                    return;
                }
                ProviderID = pid;

                LoadHeader();
                LoadKPIs();
                LoadBookings(null);
                LoadEarnings();
                LoadCompletedJobs();
                LoadReviews();
                LoadProfileForm();
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        // LOOKUP PROVIDER ID for this user
        // ══════════════════════════════════════════════════════════════════════
        private int GetProviderID()
        {
            string sql = "SELECT ProviderID FROM ServiceProviders WHERE UserID = @UID";
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UID", CurrentUserID);
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? Convert.ToInt32(result) : 0;
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        // HEADER
        // ══════════════════════════════════════════════════════════════════════
        private void LoadHeader()
        {
            string sql = @"SELECT sp.Name, sp.Category, sp.Location, sp.Price, sp.PriceUnit,
                                  sp.Rating, u.IsActive
                           FROM ServiceProviders sp
                           INNER JOIN Users u ON sp.UserID = u.UserID
                           WHERE sp.ProviderID = @PID";
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@PID", ProviderID);
                conn.Open();
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        litProvName.Text = rdr["Name"].ToString();
                        litCategory.Text = rdr["Category"].ToString();
                        litLocation.Text = rdr["Location"].ToString();
                        litPrice.Text = string.Format("{0:N2}", rdr["Price"]);
                        litPriceUnit.Text = rdr["PriceUnit"].ToString();
                        bool isActive = !rdr.IsDBNull(rdr.GetOrdinal("IsActive")) && rdr.GetBoolean(rdr.GetOrdinal("IsActive"));
                        lblApprovalStatus.Text = isActive ? "Active" : "Inactive";
                        lblApprovalStatus.CssClass = "status-pill " + (isActive ? "approved" : "pending");
                    }
                }
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        // KPI CARDS
        // ══════════════════════════════════════════════════════════════════════
        private void LoadKPIs()
        {
            string sql = @"SELECT
                              COUNT(*)                                          AS Total,
                              ISNULL(SUM(CASE WHEN ISNULL(bs.Name, 'Pending') IN ('Pending','Confirmed') THEN 1 ELSE 0 END), 0) AS Active,
                              ISNULL(SUM(CASE WHEN ISNULL(bs.Name, '') = 'Completed'
                                               THEN CAST(ISNULL(bi.UnitPrice, 0) * ISNULL(bi.Quantity, 1) AS DECIMAL(18,2))
                                               ELSE 0 END),0) AS Earnings
                           FROM BookingItem bi
                           INNER JOIN Booking b ON bi.BookingID = b.BookingID
                           LEFT JOIN BookingStatus bs ON b.BookingStatusID = bs.BookingStatusID
                           WHERE bi.ProviderID = @PID";
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@PID", ProviderID);
                    conn.Open();
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        litTotalJobs.Text = rdr["Total"].ToString();
                        litActiveJobs.Text = rdr["Active"].ToString();
                            litEarnings.Text = string.Format("{0:N2}", rdr["Earnings"]);
                        }
                    }
                }
                // Rating
                string rSql = "SELECT ISNULL(AVG(CAST(Rating AS DECIMAL(3,1))),0) FROM Reviews WHERE ProviderID=@PID";
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(rSql, conn);
                    cmd.Parameters.AddWithValue("@PID", ProviderID);
                    conn.Open();
                    litRating.Text = string.Format("{0:N1}", cmd.ExecuteScalar());
                }
            }
            catch { }
        }

        // ══════════════════════════════════════════════════════════════════════
        // BOOKINGS GRID
        // ══════════════════════════════════════════════════════════════════════
        private void LoadBookings(string statusFilter)
        {
            string sql = @"SELECT b.BookingID, b.ReferenceNumber,
                                  ISNULL(u.FullName, '') AS CustomerName,
                                  ISNULL(u.Phone, '') AS CustomerPhone,
                                  b.AppointmentDate,
                                  ISNULL(s.Name, sp.Specialty) AS Service,
                                  CAST(ISNULL(bi.UnitPrice, 0) * ISNULL(bi.Quantity, 1) AS DECIMAL(18,2)) AS Price,
                                  ISNULL(bs.Name, 'Pending') AS Status
                           FROM BookingItem bi
                           INNER JOIN Booking b ON bi.BookingID = b.BookingID
                           LEFT JOIN Users u ON b.CustomerID = u.UserID
                           LEFT JOIN ServiceProviders sp ON bi.ProviderID = sp.ProviderID
                           LEFT JOIN Service s ON bi.ServiceID = s.ServiceID
                           LEFT JOIN BookingStatus bs ON b.BookingStatusID = bs.BookingStatusID
                           WHERE bi.ProviderID = @PID"
                         + (string.IsNullOrEmpty(statusFilter) ? "" : " AND ISNULL(bs.Name, 'Pending') = @Status")
                         + " ORDER BY b.AppointmentDate ASC, b.BookingDate DESC, bi.ItemID ASC";
            try
            {
                DataTable dt = FillTable(sql, cmd =>
                {
                    cmd.Parameters.AddWithValue("@PID", ProviderID);
                    if (!string.IsNullOrEmpty(statusFilter))
                        cmd.Parameters.AddWithValue("@Status", statusFilter);
                });
                gvBookings.DataSource = dt;
                gvBookings.DataBind();
            }
            catch { }
        }

        protected void ddlFilter_Changed(object sender, EventArgs e)
        {
            LoadBookings(ddlFilter.SelectedValue);
        }

        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string newStatus = "";
            int bookingId = 0;
            string cmdArg = e.CommandArgument?.ToString() ?? "";

            if (!int.TryParse(cmdArg, out bookingId))
                return;

            if (e.CommandName == "Confirm") newStatus = "Confirmed";
            else if (e.CommandName == "Complete") newStatus = "Completed";
            else if (e.CommandName == "Cancel") newStatus = "Cancelled";

            if (bookingId > 0 && !string.IsNullOrEmpty(newStatus))
                UpdateBookingStatus(bookingId, newStatus);
        }

        private int? ResolveBookingStatusId(string statusName)
        {
            if (string.IsNullOrWhiteSpace(statusName))
                return null;

            string normalized = statusName.Trim();
            if (normalized.Equals("Accepted", StringComparison.OrdinalIgnoreCase) ||
                normalized.Equals("In Progress", StringComparison.OrdinalIgnoreCase) ||
                normalized.Equals("InProcess", StringComparison.OrdinalIgnoreCase) ||
                normalized.Equals("AppointmentDay", StringComparison.OrdinalIgnoreCase))
            {
                normalized = "Confirmed";
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string sql = "SELECT TOP 1 BookingStatusID FROM BookingStatus WHERE LOWER(Name) = LOWER(@Status)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 100).Value = normalized;
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result == null || result == DBNull.Value ? (int?)null : Convert.ToInt32(result);
            }
        }

        private void UpdateBookingStatus(int bookingId, string newStatus)
        {
            int? statusId = ResolveBookingStatusId(newStatus);
            if (!statusId.HasValue)
            {
                ShowMsg(lblMsg, "Unknown booking status: " + newStatus, false);
                return;
            }

            string sql = "UPDATE Booking SET BookingStatusID=@StatusID WHERE BookingID=@BID";
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@StatusID", statusId.Value);
                    cmd.Parameters.AddWithValue("@BID", bookingId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMsg(lblMsg, $"Booking #{bookingId} updated to '{newStatus}'.", true);
                LoadKPIs();
                LoadBookings(ddlFilter.SelectedValue);
                LoadEarnings();
                LoadCompletedJobs();
            }
            catch (Exception ex)
            {
                ShowMsg(lblMsg, "Error updating status: " + ex.Message, false);
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        // EARNINGS TAB
        // ══════════════════════════════════════════════════════════════════════
        private void LoadEarnings()
        {
            string sql = @"SELECT
                ISNULL(SUM(CASE WHEN MONTH(b.AppointmentDate)=MONTH(GETDATE()) AND YEAR(b.AppointmentDate)=YEAR(GETDATE()) AND ISNULL(bs.Name, '')='Completed'
                                THEN CAST(ISNULL(bi.UnitPrice, 0) * ISNULL(bi.Quantity, 1) AS DECIMAL(18,2)) ELSE 0 END),0) AS EarnMonth,
                ISNULL(SUM(CASE WHEN YEAR(b.AppointmentDate)=YEAR(GETDATE()) AND ISNULL(bs.Name, '')='Completed'
                                THEN CAST(ISNULL(bi.UnitPrice, 0) * ISNULL(bi.Quantity, 1) AS DECIMAL(18,2)) ELSE 0 END),0) AS EarnYear,
                ISNULL(SUM(CASE WHEN MONTH(b.AppointmentDate)=MONTH(GETDATE()) AND YEAR(b.AppointmentDate)=YEAR(GETDATE()) AND ISNULL(bs.Name, '')='Completed' THEN 1 ELSE 0 END),0) AS JobsMonth,
                ISNULL(SUM(CASE WHEN ISNULL(bs.Name, '')='Completed' THEN 1 ELSE 0 END),0) AS JobsTotal
                           FROM BookingItem bi
                           INNER JOIN Booking b ON bi.BookingID=b.BookingID
                           LEFT JOIN BookingStatus bs ON b.BookingStatusID = bs.BookingStatusID
                           WHERE bi.ProviderID=@PID";
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@PID", ProviderID);
                    conn.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.Read())
                        {
                            litEarnMonth.Text = string.Format("{0:N2}", rdr["EarnMonth"]);
                            litEarnYear.Text = string.Format("{0:N2}", rdr["EarnYear"]);
                            litJobsMonth.Text = rdr["JobsMonth"].ToString();
                            litJobsTotal.Text = rdr["JobsTotal"].ToString();
                        }
                    }
                }
            }
            catch { }
        }

        private void LoadCompletedJobs()
        {
            string sql = @"SELECT b.ReferenceNumber,
                                  ISNULL(u.FullName, '') AS CustomerName,
                                  b.AppointmentDate,
                                  ISNULL(s.Name, sp.Specialty) AS Service,
                                  CAST(ISNULL(bi.UnitPrice, 0) * ISNULL(bi.Quantity, 1) AS DECIMAL(18,2)) AS Price
                           FROM BookingItem bi
                           INNER JOIN Booking b ON bi.BookingID=b.BookingID
                           LEFT JOIN Users u ON b.CustomerID = u.UserID
                           LEFT JOIN ServiceProviders sp ON bi.ProviderID = sp.ProviderID
                           LEFT JOIN Service s ON bi.ServiceID = s.ServiceID
                           LEFT JOIN BookingStatus bs ON b.BookingStatusID = bs.BookingStatusID
                           WHERE bi.ProviderID=@PID AND ISNULL(bs.Name, '')='Completed'
                           ORDER BY b.AppointmentDate DESC, b.BookingDate DESC, bi.ItemID DESC";
            try
            {
                DataTable dt = FillTable(sql, cmd => cmd.Parameters.AddWithValue("@PID", ProviderID));
                gvCompleted.DataSource = dt;
                gvCompleted.DataBind();
            }
            catch { }
        }

        // ══════════════════════════════════════════════════════════════════════
        // REVIEWS TAB
        // ══════════════════════════════════════════════════════════════════════
        private void LoadReviews()
        {
            string sql = @"SELECT ReviewerName, Rating, Comment, ReviewDate
                           FROM Reviews WHERE ProviderID=@PID
                           ORDER BY ReviewDate DESC";
            try
            {
                DataTable dt = FillTable(sql, cmd => cmd.Parameters.AddWithValue("@PID", ProviderID));
                if (dt.Rows.Count > 0)
                {
                    rptReviews.DataSource = dt;
                    rptReviews.DataBind();
                    lblNoReviews.Style["display"] = "none";
                }
                else
                {
                    lblNoReviews.Style["display"] = "block";
                }
            }
            catch { }
        }

        // ══════════════════════════════════════════════════════════════════════
        // PROFILE TAB – load + save
        // ══════════════════════════════════════════════════════════════════════
        private void LoadProfileForm()
        {
            string sql = @"SELECT Name, Category, Specialty, Price, PriceUnit,
                                  Location, Phone, YearsExperience, Description
                           FROM ServiceProviders WHERE ProviderID=@PID";
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@PID", ProviderID);
                conn.Open();
                using (SqlDataReader rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read())
                    {
                        txtName.Text = rdr["Name"].ToString();
                        txtSpecialty.Text = rdr["Specialty"].ToString();
                        txtPrice.Text = rdr["Price"].ToString();
                        txtLocation.Text = rdr["Location"].ToString();
                        txtPhone.Text = rdr["Phone"].ToString();
                        txtYears.Text = rdr["YearsExperience"].ToString();
                        txtDescription.Text = rdr["Description"].ToString();

                        // Set dropdownlists
                        SetDropdown(ddlCategory, rdr["Category"].ToString());
                        SetDropdown(ddlPriceUnit, rdr["PriceUnit"].ToString());
                    }
                }
            }
        }

        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string sql = @"UPDATE ServiceProviders
                           SET Name=@Name, Category=@Cat, Specialty=@Spec,
                               Price=@Price, PriceUnit=@PUnit,
                               Location=@Loc, Phone=@Phone,
                               YearsExperience=@Years, Description=@Desc
                           WHERE ProviderID=@PID";
            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Cat", ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@Spec", txtSpecialty.Text.Trim());
                    cmd.Parameters.AddWithValue("@Price", decimal.Parse(txtPrice.Text));
                    cmd.Parameters.AddWithValue("@PUnit", ddlPriceUnit.SelectedValue);
                    cmd.Parameters.AddWithValue("@Loc", txtLocation.Text.Trim());
                    cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@Years", int.Parse(txtYears.Text));
                    cmd.Parameters.AddWithValue("@Desc", txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@PID", ProviderID);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ShowMsg(lblProfileMsg, "Profile saved successfully.", true);
                LoadHeader(); // Refresh header with new name/category
            }
            catch (Exception ex)
            {
                ShowMsg(lblProfileMsg, "Error: " + ex.Message, false);
            }
        }

        // ══════════════════════════════════════════════════════════════════════
        // HELPERS
        // ══════════════════════════════════════════════════════════════════════
        private DataTable FillTable(string sql, Action<SqlCommand> addParams)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                SqlCommand cmd = new SqlCommand(sql, conn);
                addParams?.Invoke(cmd);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                da.Fill(dt);
            }
            return dt;
        }

        private void ShowMsg(System.Web.UI.WebControls.Label lbl, string text, bool success)
        {
            lbl.Text = text;
            lbl.CssClass = "msg show " + (success ? "success" : "error");
        }

        private void SetDropdown(DropDownList ddl, string value)
        {
            ListItem item = ddl.Items.FindByText(value);
            if (item == null) item = ddl.Items.FindByValue(value);
            if (item != null) ddl.SelectedValue = item.Value;
        }
    }
}
