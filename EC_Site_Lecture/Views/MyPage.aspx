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
        body { font-family: 'Segoe UI'; background: #f7f7f7; }
        .container { max-width: 800px; margin: 50px auto; padding: 20px; background: white; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .section { margin-bottom: 30px; }
        .order-summary { border: 1px solid #ccc; padding: 10px; margin-bottom: 15px; border-radius: 6px; background: #f9f9f9; }
        label { display: block; margin-top: 10px; }
        input[type="text"], input[type="email"] { width: 100%; padding: 8px; margin-top: 5px; border-radius: 4px; border: 1px solid #ccc; }
        button { margin-top: 15px; padding: 8px 16px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background: #45a049; }
    </style>
</head>
<body>
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
        %>


        <div class="section">
            <h3>ユーザー情報</h3>
            <p><strong>ユーザー名:</strong> <%= user.Username %></p>
            <p><strong>メールアドレス:</strong> <%= user.Email %></p>
            <p><strong>登録日:</strong> <%= user.DateCreated.ToString("yyyy/MM/dd") %></p>
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
