using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace EC_Site_Lecture.Models
{
    public class UserRegist
    {
        private readonly string _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

        public bool UserExists(string username, string email)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
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

        public void InsertUser(string username, string email, string passwordHash)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
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
        }

        // 注册方法
        public string Register(RegisterDTO dto, out bool isSuccess)
        {
            isSuccess = false;

            if (dto.Password != dto.ConfirmPassword)
            {
                return "パスワードが一致しません。"; // 密码不一致
            }

            if (UserExists(dto.Username, dto.Email))
            {
                return "ユーザー名またはメールアドレスは既に使用されています。"; // 用户名或邮箱已存在
            }

            string passwordHash = HashPassword(dto.Password);
            InsertUser(dto.Username, dto.Email, passwordHash);

            isSuccess = true;
            return "登録が成功しました。"; // 注册成功
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

