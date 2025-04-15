<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="EC_Site_Lecture.DTO" %>

<!DOCTYPE html>
<html>
<head>
    <title>お気に入りリスト</title>
    <style>
        body {
            font-family: 'Segoe UI';
            background-color: #f8f8f8;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.05);
        }

        .wishlist-item {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        .wishlist-item img {
            width: 100px;
            height: auto;
            margin-right: 20px;
            border-radius: 6px;
        }

        .wishlist-item h4 {
            margin: 0;
            font-size: 18px;
        }

        .wishlist-item p {
            margin: 5px 0;
            color: #666;
        }

        .btn-remove {
            background-color: #e53935;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }

        .btn-remove:hover {
            background-color: #c62828;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>お気に入り商品</h2>

        <%
            var wishlist = Session["WishlistItems"] as List<WishlistDTO>;

            if (wishlist == null || wishlist.Count == 0)
            {
        %>
            <p>お気に入りに登録された商品はありません。</p>
        <%
            }
            else
            {
                foreach (var item in wishlist)
                {
        %>
            <div class="wishlist-item">
                <img src="<%= item.ImageUrl %>" alt="<%= item.ProductName %>" />
                <div>
                    <h4><%= item.ProductName %></h4>
                    <p>価格: ¥<%= item.Price.ToString("F2") %></p>
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
