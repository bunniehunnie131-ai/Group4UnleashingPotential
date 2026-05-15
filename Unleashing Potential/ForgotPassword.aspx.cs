using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm13 : System.Web.UI.Page
    {

        // Session keys
        private const string SessEmail = "FP_Email";
        private const string SessStep = "FP_Step";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Remove(SessEmail);
                Session.Remove(SessStep);
                ShowStep(1);
            }
        }

        // ── STEP 1: Verify email exists ───────────────────────────────────
        protected void btnStep1_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = txtEmail.Text.Trim().ToLower();

            bool exists = false;
            try { exists = BookingDB.EmailExists(email); }
            catch
            {
                ShowMessage("Unable to verify email. Please try again.", "danger");
                return;
            }

            // Always show a neutral message — avoids confirming whether an
            // email is registered (security best practice)
            if (!exists)
            {
                ShowMessage("If that email is registered, you will be able to " +
                            "proceed. Please check your entry.", "warning");
                return;
            }

            string question = null;
            try { question = BookingDB.GetSecurityQuestion(email); }
            catch
            {
                ShowMessage("Unable to retrieve security question. Please try again.", "danger");
                return;
            }

            if (string.IsNullOrEmpty(question))
            {
                ShowMessage("No security question found for this account. " +
                            "Please contact support.", "warning");
                return;
            }

            // Persist email and question for next step
            Session[SessEmail] = email;
            lblSecurityQuestion.Text = question;
            ShowStep(2);
        }

        // ── STEP 2: Validate security answer ──────────────────────────────
        protected void btnStep2_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string email = Session[SessEmail] as string;
            if (string.IsNullOrEmpty(email)) { ResetToStep1(); return; }

            // Normalise to lowercase before hashing — matches how we stored it
            string answerHash = BookingDB.HashLegacySha256(
                txtAnswer.Text.Trim().ToLower());

            bool valid = false;
            try { valid = BookingDB.ValidateSecurityAnswer(email, answerHash); }
            catch
            {
                ShowMessage("Verification failed. Please try again.", "danger");
                return;
            }

            if (!valid)
            {
                ShowMessage("Incorrect answer. Please try again.", "warning");
                // Keep the question visible; stay on step 2
                lblSecurityQuestion.Text = BookingDB.GetSecurityQuestion(email);
                ShowStep(2);
                return;
            }

            Session[SessStep] = "verified";   // gate for step 3
            ShowStep(3);
        }

        // ── STEP 3: Set new password ───────────────────────────────────────
        protected void btnStep3_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            // Make sure the user actually passed step 2
            if (Session[SessStep] as string != "verified") { ResetToStep1(); return; }

            string email = Session[SessEmail] as string;
            if (string.IsNullOrEmpty(email)) { ResetToStep1(); return; }

            string newPassword = txtNewPassword.Text;

            // Don't allow the password to equal the email address
            if (newPassword.Equals(email, StringComparison.OrdinalIgnoreCase))
            {
                ShowMessage("Your password cannot be the same as your email address.", "warning");
                ShowStep(3);
                return;
            }

            bool success = false;
            try { success = BookingDB.ResetPassword(email, newPassword); }
            catch
            {
                ShowMessage("Password reset failed. Please try again.", "danger");
                ShowStep(3);
                return;
            }

            if (success)
            {
                BookingDB.WriteAuditLog(email, "PASSWORD_RESET",
                    "Password reset via security question for: " + email);

                // Clean up session
                Session.Remove(SessEmail);
                Session.Remove(SessStep);

                // Show success then redirect after a moment
                ShowMessage("✓ Password reset successfully! Redirecting you to login…", "success");
                pnlStep3.Visible = false;

                // Client-side redirect after 2 seconds
                ScriptManager.RegisterStartupScript(this, GetType(), "redirect",
                    "setTimeout(function(){ window.location='Login.aspx'; }, 2500);", true);
            }
            else
            {
                ShowMessage("Password reset failed. Please try again.", "danger");
                ShowStep(3);
            }
        }

        // ── Back buttons ──────────────────────────────────────────────────
        protected void btnBack1_Click(object sender, EventArgs e) => ResetToStep1();
        protected void btnBack2_Click(object sender, EventArgs e)
        {
            string email = Session[SessEmail] as string;
            if (!string.IsNullOrEmpty(email))
                lblSecurityQuestion.Text = BookingDB.GetSecurityQuestion(email);
            ShowStep(2);
        }

        // ── Helpers ───────────────────────────────────────────────────────
        private void ShowStep(int step)
        {
            pnlStep1.Visible = step == 1;
            pnlStep2.Visible = step == 2;
            pnlStep3.Visible = step == 3;

            dot1.CssClass = step >= 1 ? "step-dot active" : "step-dot";
            dot2.CssClass = step >= 2 ? "step-dot active" : "step-dot";
            dot3.CssClass = step >= 3 ? "step-dot active" : "step-dot";

            switch (step)
            {
                case 1:
                    lblStepSubtitle.Text = "Enter your registered email address to begin.";
                    break;
                case 2:
                    lblStepSubtitle.Text = "Answer your security question to verify your identity.";
                    break;
                case 3:
                    lblStepSubtitle.Text = "Choose a new password for your account.";
                    break;
                default:
                    lblStepSubtitle.Text = "";
                    break;
            }

            lblMessage.Text = "";
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = $"d-block mt-3 alert alert-{type}";
        }

        private void ResetToStep1()
        {
            Session.Remove(SessEmail);
            Session.Remove(SessStep);
            txtEmail.Text = "";
            txtAnswer.Text = "";
            ShowStep(1);
        }
    }
}
