<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ログイン</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
</head>
<body>
    <form method="post" action="/Admin/Login">
        <h2>管理者ログイン</h2>

        <div class="form-group">
            <label for="AdminUsername">ユーザー名またはメール</label>
            <input type="text" id="AdminUsername" name="UsernameOrEmail" class="form-control" required />
        </div>

        <div class="form-group">
            <label for="AdminPassword">パスワード</label>
            <input type="password" id="AdminPassword" name="Password" class="form-control" value="" required />
        </div>

        <button type="submit" class="btn">ログイン</button>

        <% if (!string.IsNullOrEmpty(Request["error"])) { %>
            <div id="lblErrorMessage">
                ユーザー名またはパスワードが間違っています。
            </div>
        <% } %>
    </form>
</body>
</html>