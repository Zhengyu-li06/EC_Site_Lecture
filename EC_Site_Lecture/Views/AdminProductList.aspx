<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>商品一覧（管理者）</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .search-filter-bar {
            display: flex;
            justify-content: center;
            gap: 12px;
            margin-bottom: 30px;
        }

        .search-filter-bar input,
        .search-filter-bar select,
        .search-filter-bar button {
            padding: 10px;
            font-size: 14px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        .search-filter-bar button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }

        .search-filter-bar button:hover {
            background-color: #45a049;
        }

        .product-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }

        .product-card {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 20px;
            width: 260px;
            text-align: center;
        }

        .product-card:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }

        .product-card h3 {
            font-size: 18px;
            margin-bottom: 8px;
            color: #333;
        }

        .product-card p {
            font-size: 14px;
            margin: 4px 0;
            color: #555;
        }

        .btn-edit {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 16px;
            background-color: #5b9bd5;
            color: white;
            border-radius: 6px;
            text-decoration: none;
        }

        .btn-edit:hover {
            background-color: #4a8ac3;
        }

        .top-bar {
            text-align: center;
            margin-bottom: 20px;
        }

        .top-bar a {
            padding: 10px 20px;
            background-color: #007acc;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        .top-bar a:hover {
            background-color: #005c99;
        }
        .navbar {
            background-color: #007acc;
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h1 {
            margin: 0;
            font-size: 22px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: bold;
        }

        .navbar a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>

    <div class="navbar">
        <h1>📋 管理者メニュー</h1>
        <div>
            <a href="/Views/AdminProductList.aspx">商品管理</a>
            <a href="/Views/AdminShippingList.aspx">発送管理</a>
            <a href="/Views/AdminCouponList.aspx">クーポン管理</a>
        </div>
    </div>
        <h2>商品一覧（管理者）</h2>
    <div class="top-bar">
        <a href="/Views/AdminProductAdd.aspx">＋ 商品追加</a>
    </div>

    <!-- 検索 + ソート -->
<form method="get" action="/AdminProduct/Index">

        <div class="search-filter-bar">
            <input type="text" name="keyword" placeholder="キーワード検索" value="<%= Request["keyword"] %>" />
            <select name="sortOption">
                <option value="order" <%= Request["sortOption"] == "order" ? "selected" : "" %>>並び順（新しい順）</option>
                <option value="price_desc" <%= Request["sortOption"] == "price_desc" ? "selected" : "" %>>価格が高い順</option>
                <option value="price_asc" <%= Request["sortOption"] == "price_asc" ? "selected" : "" %>>価格が安い順</option>
                <option value="name_asc" <%= Request["sortOption"] == "name_asc" ? "selected" : "" %>>名前順</option>
            </select>
            <button type="submit">検索</button>
        </div>
    </form>

   <!-- 商品カード -->
<div class="product-container">
    <%
        var keyword = Request["keyword"] ?? "";
        var sortOption = Request["sortOption"] ?? "order";

        var products = EC_Site_Lecture.Models.AdminProduct.GetAll(keyword, sortOption);

        if (products != null && products.Count > 0)
        {
            foreach (var item in products)
            {
    %>
    <div class="product-card">
        <% if (item.ImageData != null && item.ImageData.Length > 0) { %>
            <img src="data:image/png;base64,<%= Convert.ToBase64String(item.ImageData) %>" 
                 alt="商品画像" 
                 style="max-width: 100%; height: auto; border-radius: 8px; margin-bottom: 10px;" />
        <% } else { %>
            <img src="<%= item.ImageUrl %>" 
                 alt="商品画像" 
                 style="max-width: 100%; height: auto; border-radius: 8px; margin-bottom: 10px;" />
        <% } %>

        <h3><%= item.Name %></h3>
        <p>価格：¥<%= item.Price %></p>
        <p>在庫：<%= item.Quantity %></p>

        <% if (item.IsDiscontinued) { %>
            <p style="color: red; font-weight: bold;">販売中止</p>
        <% } else if (item.IsNewArrival) { %>
            <p style="color: green; font-weight: bold;">新入荷</p>
        <% } %>

        <a href="/AdminProduct/Edit?id=<%= item.Id %>" class="btn-edit">編集</a>
    </div>
    <%
            }
        }
        else
        {
    %>
        <p style="text-align: center;">商品が見つかりませんでした。</p>
    <%
        }
    %>
</div>

</body>
</html>
