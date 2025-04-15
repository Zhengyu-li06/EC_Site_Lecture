<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>

<%
    string idParam = Request["id"];
    int productId;
    ProductDto product = null;

    if (int.TryParse(idParam, out productId))
    {
        product = Product1.GetById(productId);
    }

    if (product == null)
    {
        product = new ProductDto
        {
            Name = "商品が見つかりませんでした。",
            Price = 0,
            Description = "",
            ImageUrl = ""
        };
    }
%>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>商品詳細</title>
</head>
<body>
    <div style="max-width:600px; margin:auto; padding:20px;">
        <h1><%= product.Name %></h1>
        <p><strong>価格:</strong> ¥<%= product.Price %></p>
        <p><%= product.Description %></p>
        <img src="<%= product.ImageUrl %>" alt="商品画像" style="width:100%; border-radius:10px;" />
    </div>
</body>
</html>
