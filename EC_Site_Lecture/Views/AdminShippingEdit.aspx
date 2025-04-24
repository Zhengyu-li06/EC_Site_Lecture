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
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
</head>
<body class="shipping-edit-page">
    <div class="navbar">
        <h1>管理者メニュー</h1>
        <div>
            <a href="/Views/AdminProductList.aspx">商品管理</a>
            <a href="/Views/AdminShippingList.aspx">発送管理</a>
            <a href="/Views/AdminCouponList.aspx">クーポン管理</a>
            <a href="/Views/SalesSummary.aspx">売上集計</a>
        </div>
    </div>

    <form method="post" action="/AdminShipping/Update" class="shipping-edit-form">
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
