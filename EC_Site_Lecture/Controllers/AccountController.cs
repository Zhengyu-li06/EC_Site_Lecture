using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using YourNamespace.DTO;
using YourNamespace.Models;
using YourNamespace.ScreenDTO;

namespace YourNamespace.Controllers
{
    public class AccountController : Controller
    {
        [HttpPost]
        public ActionResult Login(LoginDTO model)
        {
            if (!ModelState.IsValid)
            {
                return Redirect("/Login.aspx?error=1");
            }

            var user = YourNamespace.Models.User.GetByUsernameOrEmail(model.UsernameOrEmail);
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

            return Redirect("/Views/Login.aspx?error=1");
        }


        


    }


}
