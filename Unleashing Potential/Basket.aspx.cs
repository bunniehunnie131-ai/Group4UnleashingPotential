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
            else if (e.CommandName == "Update")
            {
                var txtQty = e.Item.FindControl("txtQty") as TextBox;
                if (txtQty == null) return;

                int newQty;
                if (!int.TryParse(txtQty.Text, out newQty) || newQty < 1) newQty = 1;

                var item = basket.Find(b => b.ProviderID == providerID);
                if (item != null) item.Quantity = newQty;
            }

            Session["Basket"] = basket;
            BindBasket();
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Checkout.aspx");
        }
    }
}