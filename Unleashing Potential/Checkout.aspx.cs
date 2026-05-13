using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm9 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null) { Response.Redirect("~/Login.aspx"); return; }

            var basket = Session["Basket"] as List<BasketItem>;
            if (basket == null || basket.Count == 0)
            {
                Response.Redirect("~/Basket.aspx");
                return;
            }

            if (!IsPostBack)
                txtName.Text = Session["UserName"].ToString();
        }

        protected void calAppointment_DayRender(object sender, DayRenderEventArgs e)
        {
            if (e.Day.Date < DateTime.Today)
            {
                e.Day.IsSelectable = false;
                e.Cell.ForeColor = System.Drawing.Color.LightGray;
            }
        }

        protected void wzCheckout_NextButtonClick(object sender, WizardNavigationEventArgs e)
        {
            var basket = Session["Basket"] as List<BasketItem>;
            if (basket == null) return;

            // Validate Step 1 — appointment date
            if (e.CurrentStepIndex == 0)
            {
                if (calAppointment.SelectedDate == DateTime.MinValue ||
                    calAppointment.SelectedDate < DateTime.Today)
                {
                    lblDateError.Visible = true;
                    e.Cancel = true;
                    return;
                }
                lblDateError.Visible = false;
            }

            // Set amounts on Step 2
            if (e.NextStepIndex == 1)
            {
                decimal total = basket.Sum(b => b.LineTotal);
                lblDepositAmt.Text = (total * 0.5m).ToString("0.00");
                lblFullAmt.Text = total.ToString("0.00");
                rblPayment.SelectedValue = "PayOnCompletion";
                rblAmount.SelectedValue = "Deposit";
            }

            // Populate confirm step
            if (e.NextStepIndex == 2)
            {
                decimal total = basket.Sum(b => b.LineTotal);
                string amtType = rblAmount.SelectedValue ?? "Deposit";
                decimal payNow = amtType == "Full" ? total : total * 0.5m;

                lblConfirmDetails.Text =
                    "<strong>Name:</strong> " + txtName.Text + "<br/>" +
                    "<strong>Phone:</strong> " + txtPhone.Text + "<br/>" +
                    "<strong>Address:</strong> " + txtAddress.Text + "<br/>" +
                    "<strong>Date:</strong> " + calAppointment.SelectedDate.ToString("dd MMMM yyyy") + "<br/>" +
                    "<strong>Payment:</strong> " + (rblPayment.SelectedValue ?? "PayOnCompletion");

                rptConfirmItems.DataSource = basket;
                rptConfirmItems.DataBind();
                lblConfirmTotal.Text = total.ToString("0.00");
                lblConfirmPayNow.Text = payNow.ToString("0.00");
            }
        }

        protected void wzCheckout_FinishButtonClick(object sender, WizardNavigationEventArgs e)
        {
            var basket = Session["Basket"] as List<BasketItem>;
            if (basket == null) return;

            decimal total = basket.Sum(b => b.LineTotal);
            string amtType = rblAmount.SelectedValue ?? "Deposit";
            decimal amtPaid = amtType == "Full" ? total : total * 0.5m;

            var booking = new Booking
            {
                Items = new List<BasketItem>(basket),
                PaymentMethod = rblPayment.SelectedValue ?? "PayOnCompletion",
                TotalAmount = total,
                AmountPaid = amtPaid,
                Status = "Pending",
                BookingDate = DateTime.Now,
                AppointmentDate = calAppointment.SelectedDate,
                CustomerName = txtName.Text.Trim(),
                CustomerPhone = txtPhone.Text.Trim(),
                CustomerAddress = txtAddress.Text.Trim(),
                Notes = txtNotes.Text.Trim()
            };

            try
            {
                string refNumber = BookingDB.SaveBooking(booking);

                BookingDB.WriteAuditLog(
                    booking.CustomerName,
                    "BOOKING_CREATED",
                    "Booking " + refNumber + " created. Amount paid: R" + amtPaid.ToString("0.00"));

                Session["LastBookingRef"] = refNumber;
                Session["Basket"] = null;

                Response.Redirect("~/BookingConfirmation.aspx");
            }
            catch (Exception)
            {
                // Show a friendly error — technical details are in AuditLogs
                lblDateError.Text = "Your booking could not be saved. Please try again.";
                lblDateError.Visible = true;
                e.Cancel = true;
            }
        }
    }
}