<%@ Page Language="C#" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>


<!DOCTYPE html>
<html>
<head runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <title>売上集計</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
        th { background-color: #f0f0f0; }

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

    <h2>📊 売上集計（商品別）</h2>
    <form method="post" action="/SalesSummary/ExportExcel">
        <button type="submit">📥 Excel 出力</button>
    </form>
    <%
        var data = new SalesSummaryModel().GetSalesSummary();
    %>
    <canvas id="salesChart" width="600" height="300"></canvas>
    <table>
        <tr>
            <th>商品名</th>
            <th>販売数（合計）</th>
            <th>売上金額（合計）</th>
        </tr>
        <% foreach (var item in data) { %>
        <tr>
            <td><%= item.ProductName %></td>
            <td><%= item.TotalQuantity %></td>
            <td>¥<%= item.TotalSales.ToString("N0") %></td>
        </tr>
        <% } %>
    </table>
    <script id="salesDataJson" type="application/json">
    <%= new SalesSummaryModel().ToJson() %>
</script>

<script>
    const raw = document.getElementById("salesDataJson").textContent;
    const salesData = JSON.parse(raw);

    const labels = salesData.map(x => x.ProductName);
    const quantities = salesData.map(x => x.TotalQuantity);

    const ctx = document.getElementById('salesChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: '販売数（合計）',
                data: quantities,
                backgroundColor: 'rgba(0, 123, 204, 0.6)'
            }]
        },
        options: {
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: '個数'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: '商品名'
                    }
                }
            }
        }
    });
</script>


</body>
</html>
