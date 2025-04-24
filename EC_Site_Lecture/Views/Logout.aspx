<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ログアウト中...</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/user.css" />
</head>
<body class="logout-page">
    <!-- ナビゲーションバー -->
    <div class="navbar">
        <a href="/Login.aspx">ログイン</a>
        <a href="/Register.aspx">新規登録</a>
        <a href="/Logout.aspx">ログアウト</a>
    </div>

    <form id="form1" runat="server" method="post">
        <%
            if (IsPostBack)
            {
                Session.Clear();
                Session.Abandon();
                System.Web.Security.FormsAuthentication.SignOut();

                if (Request.Cookies[".ASPXAUTH"] != null)
                {
                    var cookie = new HttpCookie(".ASPXAUTH");
                    cookie.Expires = DateTime.Now.AddDays(-1);
                    Response.Cookies.Add(cookie);
                }

                Response.Redirect("~/Views/Index.aspx");
            }
        %>

        <div class="logout-message">
            <h2>ログアウトしています...</h2>
            <input type="submit" value="ログアウト実行" />
        </div>
    </form>
</body>
</html>