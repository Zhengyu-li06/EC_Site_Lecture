<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ログアウト中...</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #4CAF50;
            padding: 12px 20px;
            display: flex;
            justify-content: flex-end;
            gap: 20px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            transition: opacity 0.2s;
        }

        .navbar a:hover {
            opacity: 0.8;
        }

        .logout-message {
            text-align: center;
            margin-top: 100px;
            color: #444;
        }
    </style>
</head>
<body>
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
