using System;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // ─── Terms checkbox: server-side custom validator ─────────────────────
        protected void cvTerms_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = chkTerms.Checked;
        }

        // ─── Clear button ─────────────────────────────────────────────────────
        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtDOB.Text = "";
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            txtSecurityAnswer.Text = "";
            ddlTownship.SelectedIndex = 0;
            ddlSecurityQuestion.SelectedIndex = 0;
            chkTerms.Checked = false;
            lblMessage.Text = "";
            lblMessage.CssClass = "";
        }

        // ─── Register button ──────────────────────────────────────────────────
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim().ToLower();
            string phone = txtPhone.Text.Trim();
            string password = txtPassword.Text;
            string township = ddlTownship.SelectedValue;

            // Read security question text (not just the value code)
            string securityQuestion = ddlSecurityQuestion.SelectedItem.Text;
            string securityAnswerHash = BookingDB.HashLegacySha256(
                txtSecurityAnswer.Text.Trim().ToLower());

            // ── 1. Parse date of birth ────────────────────────────────────────
            DateTime dob;
            if (!DateTime.TryParse(txtDOB.Text.Trim(), out dob))
            {
                ShowWarning("Please enter a valid date of birth.");
                return;
            }

            // ── 2. Minimum age check (18+) ────────────────────────────────────
            if ((DateTime.Today - dob).TotalDays < 365.25 * 18)
            {
                ShowWarning("You must be at least 18 years old to register.");
                return;
            }

            // ── 3. Password may not equal full name or email ──────────────────
            if (password.Equals(fullName, StringComparison.OrdinalIgnoreCase) ||
                password.Equals(email, StringComparison.OrdinalIgnoreCase))
            {
                ShowWarning("Your password cannot be the same as your name or email address.");
                return;
            }

            // ── 4. Duplicate full-name check ──────────────────────────────────
            try
            {
                if (BookingDB.FullNameExists(fullName))
                {
                    ShowWarning("An account with this full name already exists. " +
                                "Please use your legal name or contact support.");
                    return;
                }
            }
            catch (Exception)
            {
                ShowDanger("Unable to verify name availability. Please try again.");
                return;
            }

            // ── 5. Duplicate email check ──────────────────────────────────────
            try
            {
                if (BookingDB.EmailExists(email))
                {
                    ShowWarning("An account with this email address already exists. " +
                                "Please log in or use a different email.");
                    return;
                }
            }
            catch (Exception)
            {
                ShowDanger("Unable to verify email availability. Please try again.");
                return;
            }

            // ── 6. Store user securely ────────────────────────────────────────
            bool success = false;
            try
            {
                success = BookingDB.RegisterUser(
                    fullName, email, phone, dob, township,
                    password, securityQuestion, securityAnswerHash);
            }
            catch (Exception)
            {
                ShowDanger("Registration failed due to a server error. Please try again.");
                return;
            }

            // ── 7. Post-registration steps ────────────────────────────────────
            if (success)
            {
                BookingDB.WriteAuditLog(
                    fullName,
                    "USER_REGISTERED",
                    "New user registered: " + email);

                lblMessage.Text = "Registration successful! Welcome, " + fullName +
                                      ". You may now log in.";
                lblMessage.CssClass = "d-block mt-3 alert alert-success fw-bold";

                txtFullName.Text = "";
                txtEmail.Text = "";
                txtPhone.Text = "";
                txtDOB.Text = "";
                txtPassword.Text = "";
                txtConfirmPassword.Text = "";
                txtSecurityAnswer.Text = "";
                ddlTownship.SelectedIndex = 0;
                ddlSecurityQuestion.SelectedIndex = 0;
                chkTerms.Checked = false;
            }
            else
            {
                ShowDanger("Registration failed. Please try again.");
            }
        }

        // ─── Helpers ──────────────────────────────────────────────────────────
        private void ShowWarning(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "d-block mt-3 alert alert-warning";
        }

        private void ShowDanger(string message)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = "d-block mt-3 alert alert-danger";
        }
    }
}
