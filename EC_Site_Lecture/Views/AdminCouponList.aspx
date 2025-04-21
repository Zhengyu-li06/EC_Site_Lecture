<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>クーポン管理</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .user-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }

        .user-card {
            background-color: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            padding: 20px;
            width: 280px;
            text-align: center;
        }

        .user-card h3 {
            font-size: 18px;
            margin-bottom: 6px;
        }

        .user-card p {
            font-size: 14px;
            color: #555;
            margin: 4px 0;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 10px;
            color: white;
            font-weight: bold;
        }

        .badge-40 { background-color: #4CAF50; }
        .badge-20 { background-color: #FF9800; }
        .badge-0 { background-color: #ccc; color: #666; }

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
        var users = EC_Site_Lecture.Models.AdminCoupon.GetEligibleUsers();

        foreach (var user in users)
        {
            TimeSpan timeSinceRegistered = DateTime.Now - user.DateCreated;
            string badgeClass = "badge-0";
            string badgeText = "適用外";

            if (timeSinceRegistered.TotalDays <= 7)
            {
                badgeClass = "badge-40";
                badgeText = "40% OFF";
            }
            else if (timeSinceRegistered.TotalDays <= 30)
            {
                badgeClass = "badge-20";
                badgeText = "20% OFF";
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
