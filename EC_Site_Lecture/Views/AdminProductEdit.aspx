<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.ScreenDTO" %>

<%
    var product = (AdminProductDTO)Session["EditProduct"];
    if (product == null)
    {
        Response.Redirect("/AdminProductList.aspx");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>商品編集</title>
    <style>
        form {
            max-width: 500px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 12px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 18px;
        }
        label {
            display: block;
            font-weight: bold;
        }
        input, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            padding: 10px 20px;
            background-color: #5b9bd5;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <form method="post" action="/AdminProduct/Update">
        <input type="hidden" name="Id" value="<%= product.Id %>" />

        <div class="form-group">
            <label>商品名</label>
            <input type="text" name="Name" value="<%= product.Name %>" required />
        </div>

        <div class="form-group">
            <label>価格</label>
            <input type="number" step="0.01" name="Price" value="<%= product.Price %>" required />
        </div>

        <div class="form-group">
            <label>在庫数</label>
            <input type="number" name="Quantity" value="<%= product.Quantity %>" required />
        </div>

        <div class="form-group">
            <label>説明</label>
            <textarea name="Description"><%= product.Description %></textarea>
        </div>

        <div class="form-group">
            <label>画像URL</label>
            <input type="text" name="ImageUrl" value="<%= product.ImageUrl %>" />
        </div>

        <button type="submit">保存</button>
    </form>
</body>
</html>
