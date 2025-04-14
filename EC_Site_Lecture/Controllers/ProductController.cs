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
   

        public class ProductController : Controller
        {
            public ActionResult Index(string keyword = "", string sortOption = "order")
            {
                int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

                List<ProductDto> products = Product.GetAll(keyword, sortOption, userId);

                var cartModel = new CartModel();
                ViewBag.CartCount = cartModel.GetCartItemCount(userId);
                foreach (var product in products)
                {
                    product.CartQuantity = cartModel.GetCartItemCount(userId, product.Id);
                }

                ViewBag.Keyword = keyword;
                ViewBag.SortOption = sortOption;

             return View("~/Views/Index.aspx", products);

        }

        public ActionResult AddToCart(int productId, string keyword = "", string sortOption = "order")
            {
                int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

                if (userId == 0)
                {
                 return Redirect("/Views/Login.aspx");
            }

                var cartModel = new CartModel();
                cartModel.AddToCart(userId, productId);
                return RedirectToAction("Index", new { keyword, sortOption });
            }

        public ActionResult AddToWishlist(int productId, string keyword = "", string sortOption = "order")
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return Redirect("/Views/Login.aspx");
            }

            var wishlistModel = new WishlistModel();

            if (!wishlistModel.IsInWishlist(userId, productId))
            {
                wishlistModel.AddToWishlist(userId, productId);
            }
            else
            {
                wishlistModel.RemoveFromWishlist(userId, productId);
            }

            return RedirectToAction("Index", new { keyword, sortOption });
        }



    }




}



