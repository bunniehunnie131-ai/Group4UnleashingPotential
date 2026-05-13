using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm7 : System.Web.UI.Page
    {
        // Class-level field so every method in this page can read it
        private int _providerID;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserName"] == null) { Response.Redirect("~/Login.aspx"); return; }

            if (!int.TryParse(Request.QueryString["id"], out _providerID))
            {
                Response.Redirect("~/ServiceCategories.aspx");
                return;
            }

            if (!IsPostBack) LoadProfile();
            UpdateBasketCount();
        }

        private void LoadProfile()
        {
            var p = BookingDB.GetProviderByID(_providerID);
            if (p == null) { Response.Redirect("~/ServiceCategories.aspx"); return; }

            lblInitials.Text = GetInitials(p.Name);
            lblName.Text = p.Name;
            lblSpecialty.Text = p.Specialty;
            lblStars.Text = GetStars((int)Math.Round(p.Rating));
            lblRating.Text = p.Rating.ToString("0.0");
            lblReviewCount.Text = p.ReviewCount.ToString();
            lblDescription.Text = p.Description;
            lblLocation.Text = p.Location;
            lblPhone.Text = p.Phone;
            lblExperience.Text = p.YearsExperience + " years";
            lblCategory.Text = p.Category;
            lblPrice.Text = p.Price.ToString("0");
            lblPriceUnit.Text = p.PriceUnit;

            var reviews = BookingDB.GetReviewsByProvider(_providerID);
            if (reviews.Count > 0)
            {
                rptReviews.DataSource = reviews;
                rptReviews.DataBind();
                pnlNoReviews.Visible = false;
            }
            else
            {
                pnlNoReviews.Visible = true;
            }
        }

        protected void btnAddToBasket_Click(object sender, EventArgs e)
        {
            int.TryParse(Request.QueryString["id"], out _providerID);

            var p = BookingDB.GetProviderByID(_providerID);
            if (p == null) return;

            var basket = Session["Basket"] as List<BasketItem> ?? new List<BasketItem>();
            var existing = basket.Find(b => b.ProviderID == _providerID);

            if (existing != null)
            {
                existing.Quantity++;
            }
            else
            {
                basket.Add(new BasketItem
                {
                    ProviderID = p.ProviderID,
                    ProviderName = p.Name,
                    Service = p.Specialty,
                    Category = p.Category,
                    Price = p.Price,
                    PriceUnit = p.PriceUnit,
                    Quantity = 1
                });
            }

            Session["Basket"] = basket;
            lblMessage.Text = p.Name + " added to your basket!";
            pnlMessage.Visible = true;

            BookingDB.WriteAuditLog(
                Session["UserName"].ToString(),
                "ADD_TO_BASKET",
                "Added " + p.Name + " to basket from profile page.");

            UpdateBasketCount();
            LoadProfile();
        }

        private void UpdateBasketCount()
        {
            var basket = Session["Basket"] as List<BasketItem>;
            lblBasketCount.Text = basket != null ? basket.Count.ToString() : "0";
        }

        protected string GetStars(int rating)
            => new string('★', rating) + new string('☆', 5 - rating);

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