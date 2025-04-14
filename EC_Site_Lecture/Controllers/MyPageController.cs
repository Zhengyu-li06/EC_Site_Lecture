using System;
using System.Web.Mvc;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class MyPageController : Controller
    {
        private readonly MyPageModel _model;

        public MyPageController()
        {
            _model = new MyPageModel();
        }

        // 显示用户信息和订单
        public ActionResult Index()
        {
            if (Session["UserId"] == null)
            {
                return RedirectToAction("Login", "Account");
            }

            int userId = (int)Session["UserId"];
            var user = _model.GetUserById(userId);
            var orders = _model.GetOrdersByUserId(userId);

            // 保存用户数据和订单数据到 Session
            Session["UserData"] = user;
            Session["Orders"] = orders;

            return View();  // 返回视图
        }

        // 更新用户名
        [HttpPost]
        public ActionResult UpdateUsername(string newUsername)
        {
            if (Session["UserId"] != null)
            {
                int userId = (int)Session["UserId"];
                _model.UpdateUsername(userId, newUsername);
            }

            return RedirectToAction("Index");
        }

        // 删除用户
        [HttpPost]
        public ActionResult DeleteUser()
        {
            if (Session["UserId"] != null)
            {
                int userId = (int)Session["UserId"];
                _model.DeleteUser(userId);

                Session.Abandon();
            }

            return RedirectToAction("Login", "Account");
        }

        // 注销用户
        public ActionResult Logout()
        {
            Session.Abandon();
            return RedirectToAction("Login", "Account");
        }
    }
}
