using System;
using System.Web.Mvc;
using EC_Site_Lecture.Models;

public class WishlistController : Controller
{
    private readonly WishlistModel _wishlistModel = new WishlistModel();

   
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

    public ActionResult Index()
    {
        int userId = Session["UserId"] != null ? Convert.ToInt32(Session["UserId"]) : 0;

        if (userId == 0)
        {
            return RedirectToAction("Login", "Account");
        }

        var wishlistItems = _wishlistModel.GetWishlistByUserId(userId);

        Session["WishlistItems"] = wishlistItems; 
        return Redirect("~/Views/Wishlist.aspx"); 
    }

}
