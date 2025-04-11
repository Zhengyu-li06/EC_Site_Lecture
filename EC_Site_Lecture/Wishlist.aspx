<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Wishlist.aspx.cs" Inherits="YourNamespace.Wishlist" EnableEventValidation="false" %>

<!DOCTYPE html>
<html>
<head>
    <title>Wishlist</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="wishlist-container">
            <asp:Repeater ID="WishlistRepeater" runat="server">
                <ItemTemplate>
                    <div class="wishlist-item">
                        
                        <img src='<%# Eval("ImageUrl") %>' alt="画像" />
                        
                        <h3><%# Eval("ProductName") %></h3>
                      
                        <p>价格: ¥<%# Eval("Price") %></p>
                       
                        <asp:Button 
                            runat="server" 
                            Text="Remove" 
                            CommandName="RemoveFromWishlist" 
                            CommandArgument='<%# Eval("ProductId") %>' 
                            OnCommand="RemoveFromWishlist_Click" 
                            CssClass="remove-button" />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>
