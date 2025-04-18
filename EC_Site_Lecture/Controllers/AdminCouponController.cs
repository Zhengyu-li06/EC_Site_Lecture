using System.Web.Mvc;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class AdminCouponController : Controller
    {
        public ActionResult Index()
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var users = AdminCoupon.GetEligibleUsers();
            return View("~/Views/AdminCouponList.aspx", users);
        }
    }
}

