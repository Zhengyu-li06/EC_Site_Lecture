<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>発送情報一覧（管理者）</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
</head>
<body class="admin-shipping-list-page">
    <div class="navbar">
        <h1>📋 管理者メニュー</h1>
        <div>
            <a href="/Views/AdminProductList.aspx">商品管理</a>
            <a href="/Views/AdminShippingList.aspx">発送管理</a>
            <a href="/Views/AdminCouponList.aspx">クーポン管理</a>
            <a href="/Views/SalesSummary.aspx">売上集計</a>
        </div>
    </div>

    <h2>発送情報一覧</h2>

    <%
        var shippingModel = new EC_Site_Lecture.Models.ShippingStatus();
        var shippings = shippingModel.GetAll();

        if (shippings != null && shippings.Count > 0)
        {
    %>
        <table class="shipping-table">
            <thead>
                <tr>
                    <th>注文ID</th>
                    <th>状態</th>
                    <th>追跡番号</th>
                    <th>発送日</th>
                    <th>配達日</th>
                    <th>備考</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <% foreach (var item in shippings) { %>
                    <tr>
                        <td><%= item.OrderId %></td>
                        <td><%= item.Status %></td>
                        <td><%= item.TrackingNumber %></td>
                        <td><%= item.ShippedDate?.ToString("yyyy-MM-dd") ?? "-" %></td>
                        <td><%= item.DeliveredDate?.ToString("yyyy-MM-dd") ?? "-" %></td>
                        <td><%= item.Note %></td>
                        <td>
                            <a href="/AdminShipping/Edit?id=<%= item.ShippingStatusId %>" class="btn-edit">編集</a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <%
        }
        else
        {
    %>
        <p style="text-align: center;">発送情報が見つかりませんでした。</p>
    <%
        }
    %>
</body>
</html>