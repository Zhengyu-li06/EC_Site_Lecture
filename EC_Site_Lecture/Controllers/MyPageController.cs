
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
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

        [HttpPost]
   
        public ActionResult GenerateReport()
        {
            if (Session["UserId"] == null)
                return Redirect("/Views/Login.aspx");

            int userId = (int)Session["UserId"];

            var orderList = new MyPageModel().GetOrdersByUserId(userId);

            // 🐍 传给 Python 脚本的 JSON
            string orderJson = Newtonsoft.Json.JsonConvert.SerializeObject(orderList);

            // 🔒 临时写入 JSON 文件
            string tempJson = Path.Combine(Path.GetTempPath(), $"order_{userId}.json");
            System.IO.File.WriteAllText(tempJson, orderJson);

            string pythonExe = @"C:\Users\Li Zhengyu\AppData\Local\Programs\Python\Python313\python.exe";
            string scriptPath = Server.MapPath("~/generate_report.py");

            string outputPath = Path.Combine(Path.GetTempPath(), $"report_{userId}_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx");

            var psi = new ProcessStartInfo
            {
                FileName = pythonExe,
                Arguments = $"\"{scriptPath}\" \"{tempJson}\" \"{outputPath}\"",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using (var process = Process.Start(psi))
            {
                string error = process.StandardError.ReadToEnd();
                string output = process.StandardOutput.ReadToEnd();
                process.WaitForExit();

                if (!string.IsNullOrEmpty(error))
                {
                    throw new Exception("Python エラー: " + error);
                }
            }


            byte[] fileBytes = System.IO.File.ReadAllBytes(outputPath);
            return File(fileBytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "注文レポート.xlsx");
        }

    }
}
