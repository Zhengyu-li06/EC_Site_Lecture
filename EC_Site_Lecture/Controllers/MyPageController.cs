using System;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Web.Mvc;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class MyPageController : Controller
    {
        private readonly MyPageModel model = new MyPageModel(); 

        [HttpPost]
        public ActionResult Update(string Username, string Email)
        {
            if (Session["UserId"] == null)
                return Redirect("/Views/Login.aspx");

            int userId = (int)Session["UserId"];
            model.UpdateUser(userId, Username, Email); 

            return Redirect("~/Views/MyPage.aspx");
        }

        [HttpPost]
        public ActionResult GenerateReport()
        {
            if (Session["UserId"] == null)
                return Redirect("/Views/Login.aspx");

            int userId = (int)Session["UserId"];

            var orderList = model.GetOrdersByUserId(userId);

            var sb = new StringBuilder();

            sb.Append('\uFEFF');
            sb.AppendLine("注文ID,注文日,合計金額,ステータス");

            foreach (var order in orderList)
            {
                sb.AppendLine($"{order.OrderId},{order.OrderDate:yyyy/MM/dd HH:mm},{order.TotalAmount},{EscapeCsv(order.Status)}");
            }

            byte[] csvBytes = Encoding.UTF8.GetBytes(sb.ToString());

            string filename = $"注文レポート_{DateTime.Now:yyyyMMdd_HHmmss}.csv";
            return File(csvBytes, "text/csv", filename);
        }

        private string EscapeCsv(string input)
        {
            if (string.IsNullOrEmpty(input)) return "";
            if (input.Contains(",") || input.Contains("\"") || input.Contains("\n"))
            {
                return $"\"{input.Replace("\"", "\"\"")}\"";
            }
            return input;
        }

    }
}
