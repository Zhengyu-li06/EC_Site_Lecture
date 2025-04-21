using EC_Site_Lecture.DTO;
using EC_Site_Lecture.Models;
using System.Collections.Generic;
using System.Web.Mvc;
using System.Linq;


namespace EC_Site_Lecture.Controllers
{
    public class CartController : Controller
    {
        private readonly CartModel cartModel = new CartModel();

        public ActionResult Index()
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return Redirect("/Views/Login.aspx");
            }

            List<CartDto> cartItems = cartModel.GetCartItems(userId);
            double totalAmount = cartItems.Sum(item => item.Price * item.Quantity);

            
            Session["CartItems"] = cartItems;
            Session["TotalAmount"] = totalAmount;

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

            
            List<CartDto> updatedCartItems = cartModel.GetCartItems(userId);
            Session["CartItems"] = updatedCartItems;

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

            List<CartDto> updatedCartItems = cartModel.GetCartItems(userId);
            Session["CartItems"] = updatedCartItems;

            return RedirectToAction("Index");
        }

        public ActionResult UpdateQuantity2(int productId, string action)
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return RedirectToAction("Login", "Account");
            }

            cartModel.UpdateQuantity(userId, productId, action);

           
            List<CartDto> updatedCartItems = cartModel.GetCartItems(userId);
            Session["CartItems"] = updatedCartItems;

            return Redirect("~/Views/Cart.aspx");
        }

        public ActionResult RemoveFromCart2(int productId)
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return RedirectToAction("Login", "Account");
            }

            cartModel.UpdateQuantity(userId, productId, "Delete");

          
            List<CartDto> updatedCartItems = cartModel.GetCartItems(userId);
            Session["CartItems"] = updatedCartItems;

            return Redirect("~/Views/Cart.aspx");
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

            
            Session["CartItems"] = cartItems;
            Session["TotalAmount"] = totalAmount;

            ViewBag.TotalAmount = totalAmount;
            return View(cartItems); 
        }

       
        public ActionResult ProceedToCheckout()
        {
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

            if (userId == 0)
            {
                return RedirectToAction("Login", "Account");
            }

            List<CartDto> cartItems = cartModel.GetCartItems(userId);
            double totalAmount = cartItems.Sum(item => item.Price * item.Quantity);

            Session["CartItems"] = cartItems;
            Session["TotalAmount"] = totalAmount;

            return Redirect("~/Views/Checkout.aspx");
        }

    }
}
