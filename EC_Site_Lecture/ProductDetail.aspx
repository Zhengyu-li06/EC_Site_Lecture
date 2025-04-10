<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductDetail.aspx.cs" Inherits="YourNamespace.ProductDetail" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>商品詳細</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #4CAF50;
            padding: 14px 20px;
            display: flex;
            justify-content: flex-end;
            gap: 20px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
        }

        h1 {
            color: #333;
        }

        img {
            max-width: 100%;
            border-radius: 8px;
            margin-top: 20px;
        }

        .price {
            color: #e91e63;
            font-size: 20px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <!-- Navigation Menu -->
    <div class="navbar">
        <a href="/Index.aspx">商品一覧</a>
        <a href="/MyPage.aspx">マイページ</a>
        <a href="/Login.aspx">ログイン</a>
        <a href="/Register.aspx">新規登録</a>
        <a href="/Logout.aspx">ログアウト</a>
    </div>

    <form id="form1" runat="server">
        <div class="container">
            <asp:Label ID="lblName" runat="server" Font-Size="X-Large" Font-Bold="True" />
            <br />
            <asp:Label ID="lblPrice" runat="server" CssClass="price" />
            <br /><br />
            <asp:Label ID="lblDescription" runat="server" />
            <br /><br />
            <asp:Image ID="imgProduct" runat="server" />
        </div>
    </form>
</body>
</html>
