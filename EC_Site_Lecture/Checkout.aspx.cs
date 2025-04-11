using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Web.UI;
using System.Configuration;
using static YourNamespace.Cart;
using System.Net.Mail;
using System.Net;

namespace YourNamespace
{
    public partial class Checkout : Page
    {
        public class Product
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public double Price { get; set; }
            public int Quantity { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CartItems"] != null && Session["TotalAmount"] != null)
                {
                    var cartItems = (List<CartItem>)Session["CartItems"];
                    double totalAmount = (double)Session["TotalAmount"];

                    
                    CartRepeater.DataSource = cartItems;
                    CartRepeater.DataBind();
                    lblTotal.Text = totalAmount.ToString("F2");
                }
                else
                {
                    Response.Redirect("Index.aspx");
                }
            }
        }


        private List<Product> GetCartProducts()
        {
            var cartProducts = new List<Product>();

            var cartItems = (List<CartItem>)Session["CartItems"];
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                // 使用逗号分隔的 ProductId 列表
                string productIds = string.Join(",", cartItems.Select(item => item.ProductId));
                string sql = $"SELECT ProductId, ProductName, Price FROM Products WHERE ProductId IN ({productIds})";

                var command = new SqlCommand(sql, connection);
                var reader = command.ExecuteReader();

                while (reader.Read())
                {
                    int productId = Convert.ToInt32(reader["ProductId"]);
                    string productName = reader["ProductName"].ToString();
                    double price = Convert.ToDouble(reader["Price"]);

                    
                    int quantity = cartItems.First(item => item.ProductId == productId).Quantity;
                    cartProducts.Add(new Product
                    {
                        Id = productId,
                        Name = productName,
                        Price = price,
                        Quantity = quantity
                    });
                }

                reader.Close();
            }

            return cartProducts;
        }

       
        protected void ConfirmPurchase_Click(object sender, EventArgs e)
        {
            
            if (Session["CartItems"] == null || ((List<CartItem>)Session["CartItems"]).Count == 0)
            {
                Response.Redirect("Index.aspx");
                return;
            }

            string customerName = txtName.Text;
            string customerAddress = txtAddress.Text;
            string customerPhone = txtPhone.Text;


            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 1;
            string customerEmail = GetUserEmail(userId);



            var cartProducts = GetCartProducts();

            
            double totalAmount = cartProducts.Sum(p => p.Price * p.Quantity);

            int orderId = InsertOrder(customerName, customerAddress, customerPhone, customerEmail, totalAmount);

           
            InsertOrderItems(orderId, cartProducts);

           
            Session["CartItems"] = null;

            SendConfirmationEmail(customerEmail, cartProducts, totalAmount);

            if (Session["UserId"] != null)
            {
                Response.Redirect("ThankYou.aspx");
            }
            else
            {
                Response.Redirect("Login.aspx");
            }
        }
        private string GetUserEmail(int userId)
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
                    {
                        email = result.ToString();
                    }
                }
            }

            return email;
        }

        private void SendConfirmationEmail(string toEmail, List<Product> products, double totalAmount)
        {
            try
            {
                string subject = "【ECサイト】ご注文確認メール";
                string body = $"お客様\n\nこのたびはご注文ありがとうございます。\n\n注文内容は以下の通りです：\n\n";

                foreach (var product in products)
                {
                    body += $"- {product.Name} x {product.Quantity}：¥{product.Price * product.Quantity:F2}\n";
                }

                body += $"\n合計金額：¥{totalAmount:F2}\n\nまたのご利用をお待ちしております。\n";
                MailMessage mail = new MailMessage
                {
                    From = new MailAddress("zezeyoyo506@gmail.com", "ECサイト"), 
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = false 
                };

                mail.To.Add(toEmail); 

               
                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587)
                {
                    Credentials = new NetworkCredential("zezeyoyo506@gmail.com", "vdac wvbf rdxz mgut"), 
                    EnableSsl = true
                };

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
               
                System.Diagnostics.Debug.WriteLine("error: " + ex.Message);
            }
        }

        private int InsertOrder(string customerName, string customerAddress, string customerPhone, string customerEmail, double totalAmount)
        {
            int orderId = 0;
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = @"INSERT INTO Orders (UserId, TotalAmount, CustomerName, CustomerAddress, CustomerPhone, CustomerEmail, OrderDate, Status)
                       VALUES (@UserId, @TotalAmount, @CustomerName, @CustomerAddress, @CustomerPhone, @CustomerEmail, @OrderDate, @Status);
                       SELECT SCOPE_IDENTITY();"; 

                var command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@UserId", Session["UserId"] ?? 1); 
                command.Parameters.AddWithValue("@TotalAmount", totalAmount);
                command.Parameters.AddWithValue("@CustomerName", customerName);
                command.Parameters.AddWithValue("@CustomerAddress", customerAddress);
                command.Parameters.AddWithValue("@CustomerPhone", customerPhone);
                command.Parameters.AddWithValue("@CustomerEmail", customerEmail);
                command.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                command.Parameters.AddWithValue("@Status", "Pending");

                orderId = Convert.ToInt32(command.ExecuteScalar()); 
            }

            return orderId;
        }

        
        private void InsertOrderItems(int orderId, List<Product> cartProducts)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                foreach (var product in cartProducts)
                {
                    string sql = @"INSERT INTO OrderItems (OrderId, ProductId, ProductName, ProductPrice, Quantity)
                           VALUES (@OrderId, @ProductId, @ProductName, @ProductPrice, @Quantity)";

                    var command = new SqlCommand(sql, connection);
                    command.Parameters.AddWithValue("@OrderId", orderId);
                    command.Parameters.AddWithValue("@ProductId", product.Id);
                    command.Parameters.AddWithValue("@ProductName", product.Name);
                    command.Parameters.AddWithValue("@ProductPrice", product.Price);
                    command.Parameters.AddWithValue("@Quantity", product.Quantity); 

                    command.ExecuteNonQuery();
                }
            }
        }

    }
}
