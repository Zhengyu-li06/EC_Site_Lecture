using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using YourNamespace.DTO;
using YourNamespace.ScreenDTO;

public class WishlistModel
{
    private readonly string _connectionString;

    public WishlistModel()
    {
        _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
    }

    public bool IsInWishlist(int userId, int productId)
    {
        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            conn.Open();
            const string query = "SELECT COUNT(*) FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@ProductId", productId);

                return (int)cmd.ExecuteScalar() > 0;
            }
        }
    }

    public void AddToWishlist(int userId, int productId)
    {
        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            conn.Open();
            const string query = "INSERT INTO Wishlist (UserId, ProductId) VALUES (@UserId, @ProductId)";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.ExecuteNonQuery();
            }
        }
    }

    public void RemoveFromWishlist(int userId, int productId)
    {
        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            conn.Open();
            const string query = "DELETE FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.ExecuteNonQuery();
            }
        }
    }

    public List<WishlistDTO> GetWishlistByUserId(int userId)
    {
        var items = new List<WishlistDTO>();

        using (SqlConnection conn = new SqlConnection(_connectionString))
        {
            conn.Open();
            const string query = @"
                SELECT p.ProductId, p.ProductName, p.Price, p.ImageUrl
                FROM Wishlist w
                INNER JOIN Product p ON w.ProductId = p.ProductId
                WHERE w.UserId = @UserId";

            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        items.Add(new WishlistDTO
                        {
                            ProductId = reader.GetInt32(0),
                            ProductName = reader.GetString(1),
                            Price = Convert.ToDouble(reader["Price"]),
                            ImageUrl = reader["ImageUrl"].ToString()
                        });
                    }
                }
            }
        }

        return items;
    }
}
