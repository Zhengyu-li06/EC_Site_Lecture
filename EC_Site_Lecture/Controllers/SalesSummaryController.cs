using System.Web.Mvc;
using EC_Site_Lecture.Models;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System;
using System.Text;

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


        public ActionResult ExportExcel()
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var summary = new SalesSummaryModel().GetSalesSummary();

            var sb = new StringBuilder();

            sb.Append('\uFEFF');

            sb.AppendLine("商品名,販売数（合計）,売上金額（合計）");
            foreach (var item in summary)
            {
                sb.AppendLine($"{EscapeCsv(item.ProductName)},{item.TotalQuantity},{item.TotalSales}");
            }

            byte[] csvBytes = Encoding.UTF8.GetBytes(sb.ToString());

            return File(csvBytes, "text/csv", "売上集計.csv");
        }

        private string EscapeCsv(string input)
        {
            if (input.Contains(",") || input.Contains("\"") || input.Contains("\n"))
            {
                return $"\"{input.Replace("\"", "\"\"")}\"";
            }
            return input;
        }

    }
}
