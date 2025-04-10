<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="YourNamespace.Checkout" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>チェックアウト</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
            color: #333;
        }
        .navbar {
            background-color: #4CAF50;
            padding: 14px 20px;
            width: 98%;
            display: flex;
            justify-content: flex-end;  
            gap: 20px; 
        }


        .navbar a {
            color: white;
            text-decoration: none;
            padding: 10px;
            font-weight: bold;
            font-size: 16px;
            transition: opacity 0.3s;
        }

        .navbar a:hover {
            opacity: 0.8;
        }
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        .checkout-summary {
            margin-bottom: 30px;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 8px;
            background-color: #fafafa;
        }

        .checkout-summary h3 {
            margin-bottom: 20px;
            font-size: 1.4em;
            color: #333;
            text-align: center;
        }

        .cart-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }

        .cart-item h4 {
            margin: 0;
            font-size: 1.1em;
            font-weight: bold;
            color: #333;
        }

        .cart-item p {
            margin: 5px 0;
            color: #666;
        }

        .cart-item .price {
            font-weight: bold;
        }

        .total {
            font-size: 1.2em;
            font-weight: bold;
            margin-top: 15px;
            text-align: right;
            color: #333;
        }
        .form-section {
            margin-top: 30px;
        }

        .form-section label {
            display: block;
            font-weight: bold;
            margin-bottom: 5px;
        }

        .form-section input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1em;
            box-sizing: border-box;
        }
        .form-section button {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            font-size: 1.1em;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
            transition: background-color 0.3s;
        }

        .form-section button:hover {
            background-color: #45a049;
        }
        @media (max-width: 768px) {
            .container {
                width: 90%;
                padding: 15px;
            }

            .navbar {
                flex-direction: column;
                align-items: flex-start;
            }

            .navbar a {
                padding: 8px;
                font-size: 14px;
            }

            .checkout-summary h3 {
                font-size: 1.2em;
            }

            .cart-item {
                flex-direction: column;
                align-items: flex-start;
            }

            .cart-item h4, .cart-item .price {
                font-size: 1.2em;
            }
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
            <h2>注文内容確認</h2>
            <div class="checkout-summary">
                <h3>カート内の商品</h3>
                <asp:Repeater ID="CartRepeater" runat="server">
                    <ItemTemplate>
                        <div class="cart-item">
                            <div>
                                <h4><%# Eval("Name") %></h4>
                                <p><strong>価格:</strong> ¥<%# Eval("Price") %></p>
                                <p><strong>数量:</strong> <%# Eval("Quantity") %></p> 
                            </div>
                            <div class="price">
                                ¥<%# Eval("Price") %> 
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <div class="total">
                    <strong>合計金額:</strong> ¥<asp:Label ID="lblTotal" runat="server" />
                </div>
            </div>
            <div class="form-section">
                <h3>お届け先情報</h3>
                <label for="txtName">名前:</label>
                <asp:TextBox ID="txtName" runat="server" />

                <label for="txtAddress">住所:</label>
                <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" />

                <label for="txtPhone">電話番号:</label>
                <asp:TextBox ID="txtPhone" runat="server" />

                <label for="txtEmail">メールアドレス:</label>
                <asp:TextBox ID="txtEmail" runat="server" />
                <asp:Button 
                    ID="btnConfirmPurchase" 
                    runat="server" 
                    Text="購入を確定" 
                    OnClick="ConfirmPurchase_Click" 
                    CssClass="btn-confirm" />
            </div>
        </div>
    </form>
</body>

</html>
