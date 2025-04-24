<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>管理者ログアウト</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
</head>
<body>
    <form id="form1" runat="server" method="post">
        <%
            if (!IsPostBack)
            {
                Session.Clear();
                Session.Abandon();
                FormsAuthentication.SignOut();

                if (Request.Cookies[".ASPXAUTH"] != null)
                {
                    var cookie = new HttpCookie(".ASPXAUTH");
                    cookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(cookie);
                }

                Response.Redirect("~/Views/AdminLogin.aspx");
            }
        %>

        <div class="logout-message">
            <h2>ログアウトしますか？</h2>
            <input type="submit" value="ログアウト実行" />
        </div>
    </form>
</body>
</html>
