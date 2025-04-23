using System;
using System.Diagnostics;
using System.IO;
using System.Web.Mvc;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class MyPageController : Controller
    {
        private readonly MyPageModel model = new MyPageModel(); // ✅ 提前实例化

        [HttpPost]
        public ActionResult Update(string Username, string Email)
        {
            if (Session["UserId"] == null)
                return Redirect("/Views/Login.aspx");

            int userId = (int)Session["UserId"];
            model.UpdateUser(userId, Username, Email); // ✅ 使用字段

            return Redirect("~/Views/MyPage.aspx");
        }

        [HttpPost]
        public ActionResult GenerateReport()
        {
            if (Session["UserId"] == null)
                return Redirect("/Views/Login.aspx");

            int userId = (int)Session["UserId"];

            var orderList = model.GetOrdersByUserId(userId); // ✅ 使用字段
            string orderJson = Newtonsoft.Json.JsonConvert.SerializeObject(orderList);

            string tempJson = Path.Combine(Path.GetTempPath(), $"order_{userId}.json");
            System.IO.File.WriteAllText(tempJson, orderJson);

            string pythonExe = Server.MapPath("~/Tools/Python/Python313/python.exe");
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

                if (!System.IO.File.Exists(outputPath))
                {
                    throw new FileNotFoundException("Excel ファイルが生成されませんでした。Python スクリプトに問題がある可能性があります。");
                }

                System.Diagnostics.Debug.WriteLine(output);
            }

            byte[] fileBytes = System.IO.File.ReadAllBytes(outputPath);
            return File(fileBytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "注文レポート.xlsx");
        }
    }
}
