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
        protected void Page_Load(object sender, EventArgs e)
        {
            bool isLoggedIn = Session["UserID"] != null;

            // Guest items (Register, Login) - shown when NOT logged in
            liRegister.Visible = !isLoggedIn;
            liLogin.Visible = !isLoggedIn;

            // User items - shown when logged in
            liBrowseServices.Visible = isLoggedIn;
            liBasket.Visible = isLoggedIn;
            liGreeting.Visible = isLoggedIn;
            liLogout.Visible = isLoggedIn;

            if (isLoggedIn)
            {
                lblNavName.Text = Session["FirstName"]?.ToString() ?? "User";
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Default.aspx");
        }
    }
}