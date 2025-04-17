using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using EC_Site_Lecture.DTO;
using EC_Site_Lecture.Models;
using EC_Site_Lecture.ScreenDTO;

namespace EC_Site_Lecture.Controllers
{
    public class AccountController : Controller
    {
        [HttpPost]
        public ActionResult Login(LoginDTO model)
        {
            if (!ModelState.IsValid)
            {
                return Redirect("/Login?error=1");
            }

            var user = EC_Site_Lecture.Models.User.GetByUsernameOrEmail(model.UsernameOrEmail);
            if (user != null && user.VerifyPassword(model.Password))
            {
                Session["UserId"] = user.UserId;
                Session["Username"] = user.Username;

                if (model.RememberMe)
                {
                    var ticket = new FormsAuthenticationTicket(
                        1, user.Username, DateTime.Now,
                        DateTime.Now.AddDays(30), true, user.UserId.ToString());

                    string encryptedTicket = FormsAuthentication.Encrypt(ticket);
                    var cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encryptedTicket)
                    {
                        HttpOnly = true,
                        Secure = Request.IsSecureConnection,
                        Path = FormsAuthentication.FormsCookiePath
                    };
                    Response.Cookies.Add(cookie);
                }

                return Redirect("/Views/Index.aspx");

            }

            return Redirect("/Views/Login?error=1");
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

           return Redirect("~/Views/Login.aspx");
        }

    }


}
