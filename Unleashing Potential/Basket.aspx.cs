using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm8 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null) { Response.Redirect("~/Login.aspx"); return; }
            if (!IsPostBack) BindBasket();
        }

        private void BindBasket()
        {
            var basket = Session["Basket"] as List<BasketItem>;

            if (basket == null || basket.Count == 0)
            {
                pnlEmpty.Visible = true;
                pnlBasket.Visible = false;
                return;
            }

            NormalizeBasket(basket);
            basket.RemoveAll(item => item == null || BookingDB.GetProviderByID(item.ProviderID) == null);
            Session["Basket"] = basket;

            if (basket.Count == 0)
            {
                pnlEmpty.Visible = true;
                pnlBasket.Visible = false;
                return;
            }

            pnlEmpty.Visible = false;
            pnlBasket.Visible = true;

            rptBasket.DataSource = basket;
            rptBasket.DataBind();
            rptSummary.DataSource = basket;
            rptSummary.DataBind();

            decimal total = basket.Sum(b => b.LineTotal);
            lblTotal.Text = total.ToString("0.00");
        }

        protected void rptBasket_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            var basket = Session["Basket"] as List<BasketItem>;
            if (basket == null) return;

            int providerID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Remove")
            {
                basket.RemoveAll(b => b.ProviderID == providerID);
            }

            Session["Basket"] = basket;
            BindBasket();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Checkout.aspx");
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
