using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Unleashing_Potential
{
    public partial class WebForm14 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Nothing needed on load for this page
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string connStr = ConfigurationManager
                .ConnectionStrings["ProjectDB"].ConnectionString;

            SqlTransaction transaction = null;

            try
            {
                string fullName = txtFullName.Text.Trim();
                string email = txtEmail.Text.Trim().ToLower();
                string phone = txtPhone.Text.Trim();
                string password = txtPassword.Text;
                string township = ddlTownship.SelectedValue;
                string securityQuestion = ddlSecurityQuestion.SelectedItem.Text;
                string securityAnswerHash = BookingDB.HashPassword(
                    txtSecurityAnswer.Text.Trim().ToLower());

                DateTime dob;
                if (!DateTime.TryParse(txtDOB.Text.Trim(), out dob))
                {
                    ShowWarning("Please enter a valid date of birth.");
                    return;
                }

                if ((DateTime.Today - dob).TotalDays < 365.25 * 18)
                {
                    ShowWarning("You must be at least 18 years old to register.");
                    return;
                }

                string passwordHash = HashPassword(password);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    transaction = conn.BeginTransaction();

                    // Step 1: Check email is not already registered
                    string checkSql = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                    SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                    checkCmd.Transaction = transaction;
                    checkCmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100);
                    checkCmd.Parameters["@Email"].Value = email;

                    int existing = (int)checkCmd.ExecuteScalar();
                    if (existing > 0)
                    {
                        ShowWarning("That email address is already registered.");
                        transaction.Rollback();
                        return;
                    }

                    // Step 2: Insert into Users
                    string userSql =
                        "INSERT INTO Users (FullName, Email, Phone, DateOfBirth, Township, PasswordHash, " +
                        "SecurityQuestion, SecurityAnswerHash, Role, DateCreated, IsActive) " +
                        "VALUES (@FullName, @Email, @Phone, @DOB, @Township, @PasswordHash, " +
                        "@SecurityQuestion, @SecurityAnswerHash, @Role, @DateCreated, @IsActive); " +
                        "SELECT SCOPE_IDENTITY();";

                    SqlCommand userCmd = new SqlCommand(userSql, conn);
                    userCmd.Transaction = transaction;

                    userCmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = fullName;
                    userCmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = email;
                    userCmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 20).Value = phone;
                    userCmd.Parameters.Add("@DOB", SqlDbType.Date).Value = dob;
                    userCmd.Parameters.Add("@Township", SqlDbType.NVarChar, 100).Value = township;
                    userCmd.Parameters.Add("@PasswordHash", SqlDbType.NVarChar, 256).Value = passwordHash;
                    userCmd.Parameters.Add("@SecurityQuestion", SqlDbType.NVarChar, 200).Value = securityQuestion;
                    userCmd.Parameters.Add("@SecurityAnswerHash", SqlDbType.NVarChar, 64).Value = securityAnswerHash;
                    userCmd.Parameters.Add("@Role", SqlDbType.NVarChar, 20).Value = "ServiceProvider";
                    userCmd.Parameters.Add("@DateCreated", SqlDbType.DateTime).Value = DateTime.Now;
                    userCmd.Parameters.Add("@IsActive", SqlDbType.Bit).Value = true;

                    int newUserID = Convert.ToInt32(userCmd.ExecuteScalar());

                    // Step 4: Insert into ServiceProviders using the new UserID
                    string providerSql =
                        "INSERT INTO ServiceProviders (UserID, Name, Category, Specialty, Description, " +
                        "Price, PriceUnit, Location, Phone, YearsExperience, Rating, ReviewCount) " +
                        "VALUES (@UserID, @Name, @Category, @Specialty, @Description, " +
                        "@Price, @PriceUnit, @Location, @Phone, @YearsExperience, 0, 0)";

                    SqlCommand providerCmd = new SqlCommand(providerSql, conn);
                    providerCmd.Transaction = transaction;

                    providerCmd.Parameters.Add("@UserID", SqlDbType.Int).Value = newUserID;
                    providerCmd.Parameters.Add("@Name", SqlDbType.NVarChar, 100).Value = txtProviderName.Text.Trim();
                    providerCmd.Parameters.Add("@Category", SqlDbType.NVarChar, 50).Value = ddlCategory.SelectedValue;
                    providerCmd.Parameters.Add("@Specialty", SqlDbType.NVarChar, 100).Value = txtSpecialty.Text.Trim();
                    providerCmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value = txtDescription.Text.Trim();
                    providerCmd.Parameters.Add("@Price", SqlDbType.Decimal).Value = decimal.Parse(txtPrice.Text.Trim());
                    providerCmd.Parameters.Add("@PriceUnit", SqlDbType.NVarChar, 50).Value = ddlPriceUnit.SelectedValue;
                    providerCmd.Parameters.Add("@Location", SqlDbType.NVarChar, 100).Value = txtLocation.Text.Trim();
                    providerCmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 20).Value = txtPhone.Text.Trim();
                    providerCmd.Parameters.Add("@YearsExperience", SqlDbType.Int).Value = int.Parse(txtYearsExperience.Text.Trim());

                    providerCmd.ExecuteNonQuery();

                    // Step 5: Both inserts succeeded — commit
                    transaction.Commit();

                    // Step 6: Log the registration
                    WriteAuditLog("PROVIDER_REGISTER",
                        "New service provider registered: " + email);

                    ClearForm();

                    // Step 7: Redirect to login with a success message
                    Response.Redirect("~/Login.aspx?registered=provider");
                }
            }
            catch (SqlException ex)
            {
                if (transaction != null)
                {
                    try { transaction.Rollback(); } catch { }
                }
                ShowDanger("Registration failed. Please try again.");
                WriteAuditLog("PROVIDER_REGISTER_ERROR", ex.Message);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
            Response.Redirect("~/Default.aspx");
        }

        private void ClearForm()
        {
            txtFullName.Text = "";
            txtEmail.Text = "";
            txtPhone.Text = "";
            txtDOB.Text = "";
            ddlTownship.SelectedIndex = 0;
            txtPassword.Text = "";
            txtConfirmPassword.Text = "";
            ddlSecurityQuestion.SelectedIndex = 0;
            txtSecurityAnswer.Text = "";
            txtProviderName.Text = "";
            ddlCategory.SelectedIndex = 0;
            txtSpecialty.Text = "";
            txtDescription.Text = "";
            txtPrice.Text = "";
            ddlPriceUnit.SelectedIndex = 0;
            txtLocation.Text = "";
            txtYearsExperience.Text = "";
            lblMessage.Text = "";
            lblMessage.CssClass = "";
        }

        // Simple SHA256 hash — replace with your project's hashing method if different
        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder sb = new StringBuilder();
                foreach (byte b in bytes)
                    sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        private void WriteAuditLog(string action, string description)
        {
            try
            {
                string connStr = ConfigurationManager
                    .ConnectionStrings["ProjectDB"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string sql = "INSERT INTO AuditLogs (UserName, Action, Description, LogDate) " +
                                 "VALUES (@UserName, @Action, @Description, @LogDate)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.Add("@UserName", SqlDbType.NVarChar, 100).Value = txtEmail.Text.Trim();
                    cmd.Parameters.Add("@Action", SqlDbType.NVarChar, 50).Value = action;
                    cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 500).Value = description;
                    cmd.Parameters.Add("@LogDate", SqlDbType.DateTime).Value = DateTime.Now;
                    cmd.ExecuteNonQuery();
                }
            }
            catch { }
        }

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
