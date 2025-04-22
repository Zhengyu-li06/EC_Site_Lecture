using EC_Site_Lecture.DTO;
using EC_Site_Lecture.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using EC_Site_Lecture.Models;

namespace EC_Site_Lecture.Controllers
{
    public class OrderController : Controller
    {
        private readonly Order _orderModel = new Order();

       
        public ActionResult Checkout()
        {
            
            var sessionCart = Session["CartItems"] as List<CartDto>;

            if (sessionCart == null || !sessionCart.Any())
            {
               
                return RedirectToAction("Index", "Cart");
            }

            double totalAmount = (double)Session["TotalAmount"];

           
            ViewBag.TotalAmount = totalAmount;

            return View(sessionCart);  
        }

        
        [HttpPost]
        public ActionResult ConfirmPurchase(string customerName, string customerAddress, string customerPhone, double finalAmount)
        {
            var sessionCart = Session["CartItems"] as List<CartDto>;

            if (sessionCart == null || !sessionCart.Any())
            {
                return Redirect("~/Views/Index.aspx");
            }

            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 1;
            string customerEmail = _orderModel.GetUserEmail(userId);
            var cartProducts = _orderModel.GetCartProducts(sessionCart);
            //double totalAmount = cartProducts.Sum(p => p.Price * p.CartQuantity);
            double totalAmount = finalAmount;

            int orderId = _orderModel.InsertOrder(userId, customerName, customerAddress, customerPhone, customerEmail, totalAmount);
            _orderModel.InsertOrderItems(orderId, cartProducts);

            _orderModel.SendConfirmationEmail(customerEmail, cartProducts, totalAmount);

          
            Session["CartItems"] = null;
            Session["TotalAmount"] = null;

          
            if (Session["UserId"] != null)
            {
                var model = new ThankYouModel();
                model.ClearUserCart(userId);
            }

          
            if (Session["UserId"] != null)
            {
                return Redirect("~/Views/ThankYou.aspx");
            }
            else
            {
                return RedirectToAction("Login", "Account");
            }
        }


        public ActionResult ThankYou()
        {
            return View();  
        }
    }
}

