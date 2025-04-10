using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using static YourNamespace.Index;
using System.Configuration;
using System.Linq;
using System.Web.UI.WebControls;

namespace YourNamespace
{
    public partial class Cart : System.Web.UI.Page
    {
        public class CartItem
        {
            public int ProductId { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string ImageUrl { get; set; }
            public double Price { get; set; }
            public int Quantity { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Cart"] != null)
                {
                    BindCart();
                }
                else
                {
                    Response.Redirect("Index.aspx");
                }
            }
        }

        private void BindCart()
        {
            List<int> cart = Session["Cart"] as List<int> ?? new List<int>();
            var cartItems = GetCartItems(cart);
            CartRepeater.DataSource = cartItems;
            CartRepeater.DataBind();
        }

        private List<CartItem> GetCartItems(List<int> productIds)
        {
            var items = new List<CartItem>();
            string connStr = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                foreach (int id in productIds.Distinct())
                {
                    string sql = "SELECT ProductId, ProductName, Price, Description, ImageUrl FROM Products WHERE ProductId = @id";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@id", id);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int count = productIds.Count(pid => pid == id);
                            items.Add(new CartItem
                            {
                                ProductId = id,
                                Name = reader["ProductName"].ToString(),
                                Price = double.TryParse(reader["Price"].ToString(), out var price) ? price : 0,
                                Description = reader["Description"].ToString(),
                                ImageUrl = reader["ImageUrl"].ToString(),
                                Quantity = count
                            });
                        }
                    }
                }
            }

            return items;
        }

        protected void CartRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = int.Parse(e.CommandArgument.ToString());
            List<int> cart = Session["Cart"] as List<int> ?? new List<int>();

            if (e.CommandName == "Increase")
            {
                cart.Add(productId);
            }
            else if (e.CommandName == "Decrease")
            {
                if (cart.Contains(productId))
                {
                    cart.Remove(productId);
                }
            }
            else if (e.CommandName == "Delete")
            {
                cart.RemoveAll(id => id == productId);
            }

            Session["Cart"] = cart;
            BindCart();
        }

        protected void ProceedToCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Checkout.aspx");
        }
    }
}
