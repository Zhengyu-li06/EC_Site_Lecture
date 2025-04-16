using System;
using System.Configuration;
using System.Data.SqlClient;
using BCrypt.Net;


using System.Web.Helpers;
using System.Security.Cryptography;
using System.Text;

namespace EC_Site_Lecture.Models
{
    public class AdminUser
    {
        public int Id { get; set; } 
        public string Username { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public bool IsActive { get; set; }

        private static readonly string _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

        public static AdminUser GetByUsernameOrEmail(string usernameOrEmail)
        {
            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Open();
               
                string query = @"
                            SELECT id, username, email, password_hash, is_active
                            FROM admin_users
                            WHERE username COLLATE SQL_Latin1_General_CP1_CI_AS = @UsernameOrEmail 
                               OR email COLLATE SQL_Latin1_General_CP1_CI_AS = @UsernameOrEmail";

                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UsernameOrEmail", usernameOrEmail);

                var reader = command.ExecuteReader();
                if (reader.Read())
                {
                    return new AdminUser
                    {
                        Id = (int)reader["id"],
                        Username = reader["username"].ToString(),
                        Email = reader["email"].ToString(),
                        PasswordHash = reader["password_hash"].ToString(),
                        IsActive = Convert.ToBoolean(reader["is_active"])
                    };
                }
            }
            return null;
        }

        public bool VerifyPassword(string inputPassword)
        {
            return HashPassword(inputPassword) == this.PasswordHash;
        }

        public static string HashPassword(string password)
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
