<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="EC_Site_Lecture.DTO" %>

<!DOCTYPE html>
<html>
<head>
    <title>お気に入りリスト</title>
    <link rel="stylesheet" href="/CSS/user.css" />
</head>
<body>
    <div class="wishlist-container">
        <h2 class="wishlist-title">お気に入り商品</h2>

        <%
            var wishlist = Session["WishlistItems"] as List<WishlistDTO>;

            if (wishlist == null || wishlist.Count == 0)
            {
        %>
            <p class="wishlist-empty">お気に入りに登録された商品はありません。</p>
        <%
            }
            else
            {
                foreach (var item in wishlist)
                {
        %>
            <div class="wishlist-item">
                <img src="<%= item.ImageUrl %>" alt="<%= item.ProductName %>" class="wishlist-image" />
                <div class="wishlist-details">
                    <h4 class="wishlist-name"><%= item.ProductName %></h4>
                    <p class="wishlist-price">価格: ¥<%= item.Price.ToString("F2") %></p>
                    <form method="post" action="/Wishlist/RemoveFromWishlist">
                        <input type="hidden" name="productId" value="<%= item.ProductId %>" />
                        <button type="submit" class="btn-remove">お気に入りから削除</button>
                    </form>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>