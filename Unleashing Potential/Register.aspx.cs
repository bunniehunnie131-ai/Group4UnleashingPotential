using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

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
            string connStr = System.Configuration.ConfigurationManager
                             .ConnectionStrings["LocalKasiServices"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO dbo.[User] (FullName, Email, [Password]) VALUES (@FullName, @Email, @Password)";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@FullName", txtFullName.Text);
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text);
                cmd.Parameters.AddWithValue("@Password", txtPassword.Text);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

           
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