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
    <script>
        function updateHiddenState() {
            const isDis = document.getElementById("chkDiscontinued").checked;
            const isNew = document.getElementById("chkNewArrival").checked;

            
            document.getElementById("chkNewArrival").disabled = isDis;
            document.getElementById("chkDiscontinued").disabled = isNew;

            document.getElementById("hiddenDiscontinued").value = isDis;
            document.getElementById("hiddenNewArrival").value = isNew;
        }

        window.onload = function () {
            updateHiddenState(); 
        };
    </script>
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
        </div>
</div>
<form method="post" action="/AdminProduct/Update" enctype="multipart/form-data">
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
            <label>画像URL（外部リンク）</label>
            <input type="text" name="ImageUrl" value="<%= product.ImageUrl %>" />
        </div>

        <div class="form-group">
            <label>画像ファイル（アップロード）</label>
            <input type="file" name="UploadedImage" accept="image/*" />
        </div>


        <!-- checkbox 表单 -->
        <div class="form-group">
            <label>
                <input type="checkbox" id="chkDiscontinued" onclick="updateHiddenState()"
                       <%= product.IsDiscontinued ? "checked" : "" %> />
                販売中止
            </label>
            <input type="hidden" name="IsDiscontinued" id="hiddenDiscontinued" value="<%= product.IsDiscontinued ? "true" : "false" %>" />
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" id="chkNewArrival" onclick="updateHiddenState()"
                       <%= product.IsNewArrival ? "checked" : "" %> />
                新入荷
            </label>
            <input type="hidden" name="IsNewArrival" id="hiddenNewArrival" value="<%= product.IsNewArrival ? "true" : "false" %>" />
        </div>
        <button type="submit">保存</button>
    </form>
</body>
</html>
