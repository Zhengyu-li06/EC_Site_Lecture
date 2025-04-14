<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja">
<head runat="server">
    <meta charset="utf-8" />
    <title>ご注文ありがとうございます</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
        }

        form {
            max-width: 600px;
            margin: 80px auto;
            padding: 40px;
            background-color: #ffffff;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            text-align: center;
        }

        .thank-you {
            font-size: 32px;
            font-weight: bold;
            color: #333333;
            margin-bottom: 20px;
        }

        .message {
            font-size: 18px;
            color: green;
            margin-bottom: 20px;
        }

        .note {
            font-size: 16px;
            color: #555;
            margin-bottom: 30px;
        }

        .btn {
            padding: 12px 28px;
            font-size: 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }

        .btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <form method="post">
        <div class="thank-you">ご注文ありがとうございます！</div>
        <div class="message">
            お客様のご注文が正常に受け付けられました。
        </div>
        <div class="note">
            注文確認のメールが送信されましたので、ご確認ください。<br />
            ご不明点がございましたら、お気軽にお問い合わせください。
        </div>
        <a href="/Views/Index.aspx" class="btn">トップページに戻る</a>
    </form>
</body>
</html>

