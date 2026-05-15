using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRequestService_Click(object sender, EventArgs e)
        {
            var button = sender as Button;
            string category = GetCategoryFromButton(button != null ? button.ID : string.Empty);

            if (string.IsNullOrWhiteSpace(category))
                category = "Hairdressing";

            Response.Redirect("~/ServiceProviders.aspx?category=" + HttpUtility.UrlEncode(category));
        }

        private string GetCategoryFromButton(string buttonId)
        {
            switch (buttonId)
            {
                case "btnHairdressing":
                    return "Hairdressing";
                case "btnTailoring":
                    return "Tailoring";
                case "btnPlumbing":
                    return "Plumbing";
                case "btnPainting":
                    return "Painting";
                default:
                    return string.Empty;
            }
        }
    }
}
