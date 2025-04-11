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


    public class CartController : Controller
    {
        private readonly CartModel cartModel = new CartModel();

       
        public ActionResult Index()
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return RedirectToAction("Login", "Account");
            }

            List<CartDto> cartItems = cartModel.GetCartItems(userId);
            double totalAmount = cartItems.Sum(item => item.Price * item.Quantity);

            ViewBag.TotalAmount = totalAmount;
            ViewBag.CartCount = cartModel.GetCartItemCount(userId);

            return View(cartItems);
        }

        [HttpPost]
        public ActionResult UpdateQuantity(int productId, string action)
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return RedirectToAction("Login", "Account");
            }

            cartModel.UpdateQuantity(userId, productId, action);

            return RedirectToAction("Index");
        }

        
        public ActionResult RemoveFromCart(int productId)
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return RedirectToAction("Login", "Account");
            }

            cartModel.UpdateQuantity(userId, productId, "Delete");

            return RedirectToAction("Index");
        }

        public ActionResult Checkout()
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return RedirectToAction("Login", "Account");
            }

            List<CartDto> cartItems = cartModel.GetCartItems(userId);
            double totalAmount = cartItems.Sum(item => item.Price * item.Quantity);

            ViewBag.TotalAmount = totalAmount;
            return View(cartItems);
        }
    }

}



