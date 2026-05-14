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
            bool showCustomerLinks = ShouldShowCustomerLinks();

            // Guest items (Register, Login) - shown when NOT logged in
            liRegister.Visible = !isLoggedIn;
            liLogin.Visible = !isLoggedIn;

            // Customer-only items stay off admin/provider surfaces.
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

        private bool ShouldShowCustomerLinks()
        {
            if (Session["UserID"] == null)
                return false;

            string role = Session["Role"]?.ToString();

            if (IsAdminRole(role) || IsProviderRole(role))
                return false;

            if (!IsCustomerNavigationPage())
                return false;

            // Legacy sessions created before Role was stored still get the
            // customer links on customer-facing pages, but never on admin/provider pages.
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
