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
                // 确保用户已登录
                if (Session["UserId"] != null)
                {
                    BindCart();  // 绑定购物车内容
                }
                else
                {
                    Response.Redirect("Login.aspx");  // 如果未登录，重定向到登录页
                }
            }
        }

        protected void BindCart()
        {
            int userId = Convert.ToInt32(Session["UserId"]);  // 从 Session 获取用户 ID
            var cartItems = GetCartItemsFromDatabase(userId);  // 从数据库读取购物车商品
            CartRepeater.DataSource = cartItems;  // 绑定数据源到 Repeater 控件
            CartRepeater.DataBind();

            // 计算总金额并显示在 lblTotal 控件中
            double totalAmount = cartItems.Sum(item => item.Price * item.Quantity);  // 计算总金额
            lblTotal.Text = totalAmount.ToString("N0");  // 显示金额（格式化为千位分隔符）

            // 将购物车数据和合计金额存入 Session
            Session["CartItems"] = cartItems;      // 存储购物车商品数据
            Session["TotalAmount"] = totalAmount;  // 存储合计金额
        }



        private List<CartItem> GetCartItemsFromDatabase(int userId)
        {
            var items = new List<CartItem>();
            string connStr = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
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
                        items.Add(new CartItem
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

        // 处理购物车操作（增加、减少、删除）
        protected void CartRepeater_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int productId = int.Parse(e.CommandArgument.ToString());
            int userId = Convert.ToInt32(Session["UserId"]);
            string connStr = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.Connection = conn;

                if (e.CommandName == "Increase")
                {
                    // 增加商品数量
                    cmd.CommandText = @"
                        UPDATE Cart SET Quantity = Quantity + 1 
                        WHERE UserId = @UserId AND ProductId = @ProductId";
                }
                else if (e.CommandName == "Decrease")
                {
                    // 减少商品数量，确保最少为 1
                    cmd.CommandText = @"
                        UPDATE Cart SET Quantity = Quantity - 1 
                        WHERE UserId = @UserId AND ProductId = @ProductId AND Quantity > 1";
                }
                else if (e.CommandName == "Delete")
                {
                    // 删除商品
                    cmd.CommandText = @"
                        DELETE FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId";
                }

                cmd.Parameters.AddWithValue("@UserId", userId);
                cmd.Parameters.AddWithValue("@ProductId", productId);
                cmd.ExecuteNonQuery();
            }

            BindCart();  // 重新绑定购物车
        }

        // 跳转到结算页面
        protected void ProceedToCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Checkout.aspx");
        }
    }
}
