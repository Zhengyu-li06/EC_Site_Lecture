<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>商品追加（管理者）</title>
    <link rel="stylesheet" href="/CSS/common.css" />
    <link rel="stylesheet" href="/CSS/admin.css" />
</head>
<body class="product-form-page">
    <h2>商品追加（管理者）</h2>

    <form method="post" action="/AdminProduct/Add" enctype="multipart/form-data" class="product-form">
        <div class="form-group">
            <label>商品名</label>
            <input type="text" name="Name" required />
        </div>

        <div class="form-group">
            <label>価格</label>
            <input type="number" step="0.01" name="Price" required />
        </div>

        <div class="form-group">
            <label>在庫数</label>
            <input type="number" step="1" name="Quantity" required />
        </div>

        <div class="form-group">
            <label>画像URL（外部画像）</label>
            <input type="text" name="ImageUrl" />
        </div>

        <div class="form-group">
            <label>画像ファイル（アップロード）</label>
            <input type="file" name="UploadedImage" accept="image/*" />
        </div>

        <div class="form-group">
            <label>説明</label>
            <textarea name="Description" rows="4"></textarea>
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="IsDiscontinued" value="true" />
                販売中止
            </label>
            <input type="hidden" name="IsDiscontinued" value="false" />
        </div>

        <div class="form-group">
            <label>
                <input type="checkbox" name="IsNewArrival" value="true" />
                新入荷
            </label>
            <input type="hidden" name="IsNewArrival" value="false" />
        </div>

        <button type="submit">追加する</button>
    </form>
</body>
</html>