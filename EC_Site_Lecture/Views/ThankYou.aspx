<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja">
<head runat="server">
    <meta charset="utf-8" />
    <title>ご注文ありがとうございます</title>
    <link rel="stylesheet" href="/CSS/user.css" />
</head>
<body>
    <form method="post" class="thank-you-form">
        <div class="thank-you-title">ご注文ありがとうございます！</div>
        <div class="thank-you-message">
            お客様のご注文が正常に受け付けられました。
        </div>
        <div class="thank-you-note">
            注文確認のメールが送信されましたので、ご確認ください。<br />
            ご不明点がございましたら、お気軽にお問い合わせください。
        </div>
        <a href="/Views/Index.aspx" class="btn btn-green">トップページに戻る</a>
    </form>
</body>
</html>