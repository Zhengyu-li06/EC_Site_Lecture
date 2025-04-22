<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>

<%
    string idParam = Request["id"];
    int productId;
    ProductDto product = null;

    if (int.TryParse(idParam, out productId))
    {
        product = Product1.GetById(productId);
    }

    if (product == null)
    {
        product = new ProductDto
        {
            Name = "商品が見つかりませんでした。",
            Price = 0,
            Description = "",
            ImageUrl = ""
        };
    }
%>
<style>
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
             transition: opacity 0.2s;
         }

         .navbar a:hover {
             opacity: 0.8;
         }
</style>
<!DOCTYPE html>
<html>
<head runat="server">
    <title>商品詳細</title>
</head>
<body>
    <div class="navbar">
        <a href="/Views/Index.aspx">商品一覧</a>
        <a href="/Views/MyPage.aspx?userId=<%= Session["UserId"] %>">マイページ</a>
        <a href="/Views/Login.aspx">ログイン</a>
        <a href="/Views/Register.aspx">新規登録</a>
        <a href="/Views/Logout.aspx">ログアウト</a>
        <a href="/Views/Wishlist.aspx" class="wishlist-icon"><i class="fa fa-heart"></i></a>
    </div>
    <div style="max-width:600px; margin:auto; padding:20px;">
        <h1><%= product.Name %></h1>
        <p><strong>価格:</strong> ¥<%= product.Price %></p>
        <p><%= product.Description %></p>
        <img src="<%= product.ImageUrl %>" alt="商品画像" style="width:100%; border-radius:10px;" />
    </div>
</body>
</html>
