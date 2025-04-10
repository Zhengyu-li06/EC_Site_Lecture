using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Configuration;

namespace YourNamespace
{
    public partial class Register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirmPassword.Text;

            if (password != confirmPassword)
            {
                lblMessage.Text = "パスワードが一致しません。";
                return;
            }

            if (UserExists(username, email))
            {
                lblMessage.Text = "ユーザー名またはメールアドレスは既に使用されています。";
                return;
            }

            string passwordHash = HashPassword(password);

            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string sql = "INSERT INTO Users (Username, Email, PasswordHash, DateCreated) VALUES (@Username, @Email, @PasswordHash, @DateCreated)";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@Username", username);
                command.Parameters.AddWithValue("@Email", email);
                command.Parameters.AddWithValue("@PasswordHash", passwordHash);
                command.Parameters.AddWithValue("@DateCreated", DateTime.Now);

                command.ExecuteNonQuery();
            }

            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "登録が成功しました。";
        }

        private bool UserExists(string username, string email)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string sql = "SELECT UserId FROM Users WHERE Username = @Username OR Email = @Email";
                SqlCommand command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@Username", username);
                command.Parameters.AddWithValue("@Email", email);
                SqlDataReader reader = command.ExecuteReader();

                return reader.HasRows;
            }
        }

        private string HashPassword(string password)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                foreach (byte b in bytes)
                {
                    builder.Append(b.ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}