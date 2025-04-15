using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;


namespace EC_Site_Lecture.Models
{
    public class MyPageModel
    {
        private readonly string _connectionString;

        public MyPageModel()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
        }

        
        public User GetUserById(int userId)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                string query = "SELECT Username, Email FROM Users WHERE UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserId", userId);

                SqlDataReader reader = command.ExecuteReader();
                if (reader.Read())
                {
                    return new User
                    {
                        Username = reader["Username"].ToString(),
                        Email = reader["Email"].ToString()
                    };
                }
            }

            return null;
        }

    
        public List<OrderDTO> GetOrdersByUserId(int userId)
        {
            List<OrderDTO> orders = new List<OrderDTO>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                string query = "SELECT OrderId, TotalAmount, CustomerName, CustomerAddress, CustomerPhone, CustomerEmail, OrderDate, Status FROM Orders WHERE UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserId", userId);

                SqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    orders.Add(new OrderDTO
                    {
                        OrderId = Convert.ToInt32(reader["OrderId"]),
                        TotalAmount = Convert.ToDecimal(reader["TotalAmount"]),
                        CustomerName = reader["CustomerName"].ToString(),
                        CustomerAddress = reader["CustomerAddress"].ToString(),
                        CustomerPhone = reader["CustomerPhone"].ToString(),
                        CustomerEmail = reader["CustomerEmail"].ToString(),
                        OrderDate = Convert.ToDateTime(reader["OrderDate"]),
                        Status = reader["Status"].ToString()
                    });
                }
            }

            return orders;
        }

        public void UpdateUsername(int userId, string newUsername)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                string query = "UPDATE Users SET Username = @Username WHERE UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@Username", newUsername);
                command.Parameters.AddWithValue("@UserId", userId);
                command.ExecuteNonQuery();
            }
        }


        public void DeleteUser(int userId)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                string query = "DELETE FROM Users WHERE UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserId", userId);
                command.ExecuteNonQuery();
            }
        }
    }
}

