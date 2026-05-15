using System;
using System.Web;
using System.Web.UI;

namespace Unleashing_Potential
{
    public partial class WebForm2 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRememberedEmail();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEmail.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                ShowError("Please enter your email and password.");
                return;
            }

            string email = txtEmail.Text.Trim().ToLower();

            Users user = null;
            LoginAttemptStatus loginStatus;
            try
            {
                loginStatus = BookingDB.TryLoginUser(email, txtPassword.Text, out user);
            }
            catch (Exception)
            {
                ShowError("A system error occurred. Please try again.");
                return;
            }

            if (loginStatus == LoginAttemptStatus.InvalidCredentials || user == null)
            {
                ShowError("Incorrect email or password.");
                return;
            }

            if (loginStatus == LoginAttemptStatus.InactiveAccount)
            {
                string role = user.Role ?? string.Empty;
                if (string.Equals(role, "ServiceProvider", StringComparison.OrdinalIgnoreCase) ||
                    string.Equals(role, "Provider", StringComparison.OrdinalIgnoreCase))
                {
                    ShowError("Your service provider account is pending approval. Please wait for an admin to activate it.");
                }
                else
                {
                    ShowError("Your account is inactive. Please contact support.");
                }
                return;
            }

            UpdateRememberedEmailCookie(user.Email);

            Session["UserID"] = user.UserID;
            Session["UserName"] = user.FullName;
            Session["FullName"] = user.FullName;
            Session["UserEmail"] = user.Email;
            Session["UserPhone"] = user.Phone;
            Session["Role"] = user.Role;

            BookingDB.WriteAuditLog(user.FullName, "LOGIN", "User logged in: " + user.Email);

            if (string.Equals(user.Role, "Admin", StringComparison.OrdinalIgnoreCase))
                Response.Redirect("~/Admin.aspx");
            else if (string.Equals(user.Role, "ServiceProvider", StringComparison.OrdinalIgnoreCase) ||
                     string.Equals(user.Role, "Provider", StringComparison.OrdinalIgnoreCase))
                Response.Redirect("~/ServiceProviderDashboard.aspx");
            else
                Response.Redirect("~/ServiceCategories.aspx");
        }

        private void LoadRememberedEmail()
        {
            HttpCookie cookie = Request.Cookies["RememberEmail"];
            if (cookie != null && !string.IsNullOrWhiteSpace(cookie.Value))
            {
                txtEmail.Text = cookie.Value;
                chkRememberMe.Checked = true;
            }
        }

        private void UpdateRememberedEmailCookie(string email)
        {
            if (chkRememberMe.Checked)
            {
                HttpCookie cookie = new HttpCookie("RememberEmail", email)
                {
                    Expires = DateTime.Now.AddDays(30),
                    HttpOnly = true
                };
                Response.Cookies.Add(cookie);
                return;
            }

            if (Request.Cookies["RememberEmail"] != null)
            {
                HttpCookie expiredCookie = new HttpCookie("RememberEmail")
                {
                    Expires = DateTime.Now.AddDays(-1)
                };
                Response.Cookies.Add(expiredCookie);
            }
        }

        private void ShowError(string message)
        {
            lblLoginMessage.Text = message;
            lblLoginMessage.CssClass = "alert alert-danger d-block mt-2";
        }
    }
}
