<%@ Page Title="My Basket" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Basket.aspx.cs" Inherits="Unleashing_Potential.WebForm8" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root {
        --sky:#0ea5e9; --sky-dark:#0369a1;
        --sky-deeper:#0c4a6e; --sky-light:#bae6fd;
        --sky-pale:#f0f9ff; --muted:#64748b;
    }
    .page-wrap { max-width:860px; margin:0 auto; }
    .page-header {
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        border-radius:16px; padding:1.6rem 2rem; margin-bottom:1.5rem;
        display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;
    }
    .page-header h2 { font-family:'Lora',serif; color:#f0f9ff; font-size:1.6rem; margin:0; }
    .back-link { color:var(--sky-light); font-size:0.85rem; text-decoration:none; }
    .back-link:hover { color:#fff; }
    .basket-table-wrap {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.07);
        overflow:hidden; margin-bottom:1.5rem;
    }
    .basket-row {
        display:flex; align-items:center; gap:1rem;
        padding:1.2rem 1.5rem; border-bottom:1px solid #f1f5f9;
        flex-wrap:wrap;
    }
    .basket-row:last-child { border-bottom:none; }
    .basket-row-header {
        background:var(--sky-pale); padding:0.8rem 1.5rem;
        display:flex; gap:1rem; font-size:0.75rem; font-weight:700;
        color:var(--sky-dark); text-transform:uppercase; letter-spacing:0.06em;
    }
    .item-info { flex:1; min-width:160px; }
    .item-name { font-weight:600; color:#1e293b; font-size:0.92rem; }
    .item-service { font-size:0.8rem; color:var(--muted); }
    .btn-remove {
        background:#fef2f2; border:1.5px solid #fecaca;
        color:#dc2626; border-radius:7px; padding:0.3rem 0.7rem;
        font-size:0.8rem; font-weight:600; cursor:pointer; transition:all 0.2s;
    }
    .btn-remove:hover { background:#fee2e2; }
    .item-price { font-weight:700; color:var(--sky-deeper); font-size:0.92rem; min-width:80px; text-align:right; }
    .summary-card {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.07);
        padding:1.6rem 1.8rem;
    }
    .summary-row { display:flex; justify-content:space-between; padding:0.5rem 0; font-size:0.9rem; color:#374151; border-bottom:1px solid #f1f5f9; }
    .summary-total { display:flex; justify-content:space-between; padding:0.8rem 0 0; font-size:1.1rem; font-weight:700; color:var(--sky-deeper); }
    .btn-checkout {
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        border:none; color:#fff; border-radius:10px;
        padding:0.9rem 2rem; font-size:1rem; font-weight:600;
        cursor:pointer; transition:opacity 0.2s; width:100%; margin-top:1rem;
    }
    .btn-checkout:hover { opacity:0.88; color:#fff; }
    .empty-basket {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.07);
        padding:3rem; text-align:center;
    }
    .empty-basket p { color:var(--muted); margin:0.5rem 0 1.5rem; }
    .btn-browse {
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        border:none; color:#fff; border-radius:10px;
        padding:0.7rem 1.8rem; font-size:0.92rem; font-weight:600;
        text-decoration:none; display:inline-block;
    }
    .btn-browse:hover { opacity:0.88; color:#fff; text-decoration:none; }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrap">

    <div class="page-header">
        <h2>🛒 My Booking Basket</h2>
        <a href="ServiceCategories.aspx" class="back-link">← Continue Browsing</a>
    </div>

    <!-- Empty state -->
    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-basket">
            <div style="font-size:3rem;margin-bottom:0.5rem;">🛒</div>
            <h4 style="color:var(--sky-deeper);font-family:'Lora',serif;">Your basket is empty</h4>
            <p>Browse our service categories and add providers to your basket.</p>
            <a href="ServiceCategories.aspx" class="btn-browse">Browse Services</a>
        </div>
    </asp:Panel>

    <!-- Basket with items -->
    <asp:Panel ID="pnlBasket" runat="server">
        <div class="row g-4">
            <div class="col-md-8">
                <div class="basket-table-wrap">
                    <div class="basket-row-header">
                        <span style="flex:1;">Service Provider</span>
                        <span style="width:80px;text-align:right;">Total</span>
                        <span style="width:60px;"></span>
                    </div>
                    <asp:Repeater ID="rptBasket" runat="server" OnItemCommand="rptBasket_ItemCommand">
                        <ItemTemplate>
                            <div class="basket-row">
                                <div class="item-info">
                                    <div class="item-name"><%# Eval("ProviderName") %></div>
                                    <div class="item-service"><%# Eval("Service") %> · <%# Eval("Category") %></div>
                                    <div class="item-service" style="color:var(--sky-dark);font-weight:600;">
                                        R<%# String.Format("{0:0.00}", Eval("Price")) %> <%# Eval("PriceUnit") %>
                                    </div>
                                </div>
                                <div class="item-price">R<%# String.Format("{0:0.00}", Eval("LineTotal")) %></div>
                                <asp:Button runat="server" CssClass="btn-remove" Text="✕"
                                    CommandName="Remove"
                                    CommandArgument='<%# Eval("ProviderID") %>'
                                    CausesValidation="false" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <div class="col-md-4">
                <div class="summary-card">
                    <h5 style="font-family:'Lora',serif;color:var(--sky-deeper);margin-bottom:1rem;">Order Summary</h5>
                    <asp:Repeater ID="rptSummary" runat="server">
                        <ItemTemplate>
                            <div class="summary-row">
                                <span><%# Eval("ProviderName") %></span>
                                <span>R<%# String.Format("{0:0.00}", Eval("LineTotal")) %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <div class="summary-total">
                        <span>Total</span>
                        <span>R<asp:Label ID="lblTotal" runat="server" /></span>
                    </div>
                    <asp:Button ID="btnCheckout" runat="server" Text="Proceed to Checkout →"
                        CssClass="btn-checkout" OnClick="btnCheckout_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </asp:Panel>

</div>
</asp:Content>
