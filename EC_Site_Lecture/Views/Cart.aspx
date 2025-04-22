<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="EC_Site_Lecture.DTO" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>ショッピングカート</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 800px;
            margin: 60px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        .cart-item {
            border-bottom: 1px solid #eee;
            padding: 16px 0;
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .cart-item img {
            width: 80px;
            height: auto;
            border-radius: 6px;
        }

        .cart-item h4 {
            margin: 0 0 6px 0;
            font-size: 18px;
        }

        .cart-item p {
            margin: 4px 0;
            font-size: 14px;
        }

        form.inline-form {
            display: inline-block;
            margin-right: 10px;
        }

        .btn {
            padding: 6px 12px;
            font-size: 14px;
            background-color: #5b9bd5;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn:hover {
            background-color: #4a8ac3;
        }

        .total {
            text-align: right;
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
        }

        .empty-message {
            text-align: center;
            font-size: 16px;
            color: #666;
            margin-top: 40px;
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
                } // foreach
            } // else
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
