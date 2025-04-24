using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using EC_Site_Lecture.Models;
using EC_Site_Lecture.ScreenDTO;
using EC_Site_Lecture.Tools;

namespace EC_Site_Lecture.Controllers.Admin
{
    public class AdminController : Controller
    {
        [HttpPost]
        public ActionResult Login(AdminLoginDTO model)
        {
            if (!ModelState.IsValid)
            {
                return Redirect($"/Views/AdminLogin?error={ErrorCodes.VALIDATION_ERROR}");
            }

            var admin = new AdminUser().GetByUsernameOrEmail(model.UsernameOrEmail);
            if (admin != null && admin.IsActive && admin.VerifyPassword(model.Password))
            {
                Session["AdminId"] = admin.Id;
                Session["AdminUsername"] = admin.Username;
                Session["IsAdmin"] = true;

                return RedirectToAction("Index", "AdminProduct");
            }

            return Redirect($"/Views/AdminLogin?error={ErrorCodes.LOGIN_FAILED}");
        }

        public ActionResult Logout()
        {
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();

            if (Request.Cookies[".ASPXAUTH"] != null)
            {
                var cookie = new HttpCookie(".ASPXAUTH");
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }

            return Redirect("/Views/AdminLogin.aspx");
        }
    }
}

