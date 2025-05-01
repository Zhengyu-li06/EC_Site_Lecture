using System.Web.Mvc;
using System.Web.Routing;
using Microsoft.AspNet.FriendlyUrls;

namespace EC_Site_Lecture
{
    public static class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            var settings = new FriendlyUrlSettings();
            settings.AutoRedirectMode = RedirectMode.Permanent;
            routes.EnableFriendlyUrls(settings);

            routes.MapRoute(
                name: "MyPage",
                url: "MyPage",
                defaults: new { controller = "MyPage", action = "Index" }
            );

            routes.MapRoute(
               name: "Root",
               url: "",
               defaults: new { controller = "Product", action = "Index" }
           );

            routes.MapRoute(
                name: "Register", 
                url: "Register/Register", 
                defaults: new { controller = "Register", action = "Register" }  
            );

            
            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}
