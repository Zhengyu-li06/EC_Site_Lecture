
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Mvc;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class MyPageController : Controller
    {
        [HttpPost]
        public ActionResult Update(string Username, string Email)
        {
            if (Session["UserId"] == null)
                return Redirect("/Views/Login.aspx");

            int userId = (int)Session["UserId"];

            string connStr = ConfigurationManager.ConnectionStrings["EC_Site_LectureConnectionString"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = "UPDATE Users SET Username = @Username, Email = @Email WHERE UserId = @UserId";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Username", Username);
                    cmd.Parameters.AddWithValue("@Email", Email);
                    cmd.Parameters.AddWithValue("@UserId", userId);
                    cmd.ExecuteNonQuery();
                }
            }

            return Redirect("~/Views/MyPage.aspx");
        }

    }
}
