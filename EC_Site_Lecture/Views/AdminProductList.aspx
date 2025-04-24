<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>商品一覧（管理者）</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
    <link rel="stylesheet" href="/CSS/adminproduct.css" />
</head>
<body class="admin-product-list-page">
    <div class="navbar">
        <h1>管理者メニュー</h1>
        <div>
            <a href="/Views/AdminProductList.aspx">商品管理</a>
            <a href="/Views/AdminShippingList.aspx">発送管理</a>
            <a href="/Views/AdminCouponList.aspx">クーポン管理</a>
            <a href="/Views/SalesSummary.aspx">売上集計</a>
        </div>
    </div>

    <h2>商品一覧（管理者）</h2>

    <div class="top-bar">
        <a href="/Views/AdminProductAdd.aspx">＋ 商品追加</a>
    </div>

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

    <div class="product-container">
        <%
            var keyword = Request["keyword"] ?? "";
            var sortOption = Request["sortOption"] ?? "order";
            var adminProductService = new EC_Site_Lecture.Models.AdminProduct();
            var products = adminProductService.GetAll(keyword, sortOption, 0);

            if (products != null && products.Count > 0)
            {
                foreach (var item in products)
                {
        %>
            <div class="product-card">
                <% if (item.ImageData != null && item.ImageData.Length > 0) { %>
                    <img src="data:image/png;base64,<%= Convert.ToBase64String(item.ImageData) %>" alt="商品画像" style="max-width: 100%; height: auto; border-radius: 8px; margin-bottom: 10px;" />
                <% } else { %>
                    <img src="<%= item.ImageUrl %>" alt="商品画像" style="max-width: 100%; height: auto; border-radius: 8px; margin-bottom: 10px;" />
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