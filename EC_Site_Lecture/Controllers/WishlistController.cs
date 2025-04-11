using System;
using System.Web.Mvc;
using YourNamespace.Models;

public class WishlistController : Controller
{
    private readonly WishlistModel _wishlistModel = new WishlistModel();

   

    // 从愿望清单中删除某项
    public ActionResult RemoveFromWishlist(int productId)
    {
        int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;

        if (userId == 0)
        {
            return RedirectToAction("Login", "Account");
        }

        _wishlistModel.RemoveFromWishlist(userId, productId);

        return RedirectToAction("Index");
    }

    // 展示愿望清单页面
    public ActionResult Index()
    {
        int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;

        if (userId == 0)
        {
            return RedirectToAction("Login", "Account");
        }

        var wishlistItems = _wishlistModel.GetWishlistByUserId(userId);
        return View(wishlistItems);
    }
}
