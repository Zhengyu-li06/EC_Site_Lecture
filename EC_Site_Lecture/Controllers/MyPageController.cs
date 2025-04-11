using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class MyPageController
    {
        private readonly string _connectionString;

        public MyPageController()
        {
            _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
        }

        //public User GetUserById(int userId)
        //{
        //    using (SqlConnection connection = new SqlConnection(_connectionString))
        //    {
        //        connection.Open();
        //        string query = "SELECT Username, Email, DateCreated FROM Users WHERE UserId = @UserId";
        //        SqlCommand command = new SqlCommand(query, connection);
        //        command.Parameters.AddWithValue("@UserId", userId);

        //        SqlDataReader reader = command.ExecuteReader();
        //        if (reader.Read())
        //        {
        //            return new User
        //            {
        //                Username = reader["Username"].ToString(),
        //                Email = reader["Email"].ToString(),
        //                DateCreated = Convert.ToDateTime(reader["DateCreated"])
        //            };
        //        }
        //    }

        //    return null;
        //}
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

        public List<Order> GetOrdersByUserId(int userId)
        {
            List<Order> orders = new List<Order>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                string query = "SELECT OrderId, TotalAmount, CustomerName, CustomerAddress, CustomerPhone, CustomerEmail, OrderDate, Status FROM Orders WHERE UserId = @UserId";
                SqlCommand command = new SqlCommand(query, connection);
                command.Parameters.AddWithValue("@UserId", userId);

                SqlDataReader reader = command.ExecuteReader();

                while (reader.Read())
                {
                    orders.Add(new Order
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
    }
}
