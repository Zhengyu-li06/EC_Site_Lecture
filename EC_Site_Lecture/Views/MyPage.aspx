<%@ Page Language="C#" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>マイページ</title>
    <style>
       body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background: #eef2f7;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 820px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
        }

        h2 {
            text-align: center;
            color: #007acc;
            margin-bottom: 30px;
        }

        .section {
            margin-bottom: 40px;
        }

        .section h3 {
            margin-bottom: 15px;
            color: #333;
            border-left: 4px solid #007acc;
            padding-left: 10px;
            font-size: 18px;
        }

        .section p {
            margin: 6px 0;
            color: #444;
            font-size: 15px;
        }

        .coupon-tag {
            display: inline-block;
            background: #ffd700;
            color: #000;
            padding: 6px 12px;
            border-radius: 10px;
            font-weight: bold;
            font-size: 14px;
            margin-top: 8px;
        }

        .order-summary {
            border: 1px solid #ccc;
            padding: 14px;
            margin-bottom: 20px;
            border-radius: 8px;
            background: #fdfdfd;
        }

        form label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #333;
        }

        input[type="text"],
        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
        }

        button {
            margin-top: 20px;
            padding: 10px 20px;
            background: #007acc;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background: #005fa3;
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

    
    var couponUser = new EC_Site_Lecture.Models.MyPageModel().GetUserInfoByUserId(userId);
%>

        <div class="section">
            <h3>ユーザー情報</h3>
            <p><strong>ユーザー名:</strong> <%= user.Username %></p>
            <p><strong>メールアドレス:</strong> <%= user.Email %></p>
            <p><strong>登録日:</strong> <%= user.DateCreated.ToString("yyyy/MM/dd") %></p>
            <% if (couponUser != null) { %>
      <% if (couponUser != null) { %>
        <p><strong>クーポンステータス:</strong>
            <span class="coupon-tag"><%= couponUser.CouponStatus %></span>
        </p>
    <% } %>
    <% } %>
        </div>

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
            <% }} %>
        </div>
    </div>
</body>
</html>
