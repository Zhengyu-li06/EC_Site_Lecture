<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>管理者ログアウト</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
        }

        .logout-message {
            text-align: center;
            margin-top: 100px;
            color: #444;
        }

        .logout-message h2 {
            margin-bottom: 20px;
        }

        .logout-message input {
            padding: 10px 20px;
            background-color: #5b9bd5;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .logout-message input:hover {
            background-color: #4a8ac3;
        }
    </style>
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