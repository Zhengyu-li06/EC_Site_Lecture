<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>マイページ</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/user.css" />
</head>
<body class="mypage">
    <!-- ナビゲーションバー -->
    <div class="navbar">
        <a href="/Views/Index.aspx">商品一覧</a>
        <a href="/Views/MyPage.aspx?userId=<%= Session["UserId"] %>">マイページ</a>
        <a href="/Views/Login.aspx">ログイン</a>
        <a href="/Views/Register.aspx">新規登録</a>
        <a href="/Views/Logout.aspx">ログアウト</a>
        <a href="/Views/Wishlist.aspx" class="wishlist-icon"><i class="fa fa-heart"></i></a>
    </div>

    <div class="container">
        <!-- 注文レポートボタン -->
        <form method="post" action="/MyPage/GenerateReport" style="text-align:right;">
            <button type="submit">注文レポートをダウンロード</button>
        </form>

        <h2>マイページ</h2>

        <%
            if (Session["UserId"] == null)
            {
                Response.Redirect("/Views/Login.aspx");
            }

            int userId = (int)Session["UserId"];
            var orderModel = new Order();
            var user = orderModel.GetUserInfoByUserId(userId);
            var orders = orderModel.GetOrdersByUserId(userId);
            var couponUser = new MyPageModel().GetUserInfoByUserId(userId);
        %>

        <!-- ユーザー情報 -->
        <div class="section">
            <h3>ユーザー情報</h3>
            <p><strong>ユーザー名:</strong> <%= user.Username %></p>
            <p><strong>メールアドレス:</strong> <%= user.Email %></p>
            <p><strong>登録日:</strong> <%= user.DateCreated.ToString("yyyy/MM/dd") %></p>
            <% if (couponUser != null) { %>
                <p><strong>クーポンステータス:</strong>
                    <span class="coupon-tag"><%= couponUser.CouponStatus %></span>
                </p>
            <% } %>
        </div>

        <!-- ユーザー情報編集フォーム -->
        <div class="section">
            <h3>ユーザー情報を編集</h3>
            <form method="post" action="/MyPage/Update">
                <input type="hidden" name="UserId" value="<%= user.UserId %>" />
                <label for="Username">ユーザー名</label>
                <input type="text" name="Username" value="<%= user.Username %>" />

                <label for="Email">メールアドレス</label>
                <input type="email" name="Email" value="<%= user.Email %>" />

                <button type="submit">変更を保存</button>
            </form>
        </div>

        <!-- 注文履歴 -->
        <div class="section">
            <h3>注文履歴</h3>
            <% if (orders.Count == 0) { %>
                <p>注文履歴がありません。</p>
            <% } else { foreach (var order in orders) { %>
                <div class="order-summary">
                    <p><strong>注文ID:</strong> <%= order.OrderId %></p>
                    <p><strong>注文日:</strong> <%= order.OrderDate.ToString("yyyy/MM/dd HH:mm") %></p>
                    <p><strong>合計金額:</strong> ¥<%= order.TotalAmount.ToString("F2") %></p>
                    <p><strong>ステータス:</strong> <%= order.Status %></p>
                </div>
            <% } } %>
        </div>
    </div>
</body>
</html>