using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using EC_Site_Lecture.DTO; 
using EC_Site_Lecture.ScreenDTO;

namespace EC_Site_Lecture.Models
{
    public class CartModel : CommonModel 
    {
        public List<CartDto> GetCartItems(int userId)
        {
            var items = new List<CartDto>();

            using (SqlConnection conn = new SqlConnection(_connectionString)) 
            {
                conn.Open();
                string sql = @"
                    SELECT c.ProductId, p.ProductName, p.Price, p.Description, p.ImageUrl, c.Quantity
                    FROM Cart c
                    JOIN Products p ON c.ProductId = p.ProductId
                    WHERE c.UserId = @UserId";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        items.Add(new CartDto
                        {
                            ProductId = Convert.ToInt32(reader["ProductId"]),
                            Name = reader["ProductName"].ToString(),
                            Price = Convert.ToDouble(reader["Price"]),
                            Description = reader["Description"].ToString(),
                            ImageUrl = reader["ImageUrl"].ToString(),
                            Quantity = Convert.ToInt32(reader["Quantity"])
                        });
                    }
                }
            }

            return items;
        }

        public void UpdateQuantity(int userId, int productId, string action)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string sql = "";

                if (action == "Increase")
                {
                    sql = "UPDATE Cart SET Quantity = Quantity + 1 WHERE UserId = @UserId AND ProductId = @ProductId";
                }
                else if (action == "Decrease")
                {
                    sql = "UPDATE Cart SET Quantity = Quantity - 1 WHERE UserId = @UserId AND ProductId = @ProductId AND Quantity > 1";
                }
                else if (action == "Delete")
                {
                    sql = "DELETE FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.ExecuteNonQuery();
            }
        }

        public void AddToCart(int userId, int productId)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string checkQuery = "SELECT COUNT(*) FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@UserId", userId);
                    checkCmd.Parameters.AddWithValue("@ProductId", productId);

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count == 0)
                    {
                        string insertQuery = "INSERT INTO Cart (UserId, ProductId, Quantity) VALUES (@UserId, @ProductId, @Quantity)";
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@UserId", userId);
                            insertCmd.Parameters.AddWithValue("@ProductId", productId);
                            insertCmd.Parameters.AddWithValue("@Quantity", 1);
                            insertCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string updateQuery = "UPDATE Cart SET Quantity = Quantity + 1 WHERE UserId = @UserId AND ProductId = @ProductId";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@UserId", userId);
                            updateCmd.Parameters.AddWithValue("@ProductId", productId);
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        public int GetCartItemCount(int userId)
        {
            int itemCount = 0;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string query = "SELECT SUM(Quantity) FROM Cart WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    object result = cmd.ExecuteScalar();
                    itemCount = result != DBNull.Value ? Convert.ToInt32(result) : 0;
                }
            }
            return itemCount;
        }

        public int GetCartItemCount(int userId, int productId)
        {
            int itemCount = 0;
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string query = "SELECT Quantity FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.Parameters.AddWithValue("@ProductId", productId);
                    object result = cmd.ExecuteScalar();
                    itemCount = result != DBNull.Value ? Convert.ToInt32(result) : 0;
                }
            }
            return itemCount;
        }
    }
}
