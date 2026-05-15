using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class SiteMaster : MasterPage
    {
        private static readonly HashSet<string> CustomerNavigationPages = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "~/ServiceCategories.aspx",
            "~/ServiceProviders.aspx",
            "~/Basket.aspx",
            "~/BookingStatus.aspx",
            "~/Checkout.aspx",
            "~/BookingConfirmation.aspx",
            "~/LeaveReview.aspx",
            "~/MemberDashboard.aspx",
            "~/Promo.aspx",
            "~/ProviderProfile.aspx"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            bool isLoggedIn = Session["UserID"] != null;
            string role = Session["Role"]?.ToString();
            bool showCustomerLinks = ShouldShowCustomerLinks();

            
            liRegister.Visible = !isLoggedIn;
            liLogin.Visible = !isLoggedIn;
            liServices.Visible = !IsProviderRole(role);

            
            liPromo.Visible = showCustomerLinks;
            liBrowseServices.Visible = showCustomerLinks;
            liBasket.Visible = showCustomerLinks;
            liGreeting.Visible = isLoggedIn;
            liLogout.Visible = isLoggedIn;

            if (isLoggedIn)
            {
                lblNavName.Text = Session["FullName"]?.ToString()
                    ?? Session["UserName"]?.ToString()
                    ?? Session["FirstName"]?.ToString()
                    ?? "User";
            }
        }

        protected string GetHomeUrl()
        {
            string role = Session["Role"]?.ToString();

            if (IsAdminRole(role))
                return "~/Admin.aspx";

            if (IsProviderRole(role))
                return "~/ServiceProviderDashboard.aspx";

            return "~/Default.aspx";
        }

        private bool ShouldShowCustomerLinks()
        {
            if (Session["UserID"] == null)
                return false;

            string role = Session["Role"]?.ToString();

            if (IsAdminRole(role) || IsProviderRole(role))
                return false;

            if (!IsCustomerNavigationPage())
                return false;

            
            if (string.IsNullOrWhiteSpace(role))
                return true;

            return IsCustomerRole(role);
        }

        private bool IsCustomerNavigationPage()
        {
            string pagePath = Page.AppRelativeVirtualPath ?? Request.AppRelativeCurrentExecutionFilePath;
            return !string.IsNullOrWhiteSpace(pagePath) && CustomerNavigationPages.Contains(pagePath);
        }

        private bool IsAdminRole(string role)
        {
            return string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase);
        }

        private bool IsProviderRole(string role)
        {
            return string.Equals(role, "ServiceProvider", StringComparison.OrdinalIgnoreCase)
                || string.Equals(role, "Provider", StringComparison.OrdinalIgnoreCase);
        }

        private bool IsCustomerRole(string role)
        {
            return string.Equals(role, "Customer", StringComparison.OrdinalIgnoreCase);
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }
    }
}
