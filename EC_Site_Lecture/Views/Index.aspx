<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>商品一覧</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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
             transition: opacity 0.2s;
         }

         .navbar a:hover {
             opacity: 0.8;
         }

         .main-content {
             padding: 20px;
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
             width: 300px;
             transition: transform 0.2s ease, box-shadow 0.2s ease;
             text-align: center;  
         }

         .product-card:hover {
             transform: translateY(-5px);
             box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
         }

         .product-card h2 {
             font-size: 20px;
             color: #333;
             margin-bottom: 10px;
         }

         .product-card p {
             font-size: 14px;
             color: #555;
             margin-bottom: 8px;
         }

         .product-card img {
             width: 100%;
             height: auto;
             border-radius: 8px;
             margin-top: 10px;
         }

         .cart-summary {
             margin-top: 20px;
             text-align: center;
             font-size: 16px;
         }

         .add-to-cart-button,
         .add-to-wishlist-button {
             background-color: #4CAF50;
             color: white;
             padding: 10px 20px;
             border: none;
             border-radius: 8px;
             cursor: pointer;
             margin-top: 10px;
             transition: background-color 0.3s;
             font-size: 14px;
         }

         .add-to-cart-button:disabled,
         .add-to-wishlist-button:disabled {
             background-color: #ccc;
             cursor: not-allowed;
         }

         .add-to-wishlist-button {
             background-color: #FF4081; 
             margin-top: 10px;
         }

         .search-filter-bar {
             display: flex;
             justify-content: center;
             align-items: center;
             gap: 12px;
             margin-bottom: 30px;
             flex-wrap: wrap;
         }
         .add-to-wishlist-button {
             background-color: #FF4081;  
             margin-top: 10px;
             font-size: 20px;
             padding: 10px;
         }

         .add-to-wishlist-button:enabled {
             cursor: pointer;
         }

         .add-to-wishlist-button:disabled {
             cursor: not-allowed;
             background-color: #ccc;
         }

         .search-box {
             padding: 10px;
             border: 1px solid #ccc;
             border-radius: 8px;
             width: 280px;
             font-size: 14px;
         }

         .search-button {
             background-color: #4CAF50;
             color: white;
             padding: 10px 16px;
             border: none;
             border-radius: 8px;
             cursor: pointer;
             font-weight: bold;
             transition: background-color 0.2s;
         }

         .search-button:hover {
             background-color: #45a049;
         }

         .sort-dropdown {
             padding: 10px;
             border: 1px solid #ccc;
             border-radius: 8px;
             font-size: 14px;
             background-color: #fff;
             cursor: pointer;
         }


         .wishlist-icon {
             font-size: 24px;
             color: white;
             cursor: pointer;
             text-decoration: none;
         }

         .wishlist-icon:hover {
             opacity: 0.8;
         }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="/Index.aspx">商品一覧</a>
        <a href="/MyPage.aspx">マイページ</a>
        <a href="/Login.aspx">ログイン</a>
        <a href="/Register.aspx">新規登録</a>
        <a href="/Logout.aspx">ログアウト</a>
        <a href="/Wishlist.aspx" class="wishlist-icon"><i class="fa fa-heart"></i></a>
    </div>

    <!-- 検索フォーム -->
    <form method="get" action="/Product/Index">
        <div class="search-filter-bar">
            <input type="text" name="keyword" placeholder="キーワードで検索" value="<%= Request["keyword"] %>" />
            <button type="submit">検索</button>

            <select name="sortOption" onchange="this.form.submit()">
                <option value="order" <%= Request["sortOption"] == "order" ? "selected" : "" %>>表示順（デフォルト）</option>
                <option value="price_desc" <%= Request["sortOption"] == "price_desc" ? "selected" : "" %>>価格が高い順</option>
                <option value="price_asc" <%= Request["sortOption"] == "price_asc" ? "selected" : "" %>>価格が安い順</option>
                <option value="name_asc" <%= Request["sortOption"] == "name_asc" ? "selected" : "" %>>名前順（A→Z）</option>
            </select>
        </div>
    </form>

    <!-- 商品 -->
    <div class="main-content">
        <div class="product-container">
            <% 
                var keyword = Request["keyword"] ?? "";
                var sortOption = Request["sortOption"] ?? "order";
                int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;

                var products = YourNamespace.Models.Product.GetAll(keyword, sortOption, userId);
                foreach (var item in products)
                {
            %>
                <div class="product-card">
                    <h2><%= item.Name %></h2>
                    <p><strong>価格:</strong> ¥<%= item.Price %></p>
                    <p><%= item.Description %></p>
                    <img src="<%= item.ImageUrl %>" alt="商品画像" style="max-width:100%;" />
                    <a href="/ProductDetail.aspx?id=<%= item.Id %>">詳細を見る</a>

                   <form method="post" action="/Product/AddToCart?keyword=<%= keyword %>&sortOption=<%= sortOption %>">
                        <input type="hidden" name="productId" value="<%= item.Id %>" />
                        <button type="submit" class="add-to-cart-button">カートに追加</button>
                    </form>

                    <form method="post" action="/Product/AddToWishlist?keyword=<%= keyword %>&sortOption=<%= sortOption %>">
                        <input type="hidden" name="productId" value="<%= item.Id %>" />
                        <button type="submit" class="add-to-wishlist-button">
                            <%= item.IsInWishlist ? "♥" : "♡" %>
                        </button>
                    </form>
                </div>
            <% } %>
        </div>

        <div class="cart-summary">
            <a href="/Cart.aspx">カート (<%= new YourNamespace.Models.CartModel().GetCartItemCount(userId) %>)</a>
        </div>
    </div>
</body>
</html>
