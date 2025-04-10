using System;
using System.Web;
using System.Web.Security;

namespace YourNamespace
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear session and authentication
            Session.Clear();
            Session.Abandon();
            FormsAuthentication.SignOut();

            // Optional: Clear authentication cookie manually
            if (Request.Cookies[".ASPXAUTH"] != null)
            {
                var cookie = new HttpCookie(".ASPXAUTH");
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }

            // Redirect to login page
            Response.Redirect("~/Login.aspx");
        }
    }
}
