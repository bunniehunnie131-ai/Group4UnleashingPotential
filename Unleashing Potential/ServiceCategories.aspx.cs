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
    public partial class WebForm6 : System.Web.UI.Page
    {
        private string ConnStr =>
            ConfigurationManager.ConnectionStrings["ProjectDB"].ConnectionString;

        private int CurrentUserID => Convert.ToInt32(Session["UserID"] ?? 0);

        private string CustomerDisplayName =>
            Session["FullName"]?.ToString()
            ?? Session["UserName"]?.ToString()
            ?? "Customer";

        private string CustomerLookupKey =>
            Session["UserEmail"]?.ToString()
            ?? CustomerDisplayName;

        private List<Booking> _customerBookings;

        private List<Booking> CustomerBookings
        {
            get { return _customerBookings ?? (_customerBookings = LoadCustomerBookings()); }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null || CurrentUserID == 0)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadHeader();
                LoadSummary();
                BindRecentBookings();
            }

            UpdateBasketCount();
        }

        private void LoadHeader()
        {
            lblUserName.Text = HttpUtility.HtmlEncode(CustomerDisplayName);
            litTownship.Text = "Township not set";
            litJoined.Text = "recently";

            if (CurrentUserID <= 0)
                return;

            try
            {
                using (SqlConnection conn = new SqlConnection(ConnStr))
                {
                    string sql = @"SELECT FullName, Township, DateCreated
                                   FROM Users
                                   WHERE UserID = @UID";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.Add("@UID", SqlDbType.Int).Value = CurrentUserID;

                    conn.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (!rdr.Read())
                            return;

                        lblUserName.Text = HttpUtility.HtmlEncode(
                            rdr["FullName"]?.ToString() ?? CustomerDisplayName);

                        string township = rdr["Township"] == DBNull.Value
                            ? ""
                            : rdr["Township"].ToString();

                        if (!string.IsNullOrWhiteSpace(township))
                            litTownship.Text = HttpUtility.HtmlEncode(township);

                        if (rdr["DateCreated"] != DBNull.Value)
                            litJoined.Text = Convert.ToDateTime(rdr["DateCreated"]).ToString("MMMM yyyy");
                    }
                }
            }
            catch
            {
               .
            }
        }

        private void LoadSummary()
        {
            List<Booking> bookings = CustomerBookings;

            litTotalBookings.Text = bookings.Count.ToString();
            litPendingBookings.Text = bookings.Count(b => IsStatus(b.Status, "Pending")).ToString();
            litActiveBookings.Text = bookings.Count(b => IsStatus(b.Status, "Confirmed")).ToString();

            decimal spent = bookings
                .Where(b => IsStatus(b.Status, "Completed"))
                .Sum(b => b.TotalAmount);

            litTotalSpent.Text = spent.ToString("N2");
        }

        private void BindRecentBookings()
        {
            List<Booking> recentBookings = CustomerBookings.Take(3).ToList();

            rptRecentBookings.Visible = recentBookings.Count > 0;
            pnlNoBookings.Visible = recentBookings.Count == 0;
            rptRecentBookings.DataSource = recentBookings;
            rptRecentBookings.DataBind();
        }

        private List<Booking> LoadCustomerBookings()
        {
            try
            {
                return BookingDB.GetBookingsByCustomer(CustomerLookupKey) ?? new List<Booking>();
            }
            catch
            {
                return new List<Booking>();
            }
        }

        private void UpdateBasketCount()
        {
            var basket = Session["Basket"] as List<BasketItem>;
            lblBasketCount.Text = basket != null ? basket.Count.ToString() : "0";
        }

        private bool IsStatus(string status, string target)
        {
            return string.Equals(NormalizeStatus(status), target, StringComparison.OrdinalIgnoreCase);
        }

        private string NormalizeStatus(string status)
        {
            if (string.IsNullOrWhiteSpace(status))
                return "Pending";

            if (status.Equals("Complete", StringComparison.OrdinalIgnoreCase))
                return "Completed";

            if (status.Equals("Accepted", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";

            if (status.Equals("InProcess", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";

            if (status.Equals("In Progress", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";

            if (status.Equals("AppointmentDay", StringComparison.OrdinalIgnoreCase))
                return "Confirmed";

            return status.Trim();
        }

        protected string GetStatusBadge(object dataItem)
        {
            var booking = dataItem as Booking;
            if (booking == null)
                return string.Empty;

            string status = NormalizeStatus(booking.Status);
            string css = status.Replace(" ", "").ToLowerInvariant();

            return string.Format(
                "<span class='status-badge status-{0}'>{1}</span>",
                css,
                HttpUtility.HtmlEncode(status));
        }

        protected string GetBookingTags(object dataItem)
        {
            var booking = dataItem as Booking;
            if (booking?.Items == null || booking.Items.Count == 0)
                return string.Empty;

            var tags = new StringBuilder();

            foreach (BasketItem item in booking.Items.Take(2))
            {
                tags.Append("<span class='booking-pill'>");
                tags.Append(HttpUtility.HtmlEncode(item.ProviderName));
                tags.Append(" &middot; ");
                tags.Append(HttpUtility.HtmlEncode(item.Service));
                tags.Append("</span>");
            }

            if (booking.Items.Count > 2)
            {
                tags.Append("<span class='booking-pill more'>+");
                tags.Append(booking.Items.Count - 2);
                tags.Append(" more</span>");
            }

            return tags.ToString();
        }

        protected string GetReviewAction(object dataItem)
        {
            var booking = dataItem as Booking;
            if (booking == null)
                return string.Empty;

            if (IsStatus(booking.Status, "Completed") && !booking.ReviewLeft)
            {
                return string.Format(
                    "<a href='LeaveReview.aspx?ref={0}' class='btn-inline alt'>Leave a Review</a>",
                    HttpUtility.UrlEncode(booking.ReferenceNumber));
            }

            if (IsStatus(booking.Status, "Completed") && booking.ReviewLeft)
                return "<span class='booking-pill more'>Reviewed</span>";

            return string.Empty;
        }
    }
}
