// 路径：Models/ThankYouModel.cs
using System.Configuration;
using System.Data.SqlClient;

namespace EC_Site_Lecture.Models
{
    public class ThankYouModel
    {
        public void ClearUserCart(int userId)
        {
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
