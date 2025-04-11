using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace YourNamespace
{
    public partial class ThankYou : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
           
            Session["CartItems"] = null;
            Session["TotalAmount"] = null;
            ClearUserCart();

            
        }

        
        private void ClearUserCart()
        {
            
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                string connectionString = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;

                using (SqlConnection conn = new SqlConnection(connectionString))
                {
                    conn.Open();
                    string sql = "DELETE FROM Cart WHERE UserId = @UserId";  
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}
