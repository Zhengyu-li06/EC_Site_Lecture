<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="EC_Site_Lecture.DTO" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>チェックアウト</title>
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
        <h2>注文内容確認</h2>

        <%
            int userId = Session["UserId"] != null ? (int)Session["UserId"] : 0;
            if (userId == 0)
            {
                Response.Redirect("/Account/Login");
            }

            CartModel cartModel = new CartModel();
            List<CartDto> cartItems = cartModel.GetCartItems(userId);
            double totalAmount = 0;

            var couponUser = new MyPageModel().GetUserInfoByUserId(userId);
            double discountRate = 0;
            string couponMessage = "";

            if (couponUser != null)
            {
                if (couponUser.CouponStatus == "40%OFF")
                {
                    discountRate = 0.40;
                    couponMessage = "🎉 40%OFF クーポンが適用されました！";
                }
                else if (couponUser.CouponStatus == "20%OFF")
                {
                    discountRate = 0.20;
                    couponMessage = "🔔 20%OFF クーポンが適用されました！";
                }
            }

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

                    <form method="post" action="/Cart/RemoveFromCart" class="inline-form">
                        <input type="hidden" name="productId" value="<%= item.ProductId %>" />
                        <button type="submit" class="btn">削除</button>
                    </form>
                </div>
            </div>
        <%
                }

                double discountAmount = totalAmount * discountRate;
                double finalAmount = totalAmount - discountAmount;
        %>
            <div class="total">
                合計金額: ¥<%= totalAmount.ToString("N0") %><br />
                <% if (discountRate > 0) { %>
                    <span style="color: green;"><%= couponMessage %></span><br />
                    クーポン割引: -¥<%= discountAmount.ToString("N0") %><br />
                    <strong>お支払い金額: ¥<%= finalAmount.ToString("N0") %></strong>
                <% } else { %>
                    <strong>お支払い金額: ¥<%= totalAmount.ToString("N0") %></strong>
                <% } %>
            </div>

            <form method="post" action="/Order/ConfirmPurchase" class="checkout-form">
                <h3>お届け先情報</h3>

                <label for="customerName">名前:</label>
                <input type="text" name="customerName" id="customerName" required />

                <label for="customerAddress">住所:</label>
                <textarea name="customerAddress" id="customerAddress" rows="3" required></textarea>

                <label for="customerPhone">電話番号:</label>
                <input type="text" name="customerPhone" id="customerPhone" required />

                <label for="email">メールアドレス:</label>
                <input type="text" name="email" id="email" />

                <input type="hidden" name="finalAmount" value="<%= finalAmount %>" />

                <button type="submit">購入を確定</button>
            </form>
        <%
            } // end else
        %>
    </div>
</body>
</html>
