using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm5 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null) { Response.Redirect("~/Login.aspx"); return; }

            if (!IsPostBack)
            {
                string category = Request.QueryString["category"] ?? "Hairdressing";
                string lookupCategory = BookingDB.ResolveProviderCategory(category);
                if (string.IsNullOrWhiteSpace(lookupCategory))
                    lookupCategory = "Hairdressing";

                lblCategory.Text = category;
                lblCategoryIcon.Text = GetCategoryIcon(lookupCategory);

                var providers = BookingDB.GetProvidersByCategory(lookupCategory);
                rptProviders.DataSource = providers;
                rptProviders.DataBind();
            }

            UpdateBasketCount();
        }

        protected void rptProviders_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "AddToBasket") return;

            int providerID = Convert.ToInt32(e.CommandArgument);
            var provider = BookingDB.GetProviderByID(providerID);
            if (provider == null) return;

            var service = BookingDB.GetActiveServiceForCategory(provider.Category);
            var basket = Session["Basket"] as List<BasketItem> ?? new List<BasketItem>();
            var existing = basket.Find(b => b.ProviderID == providerID);
            bool alreadyInBasket = existing != null;

            if (existing != null)
            {
                existing.ServiceID = service != null ? (int?)service.ServiceID : existing.ServiceID;
                existing.ProviderName = provider.Name;
                existing.Service = provider.Specialty;
                existing.Category = provider.Category;
                existing.Price = provider.Price;
                existing.PriceUnit = provider.PriceUnit;
                existing.Quantity = 1;
            }
            else
                basket.Add(new BasketItem
                {
                    ServiceID = service != null ? (int?)service.ServiceID : null,
                    ProviderID = provider.ProviderID,
                    ProviderName = provider.Name,
                    Service = provider.Specialty,
                    Category = provider.Category,
                    Price = provider.Price,
                    PriceUnit = provider.PriceUnit,
                    Quantity = 1
                });

            Session["Basket"] = basket;
            lblMessage.Text = alreadyInBasket
                ? provider.Name + " is already in your basket."
                : provider.Name + " has been added to your basket.";
            pnlMessage.Visible = true;

            BookingDB.WriteAuditLog(
                Session["UserName"].ToString(),
                "ADD_TO_BASKET",
                "Added provider " + provider.Name + " to basket.");

            string category = BookingDB.ResolveProviderCategory(Request.QueryString["category"] ?? "Hairdressing");
            if (string.IsNullOrWhiteSpace(category))
                category = "Hairdressing";

            rptProviders.DataSource = BookingDB.GetProvidersByCategory(category);
            rptProviders.DataBind();
            UpdateBasketCount();
        }

        private void UpdateBasketCount()
        {
            var basket = Session["Basket"] as List<BasketItem>;
            lblBasketCount.Text = basket != null ? basket.Count.ToString() : "0";
        }

        protected string GetStars(double rating)
        {
            int full = (int)Math.Floor(rating);
            return new string('★', full) + new string('☆', 5 - full);
        }

        protected string GetInitials(string name)
        {
            if (string.IsNullOrEmpty(name)) return "?";
            var parts = name.Split(' ');
            return parts.Length >= 2
                ? parts[0][0].ToString() + parts[1][0].ToString()
                : parts[0][0].ToString();
        }

        private string GetCategoryIcon(string category)
        {
            switch (category)
            {
                case "Hairdressing": return "💇‍♀️";
                case "Tailoring": return "🧵";
                case "Plumbing": return "🔧";
                case "Painting": return "🎨";
                default: return "🛠️";
            }
        }
    }
}
