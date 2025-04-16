using System.Web;
using System.Web.Mvc;
using EC_Site_Lecture.Models;

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

            
            List<AdminProductDTO> products = AdminProduct.GetAll(keyword, sortOption, 0);

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

            bool success = AdminProduct.Add(dto);
            if (success)
            {
                return RedirectToAction("Index"); // 商品一覧に戻る
            }
            else
            {
                return Redirect("/Views/AdminProductAdd.aspx?error=1");
            }
        }
        public ActionResult Edit(int id)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
                return Redirect("/Views/AdminLogin.aspx");

            var product = AdminProduct.GetById(id);
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

            bool result = AdminProduct.Update(dto);
            return RedirectToAction("Index");
        }

    }
}
