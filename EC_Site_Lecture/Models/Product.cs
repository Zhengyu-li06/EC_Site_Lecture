
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using YourNamespace.ScreenDTO;

namespace YourNamespace.Models
{
    public class Product
    {
        private static readonly string _connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

        public static List<ProductDto> GetAll(string keyword = "", string sortOption = "order", int userId = 0)
        {
            var products = new List<ProductDto>();
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();

                string sql = @"
            SELECT 
                p.ProductId, 
                p.ProductName, 
                p.Price, 
                p.Description,
                p.ImageUrl,
                p.Quantity,
                CASE 
                    WHEN w.ProductId IS NOT NULL THEN 1 
                    ELSE 0 
                END AS IsInWishlist
            FROM Products p
            LEFT JOIN Wishlist w ON p.ProductId = w.ProductId AND w.UserId = @UserId
        ";

                var conditions = new List<string>();
                if (!string.IsNullOrEmpty(keyword))
                {
                    conditions.Add("(p.ProductName LIKE @keyword OR p.Description LIKE @keyword)");
                }

                if (conditions.Count > 0)
                {
                    sql += " WHERE " + string.Join(" AND ", conditions);
                }

                switch (sortOption)
                {
                    case "price_asc": sql += " ORDER BY p.Price ASC"; break;
                    case "price_desc": sql += " ORDER BY p.Price DESC"; break;
                    case "name_asc": sql += " ORDER BY p.ProductName ASC"; break;
                    default: sql += " ORDER BY p.ProductId DESC"; break;
                }

                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
                    if (!string.IsNullOrEmpty(keyword))
                    {
                        command.Parameters.AddWithValue("@keyword", $"%{keyword}%");
                    }

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            products.Add(new ProductDto
                            {
                                Id = (int)reader["ProductId"],
                                Name = reader["ProductName"].ToString(),
                                Price = double.TryParse(reader["Price"].ToString(), out double price) ? price : 0,
                                Description = reader["Description"].ToString(),
                                ImageUrl = reader["ImageUrl"].ToString(),
                                CartQuantity = 0, // 后面由 controller 设置
                                IsInWishlist = Convert.ToInt32(reader["IsInWishlist"]) == 1
                            });
                        }
                    }
                }
            }

            return products;
        }

    }
}
