
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
            public bool IsInWishlist { get; set; }  
        }


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
            }

            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                lblCartCount.Text = GetCartItemCount(userId).ToString();
            }
            else
            {
                lblCartCount.Text = "0";
            }
        }

        private int GetCartItemCount(int userId)
        {
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
            int itemCount = 0;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = "SELECT SUM(Quantity) FROM Cart WHERE UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    object result = cmd.ExecuteScalar();
                    itemCount = result != DBNull.Value ? Convert.ToInt32(result) : 0;
                }
            }

            return itemCount;
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void ddlSort_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadProducts();
        }

        protected void AddToCart_Click(object sender, CommandEventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            int productId = Convert.ToInt32(e.CommandArgument);

            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                
                string checkQuery = "SELECT COUNT(*) FROM Cart WHERE UserId = @UserId AND ProductId = @ProductId";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@UserId", userId);
                    checkCmd.Parameters.AddWithValue("@ProductId", productId);

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count == 0)
                    {
                        
                        string insertQuery = "INSERT INTO Cart (UserId, ProductId, Quantity) VALUES (@UserId, @ProductId, @Quantity)";
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@UserId", userId);
                            insertCmd.Parameters.AddWithValue("@ProductId", productId);
                            insertCmd.Parameters.AddWithValue("@Quantity", 1);
                            insertCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        
                        string updateQuery = "UPDATE Cart SET Quantity = Quantity + 1 WHERE UserId = @UserId AND ProductId = @ProductId";
                        using (SqlCommand updateCmd = new SqlCommand(updateQuery, conn))
                        {
                            updateCmd.Parameters.AddWithValue("@UserId", userId);
                            updateCmd.Parameters.AddWithValue("@ProductId", productId);
                            updateCmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            Response.Redirect(Request.Url.ToString());
        }
        protected void AddToWishlist_Click(object sender, CommandEventArgs e)
        {
            int userId = (Session["UserId"] != null) ? Convert.ToInt32(Session["UserId"]) : 0;  // 获取用户ID，若未登录则为0
            if (userId == 0)
            {
                // 如果未登录，可以选择跳转到登录页面或者处理
                Response.Redirect("Login.aspx");
                return;
            }

            int productId = Convert.ToInt32(e.CommandArgument);

            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 检查商品是否已经在用户的愿望清单中
                string checkQuery = "SELECT COUNT(*) FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId";
                using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                {
                    checkCmd.Parameters.AddWithValue("@UserId", userId);
                    checkCmd.Parameters.AddWithValue("@ProductId", productId);

                    int count = (int)checkCmd.ExecuteScalar();
                    if (count == 0)
                    {
                        // 商品不在愿望清单中，插入新记录
                        string insertQuery = "INSERT INTO Wishlist (UserId, ProductId) VALUES (@UserId, @ProductId)";
                        using (SqlCommand insertCmd = new SqlCommand(insertQuery, conn))
                        {
                            insertCmd.Parameters.AddWithValue("@UserId", userId);
                            insertCmd.Parameters.AddWithValue("@ProductId", productId);
                            insertCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        // 商品已在愿望清单中，删除它
                        string deleteQuery = "DELETE FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId";
                        using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn))
                        {
                            deleteCmd.Parameters.AddWithValue("@UserId", userId);
                            deleteCmd.Parameters.AddWithValue("@ProductId", productId);
                            deleteCmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            // 刷新页面或更新按钮状态
            Response.Redirect(Request.Url.ToString());
        }


        private void LoadProducts()
        {
            string keyword = txtSearch.Text.Trim();
            string sortOption = ddlSort.SelectedValue;
            var products = GetProducts(keyword, sortOption);
            ProductRepeater.DataSource = products;
            ProductRepeater.DataBind();
        }

        private List<Product> GetProducts(string keyword = "", string sortOption = "order")
        {
            var products = new List<Product>();
            string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;

            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                string sql = @"
                    SELECT 
                        p.ProductId, 
                        p.ProductName, 
                        p.Price, 
                        p.Description,
                        p.ImageUrl,
                        CASE 
                            WHEN w.ProductId IS NOT NULL THEN 1 
                            ELSE 0 
                        END AS IsInWishlist
                    FROM Products p
                    LEFT JOIN Wishlist w ON p.ProductId = w.ProductId AND w.UserId = @UserId
                ";


                List<string> conditions = new List<string>();
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
                    case "price_asc":
                        sql += " ORDER BY p.Price ASC";
                        break;
                    case "price_desc":
                        sql += " ORDER BY p.Price DESC";
                        break;
                    case "name_asc":
                        sql += " ORDER BY p.ProductName ASC";
                        break;
                    default:
                        sql += " ORDER BY p.ProductId DESC";
                        break;
                }

                using (SqlCommand command = new SqlCommand(sql, connection))
                {
                    command.Parameters.AddWithValue("@UserId", userId);
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
                            ImageUrl = reader["ImageUrl"].ToString(),  
                            IsInWishlist = Convert.ToInt32(reader["IsInWishlist"]) == 1
                        });

                    }
                    reader.Close();
                }
            }

            return products;
        }

    }
}
