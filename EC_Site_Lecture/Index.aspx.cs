
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;


namespace YourNamespace
{
    public partial class Index : System.Web.UI.Page
    {
        public class Product
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public string ImageUrl { get; set; }
            public double Price { get; set; }
            public double Quantity { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts(); // 初始加载
            }

            // 更新购物车数量
            if (Session["Cart"] != null)
            {
                List<int> cart = Session["Cart"] as List<int>;
                lblCartCount.Text = cart.Count.ToString();
            }
            else
            {
                lblCartCount.Text = "0";
            }
        }

        // 搜索按钮点击事件
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        // 排序下拉框变更事件
        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        // 添加到购物车按钮点击事件
        protected void AddToCart_Click(object sender, CommandEventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int productId = Convert.ToInt32(e.CommandArgument);

            List<int> cart = Session["Cart"] as List<int>;
            if (cart == null)
            {
                cart = new List<int>();
                Session["Cart"] = cart;
            }

            if (!cart.Contains(productId))
            {
                cart.Add(productId);
            }

            Response.Redirect(Request.Url.ToString());
        }

        // 加载商品（支持搜索和排序）
        private void LoadProducts()
        {
            string keyword = txtSearch.Text.Trim();
            string sortOption = ddlSort.SelectedValue;
            var products = GetProducts(keyword, sortOption);
            ProductRepeater.DataSource = products;
            ProductRepeater.DataBind();
        }

        // 获取商品数据（支持搜索和排序）
        private List<Product> GetProducts(string keyword = "", string sortOption = "order")
        {
            var products = new List<Product>();
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = "SELECT ProductId, ProductName, Price, Description FROM Products";
                List<string> conditions = new List<string>();

                // 添加搜索条件
                if (!string.IsNullOrEmpty(keyword))
                {
                    conditions.Add("(ProductName LIKE @keyword OR Description LIKE @keyword)");
                }

                if (conditions.Count > 0)
                {
                    sql += " WHERE " + string.Join(" AND ", conditions);
                }

                // 添加排序条件
                switch (sortOption)
                {
                    case "price_asc":
                        sql += " ORDER BY Price ASC";
                        break;
                    case "price_desc":
                        sql += " ORDER BY Price DESC";
                        break;
                    case "name_asc":
                        sql += " ORDER BY ProductName ASC";
                        break;
                    default:
                        sql += " ORDER BY ProductId DESC"; // 默认按商品ID降序
                        break;
                }

                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    if (!string.IsNullOrEmpty(keyword))
                    {
                        command.Parameters.AddWithValue("@keyword", "%" + keyword + "%");
                    }

                    SqlDataReader reader = command.ExecuteReader();
                    while (reader.Read())
                    {
                        products.Add(new Product
                        {
                            Id = Convert.ToInt32(reader["ProductId"]),
                            Name = reader["ProductName"].ToString(),
                            Price = double.TryParse(reader["Price"].ToString(), out var price) ? price : 0,
                            Description = reader["Description"].ToString(),
                            ImageUrl = "https://via.placeholder.com/300"
                        });
                    }
                    reader.Close();
                }
            }

            return products;
        }
    }
}
