<%@ Page Title="Provider Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProviderProfile.aspx.cs" Inherits="Unleashing_Potential.WebForm7" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root {
        --sky:#0ea5e9; --sky-dark:#0369a1;
        --sky-deeper:#0c4a6e; --sky-light:#bae6fd;
        --sky-pale:#f0f9ff; --muted:#64748b;
    }
    .page-wrap { max-width:900px; margin:0 auto; }
    .profile-hero {
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        border-radius:16px; padding:2rem 2.5rem;
        margin-bottom:1.5rem; color:#fff;
        display:flex; align-items:center; gap:2rem; flex-wrap:wrap;
    }
    .hero-avatar {
        width:100px; height:100px; border-radius:50%;
        background:rgba(255,255,255,0.2);
        display:flex; align-items:center; justify-content:center;
        font-size:2.5rem; font-weight:700; color:#fff;
        flex-shrink:0; border:3px solid rgba(255,255,255,0.4);
    }
    .hero-info h2 { font-family:'Lora',serif; font-size:1.8rem; margin:0 0 0.2rem; }
    .hero-specialty { font-size:0.88rem; color:var(--sky-light); text-transform:uppercase; letter-spacing:0.06em; margin-bottom:0.6rem; }
    .hero-stars { font-size:1.1rem; color:#fbbf24; }
    .hero-rating-text { font-size:0.88rem; color:rgba(255,255,255,0.75); margin-left:0.4rem; }
    .section-card {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.07);
        padding:1.6rem 1.8rem; margin-bottom:1.5rem;
    }
    .section-title {
        font-family:'Lora',serif; font-size:1.1rem; font-weight:700;
        color:var(--sky-deeper); margin-bottom:1rem;
        padding-bottom:0.6rem; border-bottom:2px solid var(--sky-light);
    }
    .meta-grid { display:grid; grid-template-columns:1fr 1fr; gap:0.8rem 1.5rem; }
    .meta-item { font-size:0.88rem; color:#374151; }
    .meta-label { font-weight:600; color:var(--sky-darker, var(--sky-dark)); font-size:0.78rem; text-transform:uppercase; letter-spacing:0.04em; display:block; margin-bottom:0.2rem; }
    .price-highlight {
        background:linear-gradient(135deg,var(--sky-pale),#e0f2fe);
        border:2px solid var(--sky-light); border-radius:12px;
        padding:1rem 1.4rem; display:inline-block; margin-top:0.5rem;
    }
    .price-amount { font-size:1.8rem; font-weight:700; color:var(--sky-deeper); }
    .price-unit   { font-size:0.85rem; color:var(--muted); }
    .portfolio-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(140px,1fr)); gap:0.8rem; }
    .portfolio-img {
        aspect-ratio:1; border-radius:10px; overflow:hidden;
        background:linear-gradient(135deg,var(--sky-pale),var(--sky-light));
        display:flex; align-items:center; justify-content:center;
        font-size:2.5rem;
    }
    .review-item { padding:1rem 0; border-bottom:1px solid #f1f5f9; }
    .review-item:last-child { border-bottom:none; }
    .review-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:0.4rem; }
    .reviewer-name { font-weight:600; font-size:0.88rem; color:#1e293b; }
    .review-stars  { color:#f59e0b; font-size:0.85rem; }
    .review-date   { font-size:0.76rem; color:var(--muted); }
    .review-comment { font-size:0.85rem; color:#475569; line-height:1.55; }
    .btn-add {
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        border:none; color:#fff; border-radius:10px;
        padding:0.8rem 2rem; font-size:0.95rem; font-weight:600;
        cursor:pointer; transition:opacity 0.2s; width:100%;
    }
    .btn-add:hover { opacity:0.88; color:#fff; }
    .back-link { color:var(--sky-dark); font-size:0.85rem; text-decoration:none; margin-bottom:1rem; display:inline-block; }
    .back-link:hover { color:var(--sky-deeper); }
    .alert-success-custom {
        background:#f0fdf4; border:1px solid #bbf7d0; color:#166534;
        border-radius:10px; padding:0.9rem 1.3rem; margin-bottom:1rem; font-size:0.88rem;
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

    <a href="javascript:history.back()" class="back-link">← Back to Providers</a>

    <asp:Panel ID="pnlMessage" runat="server" Visible="false">
        <div class="alert-success-custom">
            ✅ <asp:Label ID="lblMessage" runat="server" />
        </div>
    </asp:Panel>

    <!-- HERO -->
    <div class="profile-hero">
        <div class="hero-avatar"><asp:Label ID="lblInitials" runat="server" /></div>
        <div class="hero-info">
            <h2><asp:Label ID="lblName" runat="server" /></h2>
            <div class="hero-specialty"><asp:Label ID="lblSpecialty" runat="server" /></div>
            <div>
                <span class="hero-stars"><asp:Label ID="lblStars" runat="server" /></span>
                <span class="hero-rating-text">
                    <asp:Label ID="lblRating" runat="server" /> 
                    (<asp:Label ID="lblReviewCount" runat="server" /> reviews)
                </span>
            </div>
        </div>
    </div>

    <div class="row g-4">

        <!-- LEFT COLUMN -->
        <div class="col-md-7">

            <!-- About -->
            <div class="section-card">
                <div class="section-title">About</div>
                <p style="font-size:0.9rem;color:#374151;line-height:1.7;">
                    <asp:Label ID="lblDescription" runat="server" />
                </p>
                <div class="meta-grid" style="margin-top:1rem;">
                    <div class="meta-item"><span class="meta-label">📍 Location</span><asp:Label ID="lblLocation" runat="server" /></div>
                    <div class="meta-item"><span class="meta-label">📞 Phone</span><asp:Label ID="lblPhone" runat="server" /></div>
                    <div class="meta-item"><span class="meta-label">⏱ Experience</span><asp:Label ID="lblExperience" runat="server" /></div>
                    <div class="meta-item"><span class="meta-label">🏷️ Category</span><asp:Label ID="lblCategory" runat="server" /></div>
                </div>
            </div>

            <!-- Portfolio -->
            <div class="section-card">
                <div class="section-title">Portfolio</div>
                <div class="portfolio-grid">
                    <div class="portfolio-img">🖼️</div>
                    <div class="portfolio-img">🖼️</div>
                    <div class="portfolio-img">🖼️</div>
                    <div class="portfolio-img">🖼️</div>
                    <div class="portfolio-img">🖼️</div>
                    <div class="portfolio-img">🖼️</div>
                </div>
                <p style="font-size:0.78rem;color:var(--muted);margin-top:0.8rem;">
                    Portfolio images are provided by the service provider.
                </p>
            </div>

            <!-- Reviews -->
            <div class="section-card">
                <div class="section-title">Client Reviews</div>
                <asp:Repeater ID="rptReviews" runat="server">
                    <ItemTemplate>
                        <div class="review-item">
                            <div class="review-header">
                                <div>
                                    <span class="reviewer-name"><%# Eval("ReviewerName") %></span>
                                    <span class="review-stars" style="margin-left:0.5rem;"><%# GetStars(Convert.ToInt32(Eval("Rating"))) %></span>
                                </div>
                                <span class="review-date"><%# Convert.ToDateTime(Eval("ReviewDate")).ToString("dd MMM yyyy") %></span>
                            </div>
                            <div class="review-comment">"<%# Eval("Comment") %>"</div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoReviews" runat="server" Visible="false">
                    <p style="font-size:0.85rem;color:var(--muted);">No reviews yet. Be the first!</p>
                </asp:Panel>
            </div>

        </div>

        <!-- RIGHT COLUMN -->
        <div class="col-md-5">
            <div class="section-card" style="position:sticky;top:1rem;">
                <div class="section-title">Book This Service</div>
                <div class="price-highlight">
                    <div class="price-amount">R<asp:Label ID="lblPrice" runat="server" /></div>
                    <div class="price-unit"><asp:Label ID="lblPriceUnit" runat="server" /></div>
                </div>
                <p style="font-size:0.84rem;color:var(--muted);margin:1rem 0;">
                    Add this provider to your booking basket. You can book multiple services and proceed to checkout together.
                </p>
                <asp:Button ID="btnAddToBasket" runat="server" Text="🛒 Add to Basket"
                    CssClass="btn-add" OnClick="btnAddToBasket_Click" CausesValidation="false" />
                <div style="margin-top:0.8rem;text-align:center;">
                    <a href="Basket.aspx" style="font-size:0.82rem;color:var(--sky-dark);">View Basket →</a>
                </div>
            </div>
        </div>

    </div>
</div>

<a href="Basket.aspx" class="basket-float">
    🛒 My Basket
    <asp:Label ID="lblBasketCount" runat="server" CssClass="basket-badge" Text="0" />
</a>
</asp:Content>