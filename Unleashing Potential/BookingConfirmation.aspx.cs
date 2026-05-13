using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm10 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null) { Response.Redirect("~/Login.aspx"); return; }

            string refNum = Session["LastBookingRef"] as string;
            if (string.IsNullOrEmpty(refNum))
            {
                Response.Redirect("~/ServiceCategories.aspx");
                return;
            }

            var booking = BookingDB.GetBookingByReference(refNum);
            if (booking == null)
            {
                Response.Redirect("~/ServiceCategories.aspx");
                return;
            }

            lblRef.Text = booking.ReferenceNumber;
            lblName.Text = booking.CustomerName;
            lblPhone.Text = booking.CustomerPhone;
            lblAddress.Text = booking.CustomerAddress;
            lblDate.Text = booking.AppointmentDate.ToString("dd MMMM yyyy");
            lblPayment.Text = booking.PaymentMethod == "EFT"
                              ? "EFT Proof Upload" : "Pay on Completion";
            lblAmtPaid.Text = booking.AmountPaid.ToString("0.00");
            lblTotal.Text = booking.TotalAmount.ToString("0.00");

            rptItems.DataSource = booking.Items;
            rptItems.DataBind();
        }
    }
}