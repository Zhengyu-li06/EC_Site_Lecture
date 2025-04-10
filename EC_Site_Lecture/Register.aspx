<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="YourNamespace.Register" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>新規登録</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
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

        h2 {
            text-align: center;
            margin-bottom: 24px;
            color: #4CAF50;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-size: 14px;
            font-weight: bold;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: #4CAF50;
            outline: none;
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
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #43a047;
        }

        #lblMessage {
            margin-top: 15px;
            font-size: 14px;
            color: #d9534f;
            text-align: center;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
        }

        .login-link a {
            color: #2196F3;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h2>新規登録</h2>

        <div class="form-group">
            <asp:Label AssociatedControlID="txtUsername" runat="server" Text="ユーザー名" />
            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" />
        </div>

        <div class="form-group">
            <asp:Label AssociatedControlID="txtEmail" runat="server" Text="メールアドレス" />
            <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" />
        </div>

        <div class="form-group">
            <asp:Label AssociatedControlID="txtPassword" runat="server" Text="パスワード" />
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
        </div>

        <div class="form-group">
            <asp:Label AssociatedControlID="txtConfirmPassword" runat="server" Text="確認用パスワード" />
            <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" />
        </div>

        <asp:Button ID="btnRegister" runat="server" Text="登録" CssClass="btn" OnClick="btnRegister_Click" />

        <asp:Label ID="lblMessage" runat="server" />

        <div class="login-link">
            <p>すでにアカウントをお持ちの方は <a href="/Login.aspx">ログイン</a></p>
        </div>
    </form>
</body>
</html>
