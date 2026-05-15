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

            NormalizeBasket(basket);
            Session["Basket"] = basket;

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

            NormalizeBasket(basket);
            Session["Basket"] = basket;

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

            RefreshStepState(e.NextStepIndex, basket);
        }

        protected void wzCheckout_ActiveStepChanged(object sender, EventArgs e)
        {
            var basket = Session["Basket"] as List<BasketItem>;
            if (basket == null) return;

            NormalizeBasket(basket);
            Session["Basket"] = basket;
            RefreshStepState(wzCheckout.ActiveStepIndex, basket);
        }

        protected void wzCheckout_FinishButtonClick(object sender, WizardNavigationEventArgs e)
        {
            var basket = Session["Basket"] as List<BasketItem>;
            if (basket == null) return;

            NormalizeBasket(basket);
            Session["Basket"] = basket;

            Page.Validate("Step1");
            if (!Page.IsValid ||
                calAppointment.SelectedDate == DateTime.MinValue ||
                calAppointment.SelectedDate < DateTime.Today)
            {
                lblCheckoutError.Text = "Please complete the booking details and select a valid appointment date before confirming.";
                pnlCheckoutError.Visible = true;
                e.Cancel = true;
                return;
            }

            decimal total = basket.Sum(b => b.LineTotal);
            string paymentMethod = string.IsNullOrWhiteSpace(rblPayment.SelectedValue)
                ? "PayOnCompletion"
                : rblPayment.SelectedValue;
            string amtType = string.IsNullOrWhiteSpace(rblAmount.SelectedValue)
                ? "Deposit"
                : rblAmount.SelectedValue;
            decimal amtPaid = amtType == "Full" ? total : total * 0.5m;

            var booking = new Booking
            {
                Items = new List<BasketItem>(basket),
                BookingStatusID = 1,
                BookingDate = DateTime.Now,
                AppointmentDate = calAppointment.SelectedDate,
                Notes = txtNotes.Text.Trim(),
                PaymentMethod = paymentMethod
            };

            try
            {
                string refNumber = BookingDB.SaveBooking(booking);

                Session["LastBookingName"] = txtName.Text.Trim();
                Session["LastBookingPhone"] = txtPhone.Text.Trim();
                Session["LastBookingAddress"] = txtAddress.Text.Trim();
                Session["LastBookingPayment"] = paymentMethod;
                Session["LastBookingTotal"] = total;
                Session["LastBookingAmtPaid"] = amtPaid;
                Session["LastBookingRef"] = refNumber;
                Session["Basket"] = null;

                BookingDB.WriteAuditLog(
                    Session["UserName"] != null ? Session["UserName"].ToString() : null,
                    "BOOKING_CREATED",
                    "Booking " + refNumber + " created. Amount paid: R" + amtPaid.ToString("0.00"));

                Response.Redirect("~/BookingConfirmation.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            catch (Exception ex)
            {
                BookingDB.WriteAuditLog(
                    Session["UserName"] != null ? Session["UserName"].ToString() : null,
                    "BOOKING_CREATE_FAILED",
                    ex.Message);

                lblCheckoutError.Text = "Your booking could not be saved right now. " + ex.Message;
                pnlCheckoutError.Visible = true;
                e.Cancel = true;
            }
        }

        private void RefreshStepState(int stepIndex, List<BasketItem> basket)
        {
            if (basket == null) return;

            decimal total = basket.Sum(b => b.LineTotal);

            if (stepIndex == 1)
            {
                lblDepositAmt.Text = (total * 0.5m).ToString("0.00");
                lblFullAmt.Text = total.ToString("0.00");

                if (string.IsNullOrWhiteSpace(rblPayment.SelectedValue))
                    rblPayment.SelectedValue = "PayOnCompletion";

                if (string.IsNullOrWhiteSpace(rblAmount.SelectedValue))
                    rblAmount.SelectedValue = "Deposit";

                pnlCheckoutError.Visible = false;
            }
            else if (stepIndex == 2)
            {
                string amtType = rblAmount.SelectedValue ?? "Deposit";
                decimal payNow = amtType == "Full" ? total : total * 0.5m;
                string selectedDate = calAppointment.SelectedDate == DateTime.MinValue
                    ? string.Empty
                    : calAppointment.SelectedDate.ToString("dd MMMM yyyy");

                lblConfirmDetails.Text =
                    "<strong>Name:</strong> " + txtName.Text + "<br/>" +
                    "<strong>Phone:</strong> " + txtPhone.Text + "<br/>" +
                    "<strong>Address:</strong> " + txtAddress.Text + "<br/>" +
                    "<strong>Date:</strong> " + selectedDate + "<br/>" +
                    "<strong>Payment:</strong> " + (rblPayment.SelectedValue ?? "PayOnCompletion");

                rptConfirmItems.DataSource = basket;
                rptConfirmItems.DataBind();
                lblConfirmTotal.Text = total.ToString("0.00");
                lblConfirmPayNow.Text = payNow.ToString("0.00");
                pnlCheckoutError.Visible = false;
            }
        }

        private static void NormalizeBasket(List<BasketItem> basket)
        {
            if (basket == null) return;

            foreach (var item in basket)
            {
                if (item != null)
                    item.Quantity = 1;
            }
        }
    }
}
