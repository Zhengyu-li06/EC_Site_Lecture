<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="EC_Site_Lecture.DTO" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>ショッピングカート</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/cart.css" />
</head>
<body class="cart-page">
    <!-- ナビゲーションバー -->
    <div class="navbar">
        <a href="/Views/Index.aspx">商品一覧</a>
        <a href="/Views/MyPage.aspx?userId=<%= Session["UserId"] %>">マイページ</a>
        <a href="/Views/Login.aspx">ログイン</a>
        <a href="/Views/Register.aspx">新規登録</a>
        <a href="/Views/Logout.aspx">ログアウト</a>
        <a href="/Views/Wishlist.aspx" class="wishlist-icon"><i class="fa fa-heart"></i></a>
    </div>

    <!-- メインコンテンツ -->
    <div class="container">
        <h2>カート内の商品</h2>

        <%
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;
            if (userId == 0)
            {
                Response.Redirect("/Account/Login");
            }

            CartModel cartModel = new CartModel();
            List<CartDto> cartItems = cartModel.GetCartItems(userId);
            double totalAmount = 0;

            if (cartItems.Count == 0)
            {
        %>
            <div class="empty-message">カートに商品がありません。</div>
        <%
            }
            else
            {
                foreach (var item in cartItems)
                {
                    totalAmount += item.Price * item.Quantity;
        %>
            <div class="cart-item">
                <img src="<%= item.ImageUrl %>" alt="<%= item.Name %>" />
                <div>
                    <h4><%= item.Name %></h4>
                    <p><%= item.Description %></p>
                    <p>数量: <%= item.Quantity %>　価格: <%= item.Price %> 円</p>

                    <form method="post" action="/Cart/UpdateQuantity2" class="inline-form">
                        <input type="hidden" name="productId" value="<%= item.ProductId %>" />
                        <input type="hidden" name="action" value="Increase" />
                        <button type="submit" class="btn">＋</button>
                    </form>

                    <form method="post" action="/Cart/UpdateQuantity2" class="inline-form">
                        <input type="hidden" name="productId" value="<%= item.ProductId %>" />
                        <input type="hidden" name="action" value="Decrease" />
                        <button type="submit" class="btn">−</button>
                    </form>

                    <form method="post" action="/Cart/RemoveFromCart2" class="inline-form">
                        <input type="hidden" name="productId" value="<%= item.ProductId %>" />
                        <button type="submit" class="btn">削除</button>
                    </form>
                </div>
            </div>
        <%
                }
            }
        %>

        <% if (cartItems.Count > 0) { %>
            <div class="total">
                合計金額: <%= totalAmount %> 円
            </div>
            <form method="post" action="/Cart/ProceedToCheckout">
                <button type="submit" class="checkout-btn">購入手続きへ進む</button>
            </form>
        <% } %>
    </div>
</body>
</html>