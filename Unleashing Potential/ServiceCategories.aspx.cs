using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm6 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            lblUserName.Text = Session["UserName"].ToString();

            var basket = Session["Basket"] as List<BasketItem>;
            lblBasketCount.Text = basket != null ? basket.Count.ToString() : "0";
        }
    }
}