<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="YourNamespace.Logout" %>

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

    <form id="form1" runat="server">
        <div class="logout-message">
            <h2>ログアウトしています...</h2>
        </div>
    </form>
</body>
</html>

