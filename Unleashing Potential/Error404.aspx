<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.master" CodeBehind="Error404.aspx.cs" Inherits="Unleashing_Potential.Error404" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .error-wrapper {
            min-height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1rem;
        }
        .error-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 8px 40px rgba(14, 165, 233, 0.12);
            padding: 3rem 2.5rem;
            max-width: 560px;
            width: 100%;
            text-align: center;
            border-top: 5px solid var(--accent);
        }
        .error-icon-wrap {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: var(--sky-pale);
            border: 3px solid var(--sky-light);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
        }
        .error-icon-wrap i { font-size: 2.6rem; color: var(--sky-dark); }
        .error-code {
            font-family: 'Lora', serif;
            font-size: 5rem;
            font-weight: 700;
            color: var(--sky-deeper);
            line-height: 1;
            margin-bottom: 0.25rem;
            letter-spacing: -2px;
        }
        .error-code span { color: var(--accent); }
        .error-title {
            font-family: 'Lora', serif;
            font-size: 1.4rem;
            color: var(--sky-dark);
            margin-bottom: 0.75rem;
        }
        .error-message {
            color: var(--muted);
            font-size: 0.97rem;
            line-height: 1.6;
            margin-bottom: 2rem;
        }
        .error-actions { display: flex; flex-wrap: wrap; gap: 0.75rem; justify-content: center; }
        .btn-home {
            background: var(--sky-deeper);
            color: #fff;
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            font-family: 'Nunito', sans-serif;
            font-weight: 600;
            font-size: 0.95rem;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: background 0.2s;
        }
        .btn-home:hover { background: var(--sky-dark); color: #fff; }
        .btn-back {
            background: none;
            color: var(--sky-dark);
            border: 1.5px solid var(--sky-light);
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
            font-family: 'Nunito', sans-serif;
            font-weight: 600;
            font-size: 0.95rem;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: background 0.2s, border-color 0.2s;
        }
        .btn-back:hover { background: var(--sky-pale); border-color: var(--sky-dark); }
        .quick-links {
            margin-top: 2.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--sky-light);
        }
        .quick-links p { color: var(--muted); font-size: 0.85rem; margin-bottom: 0.6rem; }
        .quick-links a { color: var(--sky-dark); text-decoration: none; font-size: 0.9rem; font-weight: 500; margin: 0 0.5rem; }
        .quick-links a:hover { color: var(--accent); text-decoration: underline; }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="error-wrapper">
        <div class="error-card">
            <div class="error-icon-wrap">
                <i class="bi bi-compass"></i>
            </div>
            <div class="error-code">4<span>0</span>4</div>
            <h2 class="error-title">Page Not Found</h2>
            <p class="error-message">
                Oops! The page you're looking for doesn't exist or may have been moved.
                Don't worry — let's get you back on track.
            </p>
            <div class="error-actions">
                <a href="Default.aspx" class="btn-home">
                    <i class="bi bi-house-door-fill"></i> Go Home
                </a>
                <button onclick="history.back(); return false;" class="btn-back">
                    <i class="bi bi-arrow-left"></i> Go Back
                </button>
            </div>
            <div class="quick-links">
                <p>Or jump to a page:</p>
                <a href="Services.aspx">Services</a>
                <a href="About.aspx">About</a>
                <a href="Contact.aspx">Contact Us</a>
            </div>
        </div>
    </div>
</asp:Content>