<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>管理者ダッシュボード</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
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
            <span class="status">✔ 完了</span>
        </a>
    </div>
</body>
</html>
