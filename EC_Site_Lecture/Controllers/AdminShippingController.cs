using System;
using System.Web.Mvc;
using EC_Site_Lecture.Models;
using EC_Site_Lecture.ScreenDTO;
using System.Collections.Generic;

namespace EC_Site_Lecture.Controllers
{
    public class AdminShippingController : Controller
    {
        public ActionResult Index()
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var model = new ShippingStatus(); 
            var list = model.GetAll();        

            System.Diagnostics.Debug.WriteLine("取得した件数: " + list.Count);

            return View("~/Views/AdminShippingList.aspx", list);
        }

        public ActionResult Edit(int id)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var model = new ShippingStatus();   
            var item = model.GetById(id);       

            if (item == null)
                return RedirectToAction("Index");

            Session["EditShipping"] = item;
            return Redirect("/Views/AdminShippingEdit.aspx");
        }

        [HttpPost]
        public ActionResult Update(ShippingStatusDTO dto)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            dto.ShippedDate = string.IsNullOrEmpty(Request["ShippedDate"]) ? (DateTime?)null : Convert.ToDateTime(Request["ShippedDate"]);
            dto.DeliveredDate = string.IsNullOrEmpty(Request["DeliveredDate"]) ? (DateTime?)null : Convert.ToDateTime(Request["DeliveredDate"]);

            var model = new ShippingStatus();     
            bool result = model.Update(dto);     

            return RedirectToAction("Index");
        }
    }
}
