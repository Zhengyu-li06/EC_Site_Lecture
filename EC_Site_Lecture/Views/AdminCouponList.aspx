<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>クーポン管理</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
</head>
<body>
    <div class="navbar">
        <h1>📋 管理者メニュー</h1>
        <div>
            <a href="/Views/AdminProductList.aspx">商品管理</a>
            <a href="/Views/AdminShippingList.aspx">発送管理</a>
            <a href="/Views/AdminCouponList.aspx">クーポン管理</a>
            <a href="/Views/SalesSummary.aspx">売上集計</a>
        </div>
    </div>

    <h2>クーポン管理</h2>

    <div class="user-container">
        <%
            var couponModel = new EC_Site_Lecture.Models.AdminCoupon();
            var users = couponModel.GetEligibleUsers();

            foreach (var user in users)
            {
                string badgeClass = "";
                string badgeText = "";

                switch (user.CouponStatus)
                {
                    case "40%OFF":
                        badgeClass = "badge-40";
                        badgeText = "40% OFF";
                        break;
                    case "20%OFF":
                        badgeClass = "badge-20";
                        badgeText = "20% OFF";
                        break;
                    default:
                        badgeClass = "badge-0";
                        badgeText = "適用外";
                        break;
                }
        %>
            <div class="user-card">
                <h3><%= user.Username %></h3>
                <p>登録日: <%= user.DateCreated.ToString("yyyy-MM-dd") %></p>
                <p class="badge <%= badgeClass %>"><%= badgeText %></p>
            </div>
        <%
            }
        %>
    </div>
</body>
</html>