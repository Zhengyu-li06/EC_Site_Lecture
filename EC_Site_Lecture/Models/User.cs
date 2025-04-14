using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace EC_Site_Lecture.Models
{
    public class User
    {
        public int UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }

        private static readonly string _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

        public static User GetByUsernameOrEmail(string usernameOrEmail)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                string query = "SELECT UserId, Username, Email, PasswordHash FROM Users WHERE Username = @UsernameOrEmail OR Email = @UsernameOrEmail";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UsernameOrEmail", usernameOrEmail);

                var reader = command.ExecuteReader();
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
            }
            return null;
        }

        public bool VerifyPassword(string inputPassword)
        {
            return HashPassword(inputPassword) == this.PasswordHash;
        }

        private static string HashPassword(string password)
        {
            using (var sha256 = SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(Encoding.UTF8.GetBytes(password));
                var sb = new StringBuilder();
                foreach (var b in bytes)
                {
                    sb.Append(b.ToString("x2"));
                }
                return sb.ToString();
            }
        }
    }
}
