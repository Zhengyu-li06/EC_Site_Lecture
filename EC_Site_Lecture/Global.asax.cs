using System;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;
using YourNamespace;

namespace EC_Site_Lecture
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            
            AreaRegistration.RegisterAllAreas();

            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}
