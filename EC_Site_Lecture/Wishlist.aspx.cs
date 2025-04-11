using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace YourNamespace
{
    public partial class Wishlist : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            int userId = Convert.ToInt32(Session["UserId"]);
            LoadWishlist(userId);
        }

        private void LoadWishlist(int userId)
        {
            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 确保查询的列名和数据库中的一致
                string query = "SELECT p.ProductId, p.ProductName, p.Price, p.ImageUrl " +
                               "FROM Products p " +
                               "INNER JOIN Wishlist w ON p.ProductId = w.ProductId " +
                               "WHERE w.UserId = @UserId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);
                    WishlistRepeater.DataSource = dt;
                    WishlistRepeater.DataBind();
                }
            }
        }

        // 处理从愿望清单中移除商品的事件
        protected void RemoveFromWishlist_Click(object sender, CommandEventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            int productId = Convert.ToInt32(e.CommandArgument);  // 获取商品 ID

            string connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                // 确保删除操作使用正确的列名
                string deleteQuery = "DELETE FROM Wishlist WHERE UserId = @UserId AND ProductId = @ProductId";
                using (SqlCommand deleteCmd = new SqlCommand(deleteQuery, conn))
                {
                    deleteCmd.Parameters.AddWithValue("@UserId", userId);
                    deleteCmd.Parameters.AddWithValue("@ProductId", productId);
                    deleteCmd.ExecuteNonQuery();
                }
            }

            // 删除商品后刷新愿望清单
            LoadWishlist(userId);
        }
    }
}
