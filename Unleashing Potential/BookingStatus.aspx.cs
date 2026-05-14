using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm11 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null) { Response.Redirect("~/Login.aspx"); return; }
            if (!IsPostBack) LoadBookings();
        }

        private void LoadBookings()
        {
            string userName = Session["UserName"].ToString();
            var bookings = BookingDB.GetBookingsByCustomer(userName);

            if (bookings.Count == 0)
            {
                pnlEmpty.Visible = true;
                rptBookings.Visible = false;
                return;
            }

            pnlEmpty.Visible = false;
            rptBookings.Visible = true;
            rptBookings.DataSource = bookings;
            rptBookings.DataBind();
        }

        protected string GetStatusBadge(string status)
        {
            if (string.IsNullOrWhiteSpace(status)) status = "Pending";
            status = Normalize(status);
            string css = "status-" + status.Replace(" ", "");
            string icon = status == "Pending" ? "⏳" :
                          status == "Confirmed" ? "✅" :
                          status == "Completed" ? "🎉" :
                          status == "Cancelled" ? "✖" : "❓";
            return $"<span class='status-badge {css}'>{icon} {status}</span>";
        }

        protected string GetTimeline(string currentStatus)
        {
            currentStatus = Normalize(currentStatus);
            var stages = new[] { "Pending", "Confirmed", "Completed", "Cancelled" };
            int idx = Array.IndexOf(stages, currentStatus);
            if (idx < 0) idx = 0;
            var sb = new StringBuilder("<div class='timeline'>");

            for (int i = 0; i < stages.Length; i++)
            {
                string circleClass = i < idx ? "done" : i == idx ? "active" : "";
                string labelClass = i < idx ? "done" : i == idx ? "active" : "";
                string icon = i < idx ? "✓" : i == idx ? "●" : (i + 1).ToString();

                sb.Append("<div class='tl-step'>");
                sb.Append($"<div class='tl-circle {circleClass}'>{icon}</div>");
                sb.Append($"<div class='tl-label {labelClass}'>{stages[i]}</div>");
                sb.Append("</div>");

                if (i < stages.Length - 1)
                    sb.Append($"<div class='tl-line {(i < idx ? "done" : "")}'></div>");
            }

            sb.Append("</div>");
            return sb.ToString();
        }

        protected string GetServiceTags(object dataItem)
        {
            var booking = dataItem as Booking;
            if (booking?.Items == null) return "";
            var sb = new StringBuilder();
            foreach (var item in booking.Items)
                sb.Append($"<span class='service-tag'>{item.ProviderName} — {item.Service}</span>");
            return sb.ToString();
        }

        protected string GetReviewButton(object dataItem)
        {
            var booking = dataItem as Booking;
            if (booking == null) return "";
            if (Normalize(booking.Status) == "Completed" && !booking.ReviewLeft)
                return $"<a href='LeaveReview.aspx?ref={booking.ReferenceNumber}' class='btn-review'>⭐ Leave a Review</a>";
            if (Normalize(booking.Status) == "Completed" && booking.ReviewLeft)
                return "<span style='font-size:0.84rem;color:#166534;font-weight:600;'>✅ Review submitted</span>";
            return "";
        }

        private string Normalize(string status)
        {
            if (string.IsNullOrWhiteSpace(status)) return "Pending";
            if (status.Equals("Complete", StringComparison.OrdinalIgnoreCase)) return "Completed";
            if (status.Equals("Accepted", StringComparison.OrdinalIgnoreCase)) return "Confirmed";
            if (status.Equals("InProcess", StringComparison.OrdinalIgnoreCase)) return "Confirmed";
            if (status.Equals("In Progress", StringComparison.OrdinalIgnoreCase)) return "Confirmed";
            if (status.Equals("AppointmentDay", StringComparison.OrdinalIgnoreCase)) return "Confirmed";
            return status;
        }
    }
}
