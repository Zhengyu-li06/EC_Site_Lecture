<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyPage.aspx.cs" Inherits="YourNamespace.MyPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>マイページ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .navbar {
            background-color: #4CAF50;
            padding: 14px 20px;
            width: 100%;
            display: flex;
            justify-content: flex-end;  
            gap: 20px; 
        }


        .navbar a {
            color: white;
            text-decoration: none;
            font-weight: bold;
            transition: opacity 0.2s;
        }

        .navbar a:hover {
            opacity: 0.8;
        }

        .container {
            padding: 30px;
            background-color: white;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 100%;
            max-width: 1200px;
            margin-top: 80px; /* 使内容与navbar不重叠 */
        }

        .main-content {
            padding: 20px;
        }

        .info-block {
            font-size: 16px;
            margin-bottom: 15px;
        }

        .info-block span {
            font-weight: bold;
            color: #555;
        }

        .order-table {
            margin-top: 30px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 10px;
            background-color: #fff;
        }

        .order-table th, .order-table td {
            padding: 12px 15px;
            text-align: left;
            vertical-align: middle;
        }

        .order-table th {
            background-color: #f8f9fa;
            color: #495057;
        }

        .order-table tr:nth-child(even) {
            background-color: #f2f2f2;
        }

        .btn {
            border-radius: 20px;
            padding: 8px 20px;
            font-size: 14px;
        }

        .btn-danger {
            background-color: #dc3545;
            border: none;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        .btn-secondary {
            background-color: #6c757d;
            border: none;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        .logout-btn {
            margin-top: 20px;
        }

        .modal-header {
            background-color: #dc3545;
            color: white;
        }

        .modal-footer {
            justify-content: center;
        }

        .modal-body {
            font-size: 16px;
            color: #333;
        }

        .modal-dialog {
            max-width: 500px;
        }

        .modal-title {
            font-size: 18px;
            font-weight: bold;
        }

        .form-control {
            border-radius: 10px;
            box-shadow: none;
        }

        .panel-table {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            padding: 15px;
        }

    </style>
</head>
<body>
    <div class="navbar">
        <a href="/Index.aspx">商品一覧</a>
        <a href="/MyPage.aspx">マイページ</a>
        <a href="/Login.aspx">ログイン</a>
        <a href="/Register.aspx">新規登録</a>
        <a href="/Logout.aspx">ログアウト</a>
    </div>

    <form id="form1" runat="server">
        <div class="container">
            <h2>マイページ</h2>

            <!-- ユーザー情報 -->
            <div class="info-block">
                <span class="info-label">ユーザー名:</span>
                <asp:Label ID="lblUsername" runat="server" />
            </div>
            <div class="info-block">
                <span class="info-label">メールアドレス:</span>
                <asp:Label ID="lblEmail" runat="server" />
            </div>
            <div class="info-block">
                <span class="info-label">作成日:</span>
                <asp:Label ID="lblDateCreated" runat="server" />
            </div>

            <!-- 編集用セクション -->
            <h3>アカウント管理</h3>
            <asp:Panel ID="pnlEditUser" runat="server" CssClass="panel-table">
                <table class="table">
                    <tr>
                        <td>ユーザー名:</td>
                        <td><asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" /></td>
                    </tr>
                    <tr>
                        <td>メールアドレス:</td>
                        <td>
                            <asp:TextBox ID="txtEmail" runat="server" ReadOnly="true" ForeColor="Gray" CssClass="form-control" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <asp:Button ID="btnUpdateUser" runat="server" Text="情報を更新" OnClick="btnUpdateUser_Click" CssClass="btn btn-primary" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>

            <!-- アカウント削除ボタン -->
            <asp:Button ID="btnShowDeleteModal" runat="server" Text="アカウントを削除する"
                CssClass="btn btn-danger" OnClientClick="showDeleteModal(); return false;" />

            <!-- ログアウトボタン -->
            <div class="logout-btn">
                <asp:Button ID="btnLogout" runat="server" Text="ログアウト" OnClick="btnLogout_Click" CssClass="btn btn-secondary" />
            </div>

            <!-- 注文履歴 -->
            <h3>注文履歴</h3>
            <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvOrders_RowDataBound" CssClass="order-table" GridLines="Both" BorderWidth="1" CellPadding="4">
                <Columns>
                    <asp:BoundField DataField="OrderId" HeaderText="注文ID" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="合計金額" DataFormatString="{0:N0}" HtmlEncode="false" />
                    <asp:BoundField DataField="CustomerName" HeaderText="顧客名" />
                    <asp:BoundField DataField="CustomerAddress" HeaderText="住所" />
                    <asp:BoundField DataField="CustomerPhone" HeaderText="電話番号" />
                    <asp:BoundField DataField="CustomerEmail" HeaderText="メール" />
                    <asp:BoundField DataField="OrderDate" HeaderText="注文日" />
                    <asp:BoundField DataField="Status" HeaderText="注文状態" />
                </Columns>
            </asp:GridView>
        </div>

        <!-- モーダル（確認） -->
        <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteModalLabel">確認</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="閉じる"></button>
                    </div>
                    <div class="modal-body">
                        本当にアカウントを削除しますか？この操作は元に戻せません。
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">キャンセル</button>
                        <asp:Button ID="btnDeleteAccount" runat="server" Text="削除する" CssClass="btn btn-danger"
                            OnClick="btnDeleteAccount_Click" />
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        function showDeleteModal() {
            var myModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            myModal.show();
        }
    </script>
</body>
</html>
