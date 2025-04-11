<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="YourNamespace.Index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>商品一覧</title>
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
        <a href="/Index.aspx">商品一覧</a>
        <a href="/MyPage.aspx">マイページ</a>
        <a href="/Login.aspx">ログイン</a>
        <a href="/Register.aspx">新規登録</a>
        <a href="/Logout.aspx">ログアウト</a>

       
        <a href="/Wishlist.aspx" class="wishlist-icon" title="Wishlist">
            <i class="fa fa-heart"></i> 
        </a>
    </div>

    <form id="form1" runat="server">
        <div class="search-filter-bar">
            <asp:TextBox ID="txtSearch" runat="server" CssClass="search-box" Placeholder="キーワードで検索" />
            <asp:Button ID="btnSearch" runat="server" Text="検索" CssClass="search-button" OnClick="btnSearch_Click" />

            <asp:DropDownList ID="ddlSort" runat="server" CssClass="sort-dropdown" AutoPostBack="true" OnSelectedIndexChanged="ddlSort_SelectedIndexChanged">
                <asp:ListItem Text="表示順（デフォルト）" Value="order" />
                <asp:ListItem Text="価格が高い順" Value="price_desc" />
                <asp:ListItem Text="価格が安い順" Value="price_asc" />
                <asp:ListItem Text="名前順（A→Z）" Value="name_asc" />
            </asp:DropDownList>
        </div>

        <div class="main-content">
            <div class="product-container">
                <asp:Repeater ID="ProductRepeater" runat="server">
                    <ItemTemplate>
                        <div class="product-card">
                            <h2><%# Eval("Name") %></h2>
                            <p><strong>価格:</strong> ¥<%# Eval("Price") %></p>
                            <p><%# Eval("Description") %></p>
                            <img src='<%# Eval("ImageUrl") %>' alt="商品画像" />
                            <asp:HyperLink 
                                runat="server" 
                                NavigateUrl='<%# "ProductDetail.aspx?id=" + Eval("Id") %>' 
                                CssClass="view-details-link">詳細を見る</asp:HyperLink>

                            
                            <asp:Button 
                                runat="server" 
                                Text="カートに追加" 
                                CommandName="AddToCart" 
                                CommandArgument='<%# Eval("Id") %>' 
                                OnCommand="AddToCart_Click" 
                                CssClass="add-to-cart-button" 
                                Enabled='<%# Session["UserId"] != null %>' />

                            <asp:Button 
                                runat="server" 
                                Text='<%# Convert.ToBoolean(Eval("IsInWishlist")) ? "♥" : "♡" %>' 
                                CommandName="AddToWishlist" 
                                CommandArgument='<%# Eval("Id") %>' 
                                OnCommand="AddToWishlist_Click" 
                                CssClass="add-to-wishlist-button" 
                                Enabled='<%# Session["UserId"] != null %>' />

                             </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <div class="cart-summary">
                <a href="Cart.aspx">
                    カート (<asp:Label ID="lblCartCount" runat="server" Text="0" />)
                </a>
            </div>
        </div>
    </form>
    
</body>

</html>
