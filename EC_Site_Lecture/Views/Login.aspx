<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>ログイン</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/user.css" />
</head>
<body class="login-page">
    <form method="post" action="/Account/Login" class="login-form">
        <h2>ログイン</h2>

        <div class="form-group">
            <label for="UsernameOrEmail">ユーザー名またはメール</label>
            <input type="text" id="UsernameOrEmail" name="UsernameOrEmail" class="form-control" required />
        </div>

        <div class="form-group">
            <label for="Password">パスワード</label>
            <input type="password" id="Password" name="Password" class="form-control" required />
        </div>

        <div class="form-check">
            <input type="checkbox" id="RememberMe" name="RememberMe" />
            <label for="RememberMe">ログイン状態を保持する</label>
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