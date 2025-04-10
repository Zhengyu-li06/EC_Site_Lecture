using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Web.UI;
using static YourNamespace.Index;
using System.Configuration;

namespace YourNamespace
{
    public partial class Checkout : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Ensure cart is available and not empty
            if (Session["Cart"] != null && ((List<int>)Session["Cart"]).Count > 0)
            {
                List<int> cart = (List<int>)Session["Cart"];
                var cartProducts = GetCartProducts(cart);

                // Bind the cart items to the Repeater
                CartRepeater.DataSource = cartProducts;
                CartRepeater.DataBind();

                // Calculate and display the total price (consider quantity)
                double total = cartProducts.Sum(p => p.Price * p.Quantity);
                lblTotal.Text = total.ToString("F2");
            }
            else
            {
                // If no cart items are available, redirect to the product list
                Response.Redirect("Index.aspx");
            }
        }

        private List<Product> GetCartProducts(List<int> cartProductIds)
        {
            var cartProducts = new List<Product>();
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string productIds = string.Join(",", cartProductIds);
                string sql = $"SELECT ProductId, ProductName, Price FROM Products WHERE ProductId IN ({productIds})";

                var command = new SqlCommand(sql, connection);
                var reader = command.ExecuteReader();

                while (reader.Read())
                {
                    // Get the quantity of each product in the cart (count occurrences)
                    int quantity = cartProductIds.Count(id => id == Convert.ToInt32(reader["ProductId"]));

                    cartProducts.Add(new Product
                    {
                        Id = Convert.ToInt32(reader["ProductId"]),
                        Name = reader["ProductName"].ToString(),
                        Price = Convert.ToDouble(reader["Price"]),
                        Quantity = quantity
                    });
                }

                reader.Close();
            }

            return cartProducts;
        }

        protected void ConfirmPurchase_Click(object sender, EventArgs e)
        {
            // Ensure that cart is not null and contains items
            if (Session["Cart"] == null || ((List<int>)Session["Cart"]).Count == 0)
            {
                Response.Redirect("Index.aspx");
                return;
            }

            // Customer delivery information from the form
            string customerName = txtName.Text;
            string customerAddress = txtAddress.Text;
            string customerPhone = txtPhone.Text;
            string customerEmail = txtEmail.Text;

            // Retrieve cart products
            List<int> cartProductIds = (List<int>)Session["Cart"];
            var cartProducts = GetCartProducts(cartProductIds);

            // Calculate total price (consider quantity)
            double totalAmount = cartProducts.Sum(p => p.Price * p.Quantity);

            // Insert the order into the Orders table
            int orderId = InsertOrder(customerName, customerAddress, customerPhone, customerEmail, totalAmount);

            // Insert each cart item into the OrderItems table (consider quantity)
            InsertOrderItems(orderId, cartProducts);

            // Clear the cart after purchase
            Session["Cart"] = null;

            // Check if the user is logged in (assuming there is a "User" session variable)
            if (Session["UserId"] != null)
            {
                // Redirect to the Thank You page if logged in
                Response.Redirect("ThankYou.aspx");
            }
            else
            {
                // Optionally, show a message or redirect to login page if not logged in
                Response.Redirect("Login.aspx");
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
                               SELECT SCOPE_IDENTITY();"; // Returns the generated OrderId

                var command = new SqlCommand(sql, connection);
                command.Parameters.AddWithValue("@UserId", Session["UserId"] ?? 1); // Get UserId from session (or use 1 as default)
                command.Parameters.AddWithValue("@TotalAmount", totalAmount);
                command.Parameters.AddWithValue("@CustomerName", customerName);
                command.Parameters.AddWithValue("@CustomerAddress", customerAddress);
                command.Parameters.AddWithValue("@CustomerPhone", customerPhone);
                command.Parameters.AddWithValue("@CustomerEmail", customerEmail);
                command.Parameters.AddWithValue("@OrderDate", DateTime.Now);
                command.Parameters.AddWithValue("@Status", "Pending");

                orderId = Convert.ToInt32(command.ExecuteScalar()); // Get the generated OrderId
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
                    command.Parameters.AddWithValue("@Quantity", product.Quantity); // Use actual quantity from cart

                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
