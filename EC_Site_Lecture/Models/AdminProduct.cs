using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using EC_Site_Lecture.ScreenDTO;


namespace EC_Site_Lecture.Models
{
    public class AdminProduct
    {
        private static readonly string _connectionString =
            ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

       
        public static List<AdminProductDTO> GetAll(string keyword = "", string sortOption = "order", int userId = 0)
        {
            var products = new List<AdminProductDTO>();

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
                        p.Quantity
                    FROM Products p
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
                    if (!string.IsNullOrEmpty(keyword))
                    {
                        command.Parameters.AddWithValue("@keyword", $"%{keyword}%");
                    }

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            products.Add(new AdminProductDTO
                            {
                                Id = (int)reader["ProductId"],
                                Name = reader["ProductName"].ToString(),
                                Price = Convert.ToDouble(reader["Price"]),
                                Description = reader["Description"].ToString(),
                                ImageUrl = reader["ImageUrl"].ToString(),
                                Quantity = Convert.ToDouble(reader["Quantity"])
                            });
                        }
                    }
                }
            }

            return products;
        }

       
        public static AdminProductDTO GetById(int id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();

                string sql = @"
                    SELECT 
                        ProductId, ProductName, Price, Description, ImageUrl, Quantity
                    FROM Products
                    WHERE ProductId = @Id";

                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@Id", id);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new AdminProductDTO
                            {
                                Id = (int)reader["ProductId"],
                                Name = reader["ProductName"].ToString(),
                                Price = Convert.ToDouble(reader["Price"]),
                                Description = reader["Description"].ToString(),
                                ImageUrl = reader["ImageUrl"].ToString(),
                                Quantity = Convert.ToDouble(reader["Quantity"])
                            };
                        }
                    }
                }
            }

            return null;
        }


        public static bool Add(AdminProductDTO dto)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string sql = @"
            INSERT INTO Products (ProductName, Description, ImageUrl, Price, Quantity, DateCreated)
            VALUES (@Name, @Description, @ImageUrl, @Price, @Quantity, GETDATE())";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", dto.Name);
                    cmd.Parameters.AddWithValue("@Description", dto.Description ?? "");
                    cmd.Parameters.AddWithValue("@ImageUrl", dto.ImageUrl ?? "");
                    cmd.Parameters.AddWithValue("@Price", dto.Price);
                    cmd.Parameters.AddWithValue("@Quantity", dto.Quantity);

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }


        public static bool Update(AdminProductDTO dto)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();
                string sql = @"
            UPDATE Products SET
                ProductName = @Name,
                Price = @Price,
                Quantity = @Quantity,
                Description = @Description,
                ImageUrl = @ImageUrl
            WHERE ProductId = @Id";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", dto.Id);
                    cmd.Parameters.AddWithValue("@Name", dto.Name);
                    cmd.Parameters.AddWithValue("@Price", dto.Price);
                    cmd.Parameters.AddWithValue("@Quantity", dto.Quantity);
                    cmd.Parameters.AddWithValue("@Description", dto.Description);
                    cmd.Parameters.AddWithValue("@ImageUrl", dto.ImageUrl);

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }


    }
}
