<%@ Page Language="C#" AutoEventWireup="true" %>
<%@ Import Namespace="EC_Site_Lecture.Models" %>

<% 
    var user = (User)Session["UserData"];
    var orders = (List<OrderDTO>)Session["Orders"];
%>

<!DOCTYPE html>
<html>
<head>
    <title>マイページ</title>
</head>
<body>
    <div class="navbar">
        <!-- 导航栏略 -->
    </div>

    <form method="post" action="/MyPage/Index">
        <div class="container">
            <h2>マイページ</h2>

            <div class="info-block">
                <span class="info-label">ユーザー名:</span>
                <input type="text" id="txtUsername" name="newUsername" value="<%= user?.Username %>" />
            </div>
            <div class="info-block">
                <span class="info-label">メールアドレス:</span>
                <input type="email" id="txtEmail" name="txtEmail" value="<%= user?.Email %>" readonly />
            </div>

            <h3>アカウント管理</h3>
            <table>
                <tr>
                    <td>ユーザー名:</td>
                    <td><input type="text" name="newUsername" value="<%= user?.Username %>" /></td>
                </tr>
                <tr>
                    <td>メールアドレス:</td>
                    <td><input type="email" name="txtEmail" value="<%= user?.Email %>" readonly /></td>
                </tr>
                <tr>
                    <td colspan="2"><button type="submit">情報を更新</button></td>
                </tr>
            </table>

        </div>
    </form>

    <!-- アカウント削除 -->
    <form method="post" action="/MyPage/DeleteUser" onsubmit="return confirm('本当にアカウントを削除しますか？');">
        <button type="submit" class="btn btn-danger">アカウントを削除する</button>
    </form>

    <!-- ログアウト -->
    <form method="post" action="/MyPage/Logout">
        <button type="submit" class="btn btn-secondary">ログアウト</button>
    </form>

</body>
</html>
