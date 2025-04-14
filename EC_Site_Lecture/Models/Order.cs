using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using EC_Site_Lecture.DTO;
using EC_Site_Lecture.ScreenDTO;

namespace EC_Site_Lecture.Models
{
    public class Order
    {
        public List<ProductDto> GetCartProducts(List<CartDto> cartItems)
        {
            var cartProducts = new List<ProductDto>();
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string productIds = string.Join(",", cartItems.Select(item => item.ProductId));
                string sql = $"SELECT ProductId, ProductName, Price, Description, ImageUrl FROM Products WHERE ProductId IN ({productIds})";

                using (var command = new SqlCommand(sql, connection))
                using (var reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        int productId = Convert.ToInt32(reader["ProductId"]);
                        string productName = reader["ProductName"].ToString();
                        double price = Convert.ToDouble(reader["Price"]);
                        string description = reader["Description"]?.ToString() ?? "";
                        string imageUrl = reader["ImageUrl"]?.ToString() ?? "";

                        int quantity = cartItems.First(item => item.ProductId == productId).Quantity;

                        cartProducts.Add(new ProductDto
                        {
                            Id = productId,
                            Name = productName,
                            Description = description,
                            ImageUrl = imageUrl,
                            Price = price,
                            Quantity = quantity,
                            CartQuantity = quantity,
                            IsInWishlist = false 
                        });
                    }
                }
            }

            return cartProducts;
        }

        public string GetUserEmail(int userId)
        {
            string email = "";
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string sql = "SELECT Email FROM Users WHERE UserId = @UserId";
                using (var command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
                    var result = command.ExecuteScalar();
                    if (result != null)
                        email = result.ToString();
                }
            }

            return email;
        }

        public int InsertOrder(int userId, string name, string address, string phone, string email, double totalAmount)
        {
            int orderId = 0;
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                string sql = @"INSERT INTO Orders (UserId, TotalAmount, CustomerName, CustomerAddress, CustomerPhone, CustomerEmail, OrderDate, Status)
                               VALUES (@UserId, @TotalAmount, @CustomerName, @CustomerAddress, @CustomerPhone, @CustomerEmail, @OrderDate, @Status);
                               SELECT SCOPE_IDENTITY();";

                using (var command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
                    command.Parameters.AddWithValue("@TotalAmount", totalAmount);
                    command.Parameters.AddWithValue("@CustomerName", name);
                    command.Parameters.AddWithValue("@CustomerAddress", address);
                    command.Parameters.AddWithValue("@CustomerPhone", phone);
                    command.Parameters.AddWithValue("@CustomerEmail", email);
                    command.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                    command.Parameters.AddWithValue("@Status", "Pending");

                    orderId = Convert.ToInt32(command.ExecuteScalar());
                }
            }

            return orderId;
        }

        public void InsertOrderItems(int orderId, List<ProductDto> cartProducts)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                foreach (var product in cartProducts)
                {
                    string sql = @"INSERT INTO OrderItems (OrderId, ProductId, ProductName, ProductPrice, Quantity)
                                   VALUES (@OrderId, @ProductId, @ProductName, @ProductPrice, @Quantity)";

                    using (var command = new SqlCommand(sql, connection))
                    {
                        command.Parameters.AddWithValue("@OrderId", orderId);
                        command.Parameters.AddWithValue("@ProductId", product.Id);
                        command.Parameters.AddWithValue("@ProductName", product.Name);
                        command.Parameters.AddWithValue("@ProductPrice", product.Price);
                        command.Parameters.AddWithValue("@Quantity", product.CartQuantity); // or product.Quantity

                        command.ExecuteNonQuery();
                    }
                }
            }
        }

        public void SendConfirmationEmail(string toEmail, List<ProductDto> products, double totalAmount)
        {
            try
            {
                string subject = "【ECサイト】ご注文確認メール";
                string body = $"お客様\n\nこのたびはご注文ありがとうございます。\n\n注文内容は以下の通りです：\n\n";

                foreach (var product in products)
                {
                    body += $"- {product.Name} x {product.CartQuantity}：¥{product.Price * product.CartQuantity:F2}\n";
                }

                body += $"\n合計金額：¥{totalAmount:F2}\n\nまたのご利用をお待ちしております。\n";

                var mail = new MailMessage
                {
                    From = new MailAddress("zezeyoyo506@gmail.com", "ECサイト"),
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = false
                };

                mail.To.Add(toEmail);

                var smtp = new SmtpClient("smtp.gmail.com", 587)
                {
                    Credentials = new NetworkCredential("zezeyoyo506@gmail.com", "vdac wvbf rdxz mgut"),
                    EnableSsl = true
                };

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("email error: " + ex.Message);
            }
        }
    }
}
