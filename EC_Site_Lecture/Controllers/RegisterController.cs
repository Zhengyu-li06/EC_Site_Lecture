using System.Security.Cryptography;
using System.Text;
using System.Web.Mvc;
using EC_Site_Lecture.DTO;
using EC_Site_Lecture.Models;

using System.Web.Mvc;
using System.Web.Security;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class RegisterController : Controller
    {
        private readonly UserRegist _userModel = new UserRegist();

        [HttpPost]
        public ActionResult Register(RegisterDTO dto)
        {
            bool isSuccess;
            string message = _userModel.Register(dto, out isSuccess);

            if (isSuccess)
            {
                
                return Redirect("/Views/Login.aspx?register=success");
            }
            else
            {
                
                return Redirect("/Views/Register.aspx?error=" + Server.UrlEncode(message));
            }
        }
    }
}


