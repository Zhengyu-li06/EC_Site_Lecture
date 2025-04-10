<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="YourNamespace.Cart" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>カート</title>
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
            width: 100%;
            display: flex;
            justify-content: flex-end; 
            gap: 20px; 
        }


        .navbar a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            transition: opacity 0.2s ease-in-out;
        }

        .navbar a:hover {
            opacity: 0.8;
        }

        .container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        .cart-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .cart-item img {
            width: 100px;
            height: 100px;
            border-radius: 8px;
            object-fit: cover;
            margin-right: 20px;
        }

        .cart-item h3 {
            font-size: 18px;
            color: #333;
            margin: 0;
        }

        .cart-item p {
            font-size: 14px;
            color: #555;
            margin: 5px 0;
        }

        .cart-item .price {
            font-weight: bold;
            color: #4CAF50;
        }

        .cart-item .description {
            font-size: 12px;
            color: #888;
        }
        .checkout-btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #4CAF50;
            color: white;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            margin-top: 20px;
            transition: background-color 0.3s;
        }

        .checkout-btn:hover {
            background-color: #45a049;
        }

        .checkout-btn:focus {
            outline: none;
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
    </div>


    <form id="form1" runat="server">
        <div class="container">
            <h2>ショッピングカート</h2>

            <div class="cart-summary">
                <h3>カート内の商品</h3>
                <asp:Repeater ID="CartRepeater" runat="server" OnItemCommand="CartRepeater_ItemCommand">
                    <ItemTemplate>
                        <div class="cart-item">
                            <div>
                                <img src='<%# Eval("ImageUrl") %>' alt="<%# Eval("Name") %>" />
                                <h4><%# Eval("Name") %></h4>
                                <p><strong>説明:</strong> <%# Eval("Description") %></p>
                                <p><strong>価格:</strong> ¥<%# Eval("Price") %></p>
                                <p><strong>数量:</strong> <%# Eval("Quantity") %></p>
                            </div>
                            <div class="actions">
                                <asp:Button CommandName="Increase" CommandArgument='<%# Eval("ProductId") %>' Text="増加" runat="server" />
                                <asp:Button CommandName="Decrease" CommandArgument='<%# Eval("ProductId") %>' Text="減少" runat="server" />
                                <asp:Button CommandName="Delete" CommandArgument='<%# Eval("ProductId") %>' Text="削除" runat="server" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="total">
                    <strong>合計金額:</strong> ¥<asp:Label ID="lblTotal" runat="server" />
                </div>
                <asp:Button ID="ProceedToCheckout" runat="server" Text="購入手続きへ進む" OnClick="ProceedToCheckout_Click" CssClass="btn-proceed" />
            </div>
        </div>
    </form>
</body>

</html>
