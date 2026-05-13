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
                .ConnectionStrings["UnleashingPotentialDB"].ConnectionString;

            SqlTransaction transaction = null;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    transaction = conn.BeginTransaction();

                    // Step 1: Check email is not already registered
                    string checkSql = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                    SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                    checkCmd.Transaction = transaction;
                    checkCmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100);
                    checkCmd.Parameters["@Email"].Value = txtEmail.Text.Trim();

                    int existing = (int)checkCmd.ExecuteScalar();
                    if (existing > 0)
                    {
                        lblMessage.Text = "That email address is already registered.";
                        transaction.Rollback();
                        return;
                    }

                    // Step 2: Hash the password
                    string passwordHash = HashPassword(txtPassword.Text);

                    // Step 3: Insert into Users
                    string userSql =
                        "INSERT INTO Users (FullName, Email, Phone, PasswordHash, Role, DateCreated, IsActive) " +
                        "VALUES (@FullName, @Email, @Phone, @PasswordHash, @Role, @DateCreated, @IsActive); " +
                        "SELECT SCOPE_IDENTITY();";

                    SqlCommand userCmd = new SqlCommand(userSql, conn);
                    userCmd.Transaction = transaction;

                    userCmd.Parameters.Add("@FullName", SqlDbType.NVarChar, 100).Value = txtFullName.Text.Trim();
                    userCmd.Parameters.Add("@Email", SqlDbType.NVarChar, 100).Value = txtEmail.Text.Trim();
                    userCmd.Parameters.Add("@Phone", SqlDbType.NVarChar, 20).Value = txtPhone.Text.Trim();
                    userCmd.Parameters.Add("@PasswordHash", SqlDbType.NVarChar, 256).Value = passwordHash;
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
                        "New service provider registered: " + txtEmail.Text.Trim());

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
                lblMessage.Text = "Registration failed. Please try again.";
                WriteAuditLog("PROVIDER_REGISTER_ERROR", ex.Message);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Default.aspx");
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
                    .ConnectionStrings["UnleashingPotentialDB"].ConnectionString;

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
    }
}