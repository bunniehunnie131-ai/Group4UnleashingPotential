<%@ Page Title="Browse Services" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ServiceCategories.aspx.cs" Inherits="Unleashing_Potential.WebForm6" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root {
        --sky: #0ea5e9; --sky-dark: #0369a1;
        --sky-deeper: #0c4a6e; --sky-light: #bae6fd;
        --sky-pale: #f0f9ff; --muted: #64748b;
    }
    .page-wrap { max-width: 980px; margin: 0 auto; }
    .page-header {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        border-radius: 16px; padding: 2rem 2.5rem;
        margin-bottom: 2rem;
        box-shadow: 0 4px 24px rgba(12,74,110,0.12);
    }
    .page-header h2 { font-family:'Lora',serif; color:#f0f9ff; font-size:1.8rem; margin:0 0 0.3rem; }
    .page-header p { color: var(--sky-light); font-size:0.92rem; margin:0; }
    .cat-card {
        background:#fff; border-radius:16px; overflow:hidden;
        box-shadow:0 4px 18px rgba(12,74,110,0.08);
        transition:transform 0.25s, box-shadow 0.25s;
        cursor:pointer; text-decoration:none; display:block; color:inherit;
    }
    .cat-card:hover { transform:translateY(-6px); box-shadow:0 12px 30px rgba(12,74,110,0.16); text-decoration:none; color:inherit; }
    .cat-img-wrap {
        background: linear-gradient(135deg, #e0f2fe, var(--sky-light));
        overflow: hidden;
        border-radius: 16px 16px 0 0;
    }
    .cat-img {
        width: 100%;
        height: 160px;
        object-fit: cover;
        display: block;
    }
    .cat-body { padding: 1.3rem 1.4rem 1.6rem; text-align:center; }
    .cat-body h5 { font-family:'Lora',serif; color:var(--sky-deeper); font-size:1.1rem; font-weight:700; margin-bottom:0.4rem; }
    .cat-body p { font-size:0.86rem; color:var(--muted); margin-bottom:1rem; line-height:1.5; }
    .cat-meta { font-size:0.8rem; color:var(--sky-dark); font-weight:600; }
    .basket-btn {
        position:fixed; bottom:2rem; right:2rem;
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        color:#fff; border:none; border-radius:50px;
        padding:0.75rem 1.5rem; font-size:0.9rem; font-weight:600;
        box-shadow:0 4px 16px rgba(14,165,233,0.4);
        cursor:pointer; z-index:999; text-decoration:none;
        display:flex; align-items:center; gap:0.5rem;
    }
    .basket-btn:hover { opacity:0.9; color:#fff; text-decoration:none; }
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
        <h2>Welcome back, <asp:Label ID="lblUserName" runat="server" />!</h2>
        <p>Choose a service category to find trusted professionals in your area.</p>
    </div>

    <div class="row g-4">

        <div class="col-sm-6 col-md-3">
            <a href="ServiceProviders.aspx?category=Hairdressing" class="cat-card">
                <div class="cat-img-wrap">
                    <img src="images/hairdressing.png" alt="Hairdressing" class="cat-img" />
                </div>
                <div class="cat-body">
                    <h5>Hairdressing</h5>
                    <p>Braiding, styling, colouring, locs and wig services.</p>
                    <div class="cat-meta">4 Providers Available</div>
                </div>
            </a>
        </div>

        <div class="col-sm-6 col-md-3">
            <a href="ServiceProviders.aspx?category=Tailoring" class="cat-card">
                <div class="cat-img-wrap">
                    <img src="images/tailoring.png" alt="Tailoring" class="cat-img" />
                </div>
                <div class="cat-body">
                    <h5>Tailoring</h5>
                    <p>Alterations, custom garments, traditional and bridal wear.</p>
                    <div class="cat-meta">4 Providers Available</div>
                </div>
            </a>
        </div>

        <div class="col-sm-6 col-md-3">
            <a href="ServiceProviders.aspx?category=Plumbing" class="cat-card">
                <div class="cat-img-wrap">
                    <img src="images/plumbing.png" alt="Plumbing" class="cat-img" />
                </div>
                <div class="cat-body">
                    <h5>Plumbing</h5>
                    <p>Pipe installation, leak repairs, geysers and renovations.</p>
                    <div class="cat-meta">4 Providers Available</div>
                </div>
            </a>
        </div>

        <div class="col-sm-6 col-md-3">
            <a href="ServiceProviders.aspx?category=Painting" class="cat-card">
                <div class="cat-img-wrap">
                    <img src="images/painting.png" alt="Painting" class="cat-img" />
                </div>
                <div class="cat-body">
                    <h5>Painting</h5>
                    <p>Interior, exterior, commercial and decorative painting.</p>
                    <div class="cat-meta">4 Providers Available</div>
                </div>
            </a>
        </div>

    </div>
</div>

<a href="Basket.aspx" class="basket-btn">
    🛒 My Basket
    <asp:Label ID="lblBasketCount" runat="server" CssClass="basket-badge" Text="0" />
</a>
</asp:Content>
