using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;

namespace Unleashing_Potential
{
    public partial class WebForm12 : System.Web.UI.Page
    {
        private Booking _booking;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null) { Response.Redirect("~/Login.aspx"); return; }

            string refNum = Request.QueryString["ref"];
            if (string.IsNullOrEmpty(refNum))
            {
                Response.Redirect("~/BookingStatus.aspx");
                return;
            }

            _booking = BookingDB.GetBookingByReference(refNum);

            if (_booking == null || _booking.Status != "Completed")
            {
                Response.Redirect("~/BookingStatus.aspx");
                return;
            }

            if (_booking.ReviewLeft)
            {
                pnlForm.Visible = false;
                pnlSuccess.Visible = true;
                return;
            }

            if (!IsPostBack)
            {
                rptProviderChips.DataSource = _booking.Items;
                rptProviderChips.DataBind();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int rating = Convert.ToInt32(hdnRating.Value);
            if (rating < 1 || rating > 5)
            {
                lblRatingErr.Visible = true;
                return;
            }
            lblRatingErr.Visible = false;

            string refNum = Request.QueryString["ref"];
            _booking = BookingDB.GetBookingByReference(refNum);
            if (_booking == null) return;

            string userName = Session["UserName"].ToString();
            var reviews = new List<Review>();

            foreach (var item in _booking.Items)
            {
                reviews.Add(new Review
                {
                    ProviderID = item.ProviderID,
                    ReviewerName = userName,
                    Rating = rating,
                    Comment = txtComment.Text.Trim()
                });
            }

            try
            {
                BookingDB.AddReviews(reviews, refNum);

                BookingDB.WriteAuditLog(
                    userName,
                    "REVIEW_SUBMITTED",
                    "Review submitted for booking " + refNum +
                    " — Rating: " + rating + "/5");

                pnlForm.Visible = false;
                pnlSuccess.Visible = true;
            }
            catch (Exception)
            {
                lblRatingErr.Text = "Your review could not be saved. Please try again.";
                lblRatingErr.Visible = true;
            }
        }

        protected string GetInitials(string name)
        {
            if (string.IsNullOrEmpty(name)) return "?";
            var parts = name.Split(' ');
            return parts.Length >= 2
                ? parts[0][0].ToString() + parts[1][0].ToString()
                : parts[0][0].ToString();
        }
    }
}