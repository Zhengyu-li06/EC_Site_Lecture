using System;
using System.Configuration;
using System.Data.SqlClient;
namespace YourNamespace
{
    public partial class ProductDetail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string id = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(id))
                {
                    LoadProduct(id);
                }
                else
                {
                    lblName.Text = "無効な商品IDです。";
                }
            }
        }

        private void LoadProduct(string id)
        {
            string connectionString = "Server=DESKTOP-889CVKI;Database=EC_Site_Lecture;Integrated Security=True;";
            
            string query = "SELECT ProductName, Price, Description, ImageUrl FROM Products WHERE ProductId = @Id";

            using (SqlConnection con = new SqlConnection(connectionString))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.AddWithValue("@Id", id);
                con.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                   
                    lblName.Text = reader["ProductName"].ToString();  
                    lblPrice.Text = "¥" + reader["Price"].ToString();
                    lblDescription.Text = reader["Description"].ToString(); 
                    imgProduct.ImageUrl = reader["ImageUrl"].ToString();
                    imgProduct.AlternateText = reader["ProductName"].ToString();  
                }
                else
                {
                    lblName.Text = "商品が見つかりませんでした。";
                }
            }
        }
    }
}
