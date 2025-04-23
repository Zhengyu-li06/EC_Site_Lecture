using System.Web.Mvc;
using EC_Site_Lecture.Models;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System;

namespace EC_Site_Lecture.Controllers
{
    public class SalesSummaryController : Controller
    {
        public ActionResult Index()
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            List<SalesSummaryItem> summary = new SalesSummaryModel().GetSalesSummary();

            return View("~/Views/SalesSummary.aspx", summary);
        }


        [HttpPost]
        public ActionResult ExportExcel()
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var summary = new SalesSummaryModel().GetSalesSummary();

            string json = Newtonsoft.Json.JsonConvert.SerializeObject(summary);
            string jsonPath = Path.Combine(Path.GetTempPath(), $"sales_summary_{DateTime.Now:yyyyMMddHHmmss}.json");
            System.IO.File.WriteAllText(jsonPath, json);


            string pythonExe = Server.MapPath("~/Tools/Python/Python313/python.exe");
            string scriptPath = Server.MapPath("~/generate_sales_summary.py"); 
            string excelPath = Path.Combine(Path.GetTempPath(), $"sales_summary_{DateTime.Now:yyyyMMdd_HHmmss}.xlsx");

            var psi = new ProcessStartInfo
            {
                FileName = pythonExe,
                Arguments = $"\"{scriptPath}\" \"{jsonPath}\" \"{excelPath}\"",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                UseShellExecute = false,
                CreateNoWindow = true
            };

            using (var process = Process.Start(psi))
            {
                string output = process.StandardOutput.ReadToEnd();
                string error = process.StandardError.ReadToEnd();
                process.WaitForExit();

                if (!string.IsNullOrEmpty(error))
                    throw new Exception("Python Error: " + error);
            }

            byte[] fileBytes = System.IO.File.ReadAllBytes(excelPath);
            return File(fileBytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "売上集計.xlsx");
        }

    }
}
