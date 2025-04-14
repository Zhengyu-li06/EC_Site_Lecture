<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="EC_Site_Lecture.DTO" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>チェックアウト</title>
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

        h2 {
            text-align: center;
            margin-bottom: 30px;
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

        .checkout-form {
            margin-top: 40px;
        }

        .checkout-form label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        .checkout-form input[type="text"],
        .checkout-form textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .checkout-form button {
            width: 100%;
            padding: 12px;
            font-size: 16px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .checkout-form button:hover {
            background-color: #218838;
        }

        .empty-message {
            text-align: center;
            font-size: 16px;
            color: #666;
            margin-top: 40px;
        }
    </style>
</head>
<body>
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
                } // foreach
        %>
            <div class="total">
                合計金額: <%= totalAmount.ToString("N0") %> 円
            </div>

            <!-- 配送先フォーム -->
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

                <button type="submit">購入を確定</button>
            </form>

        <%
            } // end else
        %>
    </div>
</body>
</html>
