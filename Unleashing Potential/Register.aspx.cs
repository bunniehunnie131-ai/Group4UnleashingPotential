using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtDOB.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            ddlTownship.SelectedIndex = 0;
            chkTerms.Checked = false;
            lblMessage.Text = "";
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "Registration successful! Welcome, " + txtFullName.Text.Trim() + ".";
            lblMessage.CssClass = "d-block mt-3 text-success fw-bold";
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtDOB.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            ddlTownship.SelectedIndex = 0;
            chkTerms.Checked = false;
        }
    }
}