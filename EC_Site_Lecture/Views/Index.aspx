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
        <a href="/Views/Index.aspx">商品一覧</a>
        <a href="/Views/MyPage.aspx?userId=<%= Session["UserId"] %>">マイページ</a>
        <a href="/Views/Login.aspx">ログイン</a>
        <a href="/Views/Register.aspx">新規登録</a>
        <a href="/Views/Logout.aspx">ログアウト</a>
        <a href="/Views/Wishlist.aspx" class="wishlist-icon"><i class="fa fa-heart"></i></a>
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

                var products = EC_Site_Lecture.Models.Product1.GetAll(keyword, sortOption, userId);
                foreach (var item in products)
                {
            %>
                <div class="product-card">
                    <h2><%= item.Name %></h2>
                    <p><strong>価格:</strong> ¥<%= item.Price %></p>
                    <p><%= item.Description %></p>
                    <img src="<%= item.ImageUrl %>" alt="商品画像" style="max-width:100%;" />
                   <a href="/Views/ProductDetails.aspx?id=<%= item.Id %>">詳細を見る</a>



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
            <a href="/Views/Cart.aspx">カート (<%= new EC_Site_Lecture.Models.CartModel().GetCartItemCount(userId) %>)</a>
        </div>
    </div>
<%
    var bestSeller = EC_Site_Lecture.Models.Product1.GetBestSeller();
    if (bestSeller != null)
    {
%>
<div id="popupOverlay" style="display: flex; justify-content: center; align-items: center;
     position: fixed; top: 0; left: 0; width: 100%; height: 100%;
     background-color: rgba(0, 0, 0, 0.5); z-index: 999;">
    
    <div id="popupAd" style="background-color: #fffbe6; padding: 20px; border-radius: 12px;
         border: 2px solid #ffa000; width: 360px; position: relative; box-shadow: 0 10px 30px rgba(0,0,0,0.3); text-align: center;">
        
        <button onclick="closePopup()" 
            style="position: absolute; top: 10px; right: 10px; border: none; background: none; font-size: 20px; cursor: pointer;">×</button>

        <h3 style="color: #d35400;">🔥 人気No.1商品！</h3>
        <img src="<%= bestSeller.ImageUrl %>" alt="人気商品" style="max-width: 100%; border-radius: 8px; margin: 10px 0;" />
        <p><strong><%= bestSeller.Name %></strong></p>
        <p style="color: #555;">価格：¥<%= bestSeller.Price.ToString("N0") %></p>
        <a href="/Views/ProductDetails.aspx?id=<%= bestSeller.Id %>" 
           style="display: inline-block; margin-top: 10px; background-color: #ff9800; color: white;
                  padding: 10px 20px; border-radius: 6px; text-decoration: none;">詳しく見る</a>
    </div>
</div>
<% } %>
<script>
    function closePopup() {
        document.getElementById("popupOverlay").style.display = "none";
    }

    document.addEventListener("click", function (e) {
        const overlay = document.getElementById("popupOverlay");
        const popup = document.getElementById("popupAd");

        if (e.target === overlay) {
            closePopup();
        }
    });
</script>

</body>
</html>
