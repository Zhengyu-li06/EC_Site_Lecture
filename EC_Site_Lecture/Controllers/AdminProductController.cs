using System.Web.Mvc;
using EC_Site_Lecture.Models;
using EC_Site_Lecture.Tools;
using System.Collections.Generic;
using EC_Site_Lecture.ScreenDTO;

namespace EC_Site_Lecture.Controllers
{
    public class AdminProductController : Controller
    {
        public ActionResult Index(string keyword = "", string sortOption = "order")
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
            {
                return Redirect("/Views/AdminLogin.aspx");
            }

            var productModel = new AdminProduct();
            List<AdminProductDTO> products = productModel.GetAll(keyword, sortOption, 0);

            ViewBag.Keyword = keyword;
            ViewBag.SortOption = sortOption;

            return View("~/Views/AdminProductList.aspx", products);
        }

        [HttpPost]
        public ActionResult Add(AdminProductDTO dto)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
            {
                return Redirect("/Views/AdminLogin.aspx");
            }

            var model = new AdminProduct();
            bool success = model.Add(dto);

            if (success)
            {
                return RedirectToAction("Index");
            }
            else
            {
                return Redirect($"/Views/AdminProductAdd.aspx?error={ErrorCodes.VALIDATION_ERROR}");
            }
        }

        public ActionResult Edit(int id)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var model = new AdminProduct();
            var product = model.GetById(id);

            if (product == null)
                return RedirectToAction("Index");

            Session["EditProduct"] = product;
            return Redirect("/Views/AdminProductEdit.aspx");
        }

        [HttpPost]
        public ActionResult Update(AdminProductDTO dto)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var model = new AdminProduct();
            bool result = model.Update(dto);

            return RedirectToAction("Index");
        }
    }
}

