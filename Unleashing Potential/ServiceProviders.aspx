<%@ Page Title="Service Providers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ServiceProviders.aspx.cs" Inherits="Unleashing_Potential.WebForm5" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root {
        --sky:#0ea5e9; --sky-dark:#0369a1;
        --sky-deeper:#0c4a6e; --sky-light:#bae6fd;
        --sky-pale:#f0f9ff; --muted:#64748b;
    }
    .page-wrap { max-width:980px; margin:0 auto; }
    .page-header {
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        border-radius:16px; padding:1.6rem 2rem;
        margin-bottom:2rem;
        box-shadow:0 4px 24px rgba(12,74,110,0.12);
        display:flex; align-items:center; justify-content:space-between; flex-wrap:wrap; gap:1rem;
    }
    .page-header h2 { font-family:'Lora',serif; color:#f0f9ff; font-size:1.6rem; margin:0; }
    .page-header p { color:var(--sky-light); font-size:0.88rem; margin:0; }
    .back-link { color:var(--sky-light); font-size:0.85rem; text-decoration:none; }
    .back-link:hover { color:#fff; }
    .provider-card {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.08);
        transition:transform 0.2s, box-shadow 0.2s;
        overflow:hidden; height:100%;
    }
    .provider-card:hover { transform:translateY(-4px); box-shadow:0 10px 28px rgba(12,74,110,0.14); }
    .provider-avatar {
        background:linear-gradient(135deg,var(--sky-pale),var(--sky-light));
        padding:1.8rem 1rem; text-align:center;
    }
    .avatar-circle {
        width:80px; height:80px; border-radius:50%;
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        display:inline-flex; align-items:center; justify-content:center;
        font-size:2rem; color:#fff; font-weight:700;
    }
    .provider-body { padding:1.2rem 1.3rem 1.5rem; }
    .provider-name { font-family:'Lora',serif; color:var(--sky-deeper); font-size:1.05rem; font-weight:700; margin-bottom:0.2rem; }
    .provider-specialty { font-size:0.8rem; color:var(--sky-dark); font-weight:600; text-transform:uppercase; letter-spacing:0.04em; margin-bottom:0.6rem; }
    .stars { color:#f59e0b; font-size:0.9rem; }
    .rating-text { font-size:0.8rem; color:var(--muted); margin-left:0.3rem; }
    .provider-desc { font-size:0.84rem; color:var(--muted); line-height:1.5; margin:0.7rem 0 0.5rem; }
    .provider-meta { font-size:0.8rem; color:#475569; margin-bottom:0.3rem; }
    .price-tag {
        background:var(--sky-pale); border:1px solid var(--sky-light);
        border-radius:8px; padding:0.5rem 0.8rem;
        margin:0.8rem 0; font-weight:700; color:var(--sky-deeper); font-size:0.95rem;
    }
    .btn-view {
        background:transparent; border:2px solid var(--sky-dark);
        color:var(--sky-dark); border-radius:8px;
        padding:0.45rem 1rem; font-size:0.84rem; font-weight:600;
        transition:all 0.2s; cursor:pointer;
        text-decoration:none; display:inline-block;
    }
    .btn-view:hover { background:var(--sky-dark); color:#fff; text-decoration:none; }
    .btn-basket {
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        border:none; color:#fff; border-radius:8px;
        padding:0.45rem 1rem; font-size:0.84rem; font-weight:600;
        cursor:pointer; transition:opacity 0.2s;
    }
    .btn-basket:hover { opacity:0.88; color:#fff; }
    .alert-success-custom {
        background:#f0fdf4; border:1px solid #bbf7d0; color:#166534;
        border-radius:10px; padding:0.8rem 1.2rem; margin-bottom:1rem;
        font-size:0.88rem;
    }
    .basket-float {
        position:fixed; bottom:2rem; right:2rem;
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        color:#fff; border:none; border-radius:50px;
        padding:0.75rem 1.5rem; font-size:0.9rem; font-weight:600;
        box-shadow:0 4px 16px rgba(14,165,233,0.4);
        cursor:pointer; z-index:999; text-decoration:none;
        display:flex; align-items:center; gap:0.5rem;
    }
    .basket-float:hover { opacity:0.9; color:#fff; text-decoration:none; }
    .basket-badge {
        background:#fff; color:var(--sky-dark); border-radius:50%;
        width:22px; height:22px; display:inline-flex;
        align-items:center; justify-content:center;
        font-size:0.75rem; font-weight:700;
    }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrap">

    <div class="page-header">
        <div>
            <h2><asp:Label ID="lblCategoryIcon" runat="server" /> <asp:Label ID="lblCategory" runat="server" /></h2>
            <p>Select a provider to view their full profile or add them directly to your basket.</p>
        </div>
        <a href="ServiceCategories.aspx" class="back-link">← Back to Categories</a>
    </div>

    <asp:Panel ID="pnlMessage" runat="server" Visible="false">
        <div class="alert-success-custom">
            ✅ <asp:Label ID="lblMessage" runat="server" />
        </div>
    </asp:Panel>

    <div class="row g-4">
        <asp:Repeater ID="rptProviders" runat="server" OnItemCommand="rptProviders_ItemCommand">
            <ItemTemplate>
                <div class="col-sm-6 col-md-3">
                    <div class="provider-card">
                        <div class="provider-avatar">
                            <div class="avatar-circle"><%# GetInitials(Eval("Name").ToString()) %></div>
                        </div>
                        <div class="provider-body">
                            <div class="provider-name"><%# Eval("Name") %></div>
                            <div class="provider-specialty"><%# Eval("Specialty") %></div>
                            <div>
                                <span class="stars"><%# GetStars(Convert.ToDouble(Eval("Rating"))) %></span>
                                <span class="rating-text"><%# Eval("Rating") %> (<%# Eval("ReviewCount") %> reviews)</span>
                            </div>
                            <div class="provider-desc"><%# Eval("Description") %></div>
                            <div class="provider-meta">📍 <%# Eval("Location") %></div>
                            <div class="provider-meta">⏱ <%# Eval("YearsExperience") %> years experience</div>
                            <div class="price-tag">R<%# Eval("Price") %> <small style="font-weight:400;font-size:0.78rem;color:var(--muted);"><%# Eval("PriceUnit") %></small></div>
                            <div class="d-flex gap-2 flex-wrap">
                                <a href='<%# "ProviderProfile.aspx?id=" + Eval("ProviderID") %>' class="btn-view">View Profile</a>
                                <asp:Button runat="server" CssClass="btn-basket"
                                    Text="+ Basket"
                                    CommandName="AddToBasket"
                                    CommandArgument='<%# Eval("ProviderID") %>'
                                    CausesValidation="false" />
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

</div>

<a href="Basket.aspx" class="basket-float">
    🛒 My Basket
    <asp:Label ID="lblBasketCount" runat="server" CssClass="basket-badge" Text="0" />
</a>
</asp:Content>
