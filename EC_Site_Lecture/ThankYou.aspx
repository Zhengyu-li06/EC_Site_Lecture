<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ThankYou.aspx.cs" Inherits="YourNamespace.ThankYou" %>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="utf-8" />
    <title>ご注文ありがとうございます</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding-top: 50px;
            text-align: center;
        }
        .message {
            font-size: 24px;
            color: green;
        }
        .thank-you {
            font-size: 36px;
            font-weight: bold;
            color: #333;
            margin-bottom: 20px;
        }
        .button {
            background-color: #4CAF50;
            color: white;
            padding: 15px 32px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            border: none;
            cursor: pointer;
            margin-top: 20px;
            border-radius: 4px;
        }
        .button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h1 class="thank-you">ご注文ありがとうございます！</h1>
            <p class="message">
                お客様のご注文が正常に受け付けられました。<br />
                注文確認のメールが送信されましたので、ご確認ください。
            </p>
            <p>
                ご不明点がございましたら、お気軽にお問い合わせください。
            </p>
            <a href="/Index.aspx" class="button">トップページに戻る</a>
        </div>
    </form>
</body>
</html>
