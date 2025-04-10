using System;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Configuration;


namespace YourNamespace
{
    public partial class Login : System.Web.UI.Page
    {
        private string _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            
            lblErrorMessage.Text = string.Empty;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string usernameOrEmail = txtUsernameOrEmail.Text.Trim();
            string password = txtPassword.Text;

            var user = GetUserFromDatabase(usernameOrEmail);

            if (user != null && VerifyPassword(password, user.PasswordHash))
            {
                
                Session["UserId"] = user.UserId;
                Session["Username"] = user.Username;  

                if (chkRememberMe.Checked)
                {
                    
                    var authTicket = new FormsAuthenticationTicket(
                        1,  
                        user.Username,  
                        DateTime.Now,  
                        DateTime.Now.AddDays(30),  
                        true,  
                        user.UserId.ToString()  
                    );

                    
                    string encryptedTicket = FormsAuthentication.Encrypt(authTicket);
                    HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
                    {
                        HttpOnly = true,
                        Secure = Request.IsSecureConnection,  
                        Path = FormsAuthentication.FormsCookiePath
                    };
                    Response.Cookies.Add(cookie);
                }

                
                Response.Redirect("Index.aspx");  
            }
            else
            {
                
                lblErrorMessage.Text = "ユーザー名またはパスワードが無効です。"; 
            }
        }

        private User GetUserFromDatabase(string usernameOrEmail)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                string query = "SELECT UserId, Username, Email, PasswordHash FROM Users WHERE Username = @UsernameOrEmail OR Email = @UsernameOrEmail";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UsernameOrEmail", usernameOrEmail);
                

                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    return new User
                    {
                        UserId = (int)reader["UserId"],
                        Username = reader["Username"].ToString(),
                        Email = reader["Email"].ToString(),
                        PasswordHash = reader["PasswordHash"].ToString()
                    };
                }
                return null;
            }
        }

        private bool VerifyPassword(string password, string storedHash)
        {
            return HashPassword(password) == storedHash;
        }

        private string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
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

        public class User
        {
            public int UserId { get; set; }
            public string Username { get; set; }
            public string Email { get; set; }
            public string PasswordHash { get; set; }
        }
    }
}
