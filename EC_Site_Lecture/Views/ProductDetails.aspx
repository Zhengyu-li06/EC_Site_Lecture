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

<!DOCTYPE html>
<html>
<head runat="server">
    <title>商品詳細</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/product.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
</head>
<body class="product-detail-page">
    <!-- ナビゲーションバー -->
    <div class="navbar">
        <a href="/Views/Index.aspx">商品一覧</a>
        <a href="/Views/MyPage.aspx?userId=<%= Session["UserId"] %>">マイページ</a>
        <a href="/Views/Login.aspx">ログイン</a>
        <a href="/Views/Register.aspx">新規登録</a>
        <a href="/Views/Logout.aspx">ログアウト</a>
        <a href="/Views/Wishlist.aspx" class="wishlist-icon"><i class="fa fa-heart"></i></a>
    </div>

    <!-- 商品詳細 -->
    <div class="product-detail-container">
        <h1><%= product.Name %></h1>
        <p><strong>価格:</strong> ¥<%= product.Price %></p>
        <p><%= product.Description %></p>
        <img src="<%= product.ImageUrl %>" alt="商品画像" class="product-image" />
    </div>
</body>
</html>