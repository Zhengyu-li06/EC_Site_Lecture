<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理者ダッシュボード</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: #f9f9f9;
            padding: 40px;
        }

        h1 {
            text-align: center;
            margin-bottom: 40px;
        }

        .menu {
            display: flex;
            flex-direction: column;
            gap: 20px;
            max-width: 500px;
            margin: auto;
        }

        .menu a {
            display: block;
            padding: 20px;
            background-color: #5b9bd5;
            color: white;
            text-decoration: none;
            font-size: 18px;
            border-radius: 10px;
            text-align: center;
            transition: background-color 0.2s ease;
        }

        .menu a:hover {
            background-color: #4a8ac3;
        }

        .menu .status {
            font-size: 14px;
            margin-top: 6px;
            color: #eee;
        }
    </style>
</head>
<body>
    <h1>📦 管理機能ダッシュボード</h1>

    <div class="menu">
        <a href="/Views/AdminProductList.aspx">
            🛒 商品管理<br />
            <span class="status">✔ 完了</span>
        </a>

        <a href="/Views/AdminShippingList.aspx">
            🚚 発送管理<br />
            <span class="status">✔ 完了</span>
        </a>

        <a href="/Views/AdminCouponList.aspx">
            🎁 クーポン管理<br />
            <span class="status">🕓 未着手</span>
        </a>
    </div>
</body>
</html>
