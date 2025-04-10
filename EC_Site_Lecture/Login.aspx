<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="YourNamespace.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ログイン</title>
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
            color: #333333;
        }

        .form-group {
            margin-bottom: 18px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: #555;
            font-size: 14px;
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
            border-color: #5b9bd5;
            outline: none;
        }

        .form-check {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            color: #333;
        }

        .btn {
            width: 100%;
            padding: 10px;
            font-size: 15px;
            background-color: #5b9bd5;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #4a8ac3;
        }

        #lblErrorMessage {
            margin-top: 12px;
            font-size: 14px;
            color: #d9534f;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <h2>ログイン</h2>

        <div class="form-group">
            <label for="txtUsernameOrEmail">ユーザー名またはメール</label>
            <asp:TextBox ID="txtUsernameOrEmail" runat="server" CssClass="form-control" />
        </div>

        <div class="form-group">
            <label for="txtPassword">パスワード</label>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" />
        </div>

        <div class="form-check">
            <asp:CheckBox ID="chkRememberMe" runat="server" />
            <label for="chkRememberMe">ログイン状態を保持する</label>
        </div>

        <asp:Button ID="btnLogin" runat="server" Text="ログイン" CssClass="btn" OnClick="btnLogin_Click" />

        <asp:Label ID="lblErrorMessage" runat="server" />
    </form>
</body>
</html>
