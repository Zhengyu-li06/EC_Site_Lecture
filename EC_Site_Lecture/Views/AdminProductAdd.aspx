<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>商品追加（管理者）</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 40px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
        }

        form {
            max-width: 500px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ccc;
        }

        button {
            background-color: #5b9bd5;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            width: 100%;
        }

        button:hover {
            background-color: #4a8ac3;
        }
    </style>
</head>
<body>
    <h2>商品追加（管理者）</h2>
<form method="post" action="/AdminProduct/Add" enctype="multipart/form-data">
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

    <!-- ✅ name="UploadedImage" に修正 -->
    <div class="form-group">
        <label>画像ファイル（アップロード）</label>
        <input type="file" name="UploadedImage" accept="image/*" />
    </div>

    <div class="form-group">
        <label>説明</label>
        <textarea name="Description" rows="4"></textarea>
    </div>

    <!-- 販売中止 -->
    <div class="form-group">
        <label>
            <input type="checkbox" name="IsDiscontinued" value="true" />
            販売中止
        </label>
        <input type="hidden" name="IsDiscontinued" value="false" />
    </div>

    <!-- 新入荷 -->
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
