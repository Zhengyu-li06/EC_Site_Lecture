using EC_Site_Lecture.Models;
using EC_Site_Lecture.Controllers;
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Web.UI;

namespace YourNamespace
{
    public partial class MyPage : System.Web.UI.Page
    {
        private MyPageController _controller = new MyPageController();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                int userId = (int)Session["UserId"];
                FillUserInfo(userId);
                LoadOrders(userId);
            }
        }

        private void FillUserInfo(int userId)
        {
            var user = _controller.GetUserById(userId);
            if (user != null)
            {
                lblUsername.Text = user.Username;
                lblEmail.Text = user.Email;
                lblDateCreated.Text = user.DateCreated.ToString("yyyy/MM/dd");

               
                txtUsername.Text = user.Username;
                txtEmail.Text = user.Email;
            }
        }

        protected void btnUpdateUser_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = (int)Session["UserId"];
                string newUsername = txtUsername.Text.Trim();

                if (!string.IsNullOrEmpty(newUsername))
                {
                    _controller.UpdateUsername(userId, newUsername);
                    FillUserInfo(userId);
                }
            }
        }

        protected void btnDeleteAccount_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                int userId = (int)Session["UserId"];
                _controller.DeleteUser(userId);

                Session.Abandon();
                Response.Redirect("Login.aspx");
            }
        }


        private void LoadOrders(int userId)
        {
            var orders = _controller.GetOrdersByUserId(userId);
            gvOrders.DataSource = orders;
            gvOrders.DataBind();
        }

        protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                DateTime orderDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "OrderDate"));
                e.Row.Cells[6].Text = orderDate.ToString("yyyy/MM/dd");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}
