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
            if (Session["UserID"] != null)
            {
                // User is logged in — show the user panel, hide guest links
                pnlUser.Visible = true;
                pnlGuest.Visible = false;

                // Show their first name in the navbar greeting
                if (Session["FullName"] != null)
                {
                    string fullName = Session["FullName"].ToString();
                    string firstName = fullName.Split(' ')[0];
                    lblNavName.Text = firstName;
                }
            }
            else
            {
                // User is not logged in — show guest links, hide user panel
                pnlUser.Visible = false;
                pnlGuest.Visible = true;
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}