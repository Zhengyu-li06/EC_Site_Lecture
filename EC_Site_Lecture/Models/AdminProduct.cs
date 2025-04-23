using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using EC_Site_Lecture.ScreenDTO;


namespace EC_Site_Lecture.Models
{
    public class AdminProduct:CommonModel
    {
     


        public List<AdminProductDTO> GetAll(string keyword = "", string sortOption = "order", int userId = 0)
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
                p.ImageData,
                p.Quantity,
                p.IsDiscontinued,
                p.IsNewArrival
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
                            string imageUrl = reader["ImageUrl"].ToString();

                            if (reader["ImageData"] != DBNull.Value)
                            {
                                byte[] imageBytes = (byte[])reader["ImageData"];
                                string base64 = Convert.ToBase64String(imageBytes);
                                imageUrl = $"data:image/png;base64,{base64}";
                            }

                            products.Add(new AdminProductDTO
                            {
                                Id = (int)reader["ProductId"],
                                Name = reader["ProductName"].ToString(),
                                Price = Convert.ToDouble(reader["Price"]),
                                Description = reader["Description"].ToString(),
                                ImageUrl = imageUrl,
                                Quantity = Convert.ToDouble(reader["Quantity"]),
                                IsDiscontinued = reader["IsDiscontinued"] != DBNull.Value && Convert.ToBoolean(reader["IsDiscontinued"]),
                                IsNewArrival = reader["IsNewArrival"] != DBNull.Value && Convert.ToBoolean(reader["IsNewArrival"])
                            });
                        }
                    }
                }
            }

            return products;
        }


        public  AdminProductDTO GetById(int id)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                connection.Open();

                string sql = @"
            SELECT 
                ProductId, 
                ProductName, 
                Price, 
                Description, 
                ImageUrl, 
                ImageData,
                Quantity, 
                IsDiscontinued, 
                IsNewArrival
            FROM Products
            WHERE ProductId = @Id";

                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@Id", id);

                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string imageUrl = reader["ImageUrl"].ToString();

                            if (reader["ImageData"] != DBNull.Value)
                            {
                                byte[] imageBytes = (byte[])reader["ImageData"];
                                string base64 = Convert.ToBase64String(imageBytes);
                                imageUrl = $"data:image/png;base64,{base64}";
                            }

                            return new AdminProductDTO
                            {
                                Id = (int)reader["ProductId"],
                                Name = reader["ProductName"].ToString(),
                                Price = Convert.ToDouble(reader["Price"]),
                                Description = reader["Description"].ToString(),
                                ImageUrl = imageUrl,
                                Quantity = Convert.ToDouble(reader["Quantity"]),
                                IsDiscontinued = reader["IsDiscontinued"] != DBNull.Value && Convert.ToBoolean(reader["IsDiscontinued"]),
                                IsNewArrival = reader["IsNewArrival"] != DBNull.Value && Convert.ToBoolean(reader["IsNewArrival"])
                            };
                        }
                    }
                }
            }

            return null;
        }

        public bool Add(AdminProductDTO dto)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                byte[] imageBytes = null;

                if (dto.UploadedImage != null && dto.UploadedImage.ContentLength > 0)
                {
                    using (var ms = new MemoryStream())
                    {
                        dto.UploadedImage.InputStream.CopyTo(ms);
                        imageBytes = ms.ToArray();
                    }
                }

                string sql = @"
            INSERT INTO Products 
                (ProductName, Description, ImageUrl, Price, Quantity, DateCreated, IsDiscontinued, IsNewArrival, ImageData)
            VALUES 
                (@Name, @Description, @ImageUrl, @Price, @Quantity, GETDATE(), @IsDiscontinued, @IsNewArrival, @ImageData)";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Name", dto.Name);
                    cmd.Parameters.AddWithValue("@Description", dto.Description ?? "");
                    cmd.Parameters.AddWithValue("@ImageUrl", dto.ImageUrl ?? "");
                    cmd.Parameters.AddWithValue("@Price", dto.Price);
                    cmd.Parameters.AddWithValue("@Quantity", dto.Quantity);
                    cmd.Parameters.AddWithValue("@IsDiscontinued", dto.IsDiscontinued);
                    cmd.Parameters.AddWithValue("@IsNewArrival", dto.IsNewArrival);
                    cmd.Parameters.Add("@ImageData", SqlDbType.VarBinary).Value = (object)imageBytes ?? DBNull.Value;

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }


        public bool Update(AdminProductDTO dto)
        {
            using (SqlConnection conn = new SqlConnection(_connectionString))
            {
                conn.Open();

                List<string> extraSet = new List<string>();
                SqlParameter imageParam = null;

                if (dto.UploadedImage != null && dto.UploadedImage.ContentLength > 0)
                {
                    using (var ms = new MemoryStream())
                    {
                        dto.UploadedImage.InputStream.CopyTo(ms);
                        byte[] bytes = ms.ToArray();

                        extraSet.Add("ImageData = @ImageData");
                        imageParam = new SqlParameter("@ImageData", SqlDbType.VarBinary);
                        imageParam.Value = bytes;
                    }
                }

                string sql = @"
            UPDATE Products SET
                ProductName = @Name,
                Price = @Price,
                Quantity = @Quantity,
                Description = @Description,
                ImageUrl = @ImageUrl,
                IsDiscontinued = @IsDiscontinued,
                IsNewArrival = @IsNewArrival";

                if (extraSet.Count > 0)
                {
                    sql += ", " + string.Join(", ", extraSet);
                }

                sql += " WHERE ProductId = @Id";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", dto.Id);
                    cmd.Parameters.AddWithValue("@Name", dto.Name);
                    cmd.Parameters.AddWithValue("@Price", dto.Price);
                    cmd.Parameters.AddWithValue("@Quantity", dto.Quantity);
                    cmd.Parameters.AddWithValue("@Description", dto.Description ?? "");
                    cmd.Parameters.AddWithValue("@ImageUrl", dto.ImageUrl ?? "");
                    cmd.Parameters.AddWithValue("@IsDiscontinued", dto.IsDiscontinued);
                    cmd.Parameters.AddWithValue("@IsNewArrival", dto.IsNewArrival);

                    if (imageParam != null)
                    {
                        cmd.Parameters.Add(imageParam);
                    }

                    return cmd.ExecuteNonQuery() > 0;
                }
            }
        }


    }
}
