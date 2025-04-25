<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>商品一覧</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/user.css" />
    <link rel="stylesheet" href="/CSS/product.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
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
            <input type="text" name="keyword" class="search-box" placeholder="キーワードで検索" value="<%= Request["keyword"] %>" />
            <button type="submit" class="search-button">検索</button>

            <select name="sortOption" class="sort-dropdown" onchange="this.form.submit()">
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
                <img src="<%= item.ImageUrl %>" alt="商品画像" />
                <a href="/Views/ProductDetails.aspx?id=<%= item.Id %>">詳細を見る</a>

                <form method="post" action="/Product/AddToCart?keyword=<%= keyword %>&sortOption=<%= sortOption %>">
                    <input type="hidden" name="productId" value="<%= item.Id %>" />
                    <button type="submit" class="add-to-cart-button">カートに追加</button>
                </form>

                <form method="post" action="/Product/AddToWishlist?keyword=<%= keyword %>&sortOption=<%= sortOption %>">
                    <input type="hidden" name="productId" value="<%= item.Id %>" />
                    <button type="submit" class="add-to-wishlist-button"><%= item.IsInWishlist ? "♥" : "♡" %></button>
                </form>
            </div>
            <% } %>
        </div>

        <div class="cart-summary">
            <a href="/Views/Cart.aspx">カート (<%= new EC_Site_Lecture.Models.CartModel().GetCartItemCount(userId) %>)</a>
        </div>
    </div>

    <% var bestSeller = EC_Site_Lecture.Models.Product1.GetBestSeller();
       if (bestSeller != null) { %>
    <div id="popupOverlay">
        <div id="popupAd">
            <button onclick="closePopup()">×</button>
            <h3>🔥 人気No.1商品！</h3>
            <img src="<%= bestSeller.ImageUrl %>" alt="人気商品" />
            <p><strong><%= bestSeller.Name %></strong></p>
            <p>価格：¥<%= bestSeller.Price.ToString("N0") %></p>
            <a href="/Views/ProductDetails.aspx?id=<%= bestSeller.Id %>">詳しく見る</a>
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