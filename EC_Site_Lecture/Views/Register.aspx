<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>新規登録</title>
    <meta charset="utf-8" />
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
        }

        form {
            max-width: 400px;
            margin: 60px auto;
            padding: 30px;
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }

        .btn {
            width: 100%;
            padding: 12px;
            font-size: 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #43a047;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .error-message {
            color: #e74c3c;
            font-size: 14px;
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
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
