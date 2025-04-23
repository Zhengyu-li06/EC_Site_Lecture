<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>

<%
    var shipping = (ShippingStatusDTO)Session["EditShipping"];
    if (shipping == null)
    {
        Response.Redirect("/AdminShipping/Index");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>発送情報編集</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f7f9fc;
            padding: 40px;
        }
        form {
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 18px;
        }
        label {
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
        }
        button:hover {
            background-color: #45a049;
        }
        .navbar {
            background-color: #007acc;
            padding: 15px 30px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar h1 {
            margin: 0;
            font-size: 22px;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            margin-left: 20px;
            font-weight: bold;
        }

        .navbar a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
    <div class="navbar">
        <h1>管理者メニュー</h1>
         <div>
             <a href="/Views/AdminProductList.aspx">商品管理</a>
             <a href="/Views/AdminShippingList.aspx">発送管理</a>
             <a href="/Views/AdminCouponList.aspx">クーポン管理</a>
             <a href="/Views/SalesSummary.aspx">売上集計</a>
         </div>
    </div>
    <form method="post" action="/AdminShipping/Update">
        <input type="hidden" name="ShippingStatusId" value="<%= shipping.ShippingStatusId %>" />
        <input type="hidden" name="OrderId" value="<%= shipping.OrderId %>" />

        <div class="form-group">
            <label>ステータス</label>
            <input type="text" name="Status" value="<%= shipping.Status %>" />
        </div>

        <div class="form-group">
            <label>追跡番号</label>
            <input type="text" name="TrackingNumber" value="<%= shipping.TrackingNumber %>" />
        </div>

        <div class="form-group">
            <label>発送日</label>
            <input type="date" name="ShippedDate" value="<%= shipping.ShippedDate?.ToString("yyyy-MM-dd") ?? "" %>" />
        </div>

        <div class="form-group">
            <label>配達日</label>
            <input type="date" name="DeliveredDate" value="<%= shipping.DeliveredDate?.ToString("yyyy-MM-dd") ?? "" %>" />
        </div>

        <div class="form-group">
            <label>メモ</label>
            <textarea name="Note" rows="3"><%= shipping.Note %></textarea>
        </div>

        <button type="submit">更新する</button>
    </form>

</body>
</html>
