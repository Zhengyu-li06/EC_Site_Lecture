<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>新規登録</title>
    <meta charset="utf-8" />
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/user.css" />
</head>
<body class="register-page">
    <form method="post" action="/Register/Register">
        <h2>新規登録</h2>

        <div class="form-group">
            <label for="Username">ユーザー名</label>
            <input type="text" id="Username" name="Username" class="form-control" required />
        </div>

        <div class="form-group">
            <label for="Email">メールアドレス</label>
            <input type="email" id="Email" name="Email" class="form-control" required />
        </div>

        <div class="form-group">
            <label for="Password">パスワード</label>
            <input type="password" id="Password" name="Password" class="form-control" required />
        </div>

        <div class="form-group">
            <label for="ConfirmPassword">確認用パスワード</label>
            <input type="password" id="ConfirmPassword" name="ConfirmPassword" class="form-control" required />
        </div>

        <button type="submit" class="btn">登録</button>

        <div class="login-link">
            <p>すでにアカウントをお持ちの方は <a href="/Views/Login.aspx">ログイン</a></p>
        </div>

        <% if (Request.QueryString["error"] != null) { %>
            <div class="error-message">
                <%= Request.QueryString["error"] %>
            </div>
        <% } %>
    </form>
</body>
</html>
