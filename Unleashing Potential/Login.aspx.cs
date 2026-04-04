using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            
            if (email == "admin@test.com" && password == "." +
                "" +
                "")
            {
                Session["UserEmail"] = email;
                Response.Redirect("Default.aspx");
            }
            else
            {
                lblLoginMessage.Text = "Invalid email or password.";
                lblLoginMessage.CssClass = "alert alert-danger d-block mt-2";
            }
        }
    }
}