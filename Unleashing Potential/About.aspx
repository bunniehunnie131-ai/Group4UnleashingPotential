<%@ Page Title="About" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Unleashing_Potential.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<style>
    :root {
        --sky:        #0ea5e9;
        --sky-dark:   #0369a1;
        --sky-deeper: #0c4a6e;
        --sky-light:  #bae6fd;
        --sky-pale:   #f0f9ff;
        --accent:     #f59e0b;
        --text:       #0f172a;
        --muted:      #64748b;
    }

    .about-hero {
        position: relative;
        background: linear-gradient(135deg, var(--sky-deeper) 0%, var(--sky-dark) 60%, #0284c7 100%);
        border-radius: 20px;
        padding: 4rem 2.5rem 3.5rem;
        margin-bottom: 3rem;
        overflow: hidden;
        color: #fff;
    }

    .about-hero::before {
        content: '';
        position: absolute;
        top: -60px; right: -60px;
        width: 280px; height: 280px;
        border-radius: 50%;
        background: rgba(255,255,255,0.06);
        pointer-events: none;
    }

    .about-hero::after {
        content: '';
        position: absolute;
        bottom: -80px; left: -40px;
        width: 340px; height: 340px;
        border-radius: 50%;
        background: rgba(255,255,255,0.04);
        pointer-events: none;
    }

    .hero-eyebrow {
        display: inline-block;
        background: rgba(255,255,255,0.15);
        border: 1px solid rgba(255,255,255,0.25);
        border-radius: 100px;
        padding: 0.3rem 1rem;
        font-size: 0.75rem;
        font-weight: 700;
        letter-spacing: 1.5px;
        text-transform: uppercase;
        color: var(--sky-light);
        margin-bottom: 1.2rem;
    }

    .about-hero h1 {
        font-family: 'Lora', serif;
        font-size: clamp(1.9rem, 4vw, 2.8rem);
        font-weight: 700;
        line-height: 1.2;
        margin: 0 0 1rem;
        color: #fff;
    }

    .about-hero h1 span {
        color: var(--accent);
    }

    .about-hero .lead {
        font-size: 1rem;
        color: rgba(255,255,255,0.82);
        max-width: 560px;
        line-height: 1.75;
        margin: 0;
    }

    .hero-accent-bar {
        width: 48px;
        height: 4px;
        background: var(--accent);
        border-radius: 4px;
        margin: 1.2rem 0;
    }

   
    .stats-row {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 1rem;
        margin-bottom: 3rem;
    }

    .stat-card {
        background: #fff;
        border: 1.5px solid var(--sky-light);
        border-radius: 14px;
        padding: 1.5rem 1.2rem;
        text-align: center;
        box-shadow: 0 2px 12px rgba(12,74,110,0.07);
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .stat-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 24px rgba(12,74,110,0.13);
    }

    .stat-number {
        font-family: 'Lora', serif;
        font-size: 2rem;
        font-weight: 700;
        color: var(--sky-dark);
        line-height: 1;
        margin-bottom: 0.3rem;
    }

    .stat-label {
        font-size: 0.78rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        color: var(--muted);
    }

    
    .section-heading {
        font-family: 'Lora', serif;
        font-size: 1.4rem;
        font-weight: 700;
        color: var(--sky-deeper);
        margin: 0 0 0.3rem;
    }

    .section-sub {
        font-size: 0.88rem;
        color: var(--muted);
        margin: 0 0 1.5rem;
    }

    
    .mv-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1.2rem;
        margin-bottom: 3rem;
    }

    .mv-card {
        border-radius: 14px;
        padding: 1.8rem 1.5rem;
        position: relative;
        overflow: hidden;
    }

    .mv-card.mission {
        background: var(--sky-pale);
        border: 1.5px solid var(--sky-light);
    }

    .mv-card.vision {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        color: #fff;
    }

    .mv-icon {
        width: 44px; height: 44px;
        border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        margin-bottom: 1rem;
        font-size: 1.2rem;
    }

    .mv-card.mission .mv-icon {
        background: var(--sky-light);
        color: var(--sky-dark);
    }

    .mv-card.vision .mv-icon {
        background: rgba(255,255,255,0.15);
        color: #fff;
    }

    .mv-card h3 {
        font-family: 'Lora', serif;
        font-size: 1.05rem;
        font-weight: 700;
        margin: 0 0 0.6rem;
    }

    .mv-card.mission h3 { color: var(--sky-deeper); }
    .mv-card.vision  h3 { color: #fff; }

    .mv-card p {
        font-size: 0.9rem;
        line-height: 1.7;
        margin: 0;
    }

    .mv-card.mission p { color: var(--muted); }
    .mv-card.vision  p { color: rgba(255,255,255,0.82); }

   
    .values-section {
        margin-bottom: 3rem;
    }

    .values-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1rem;
    }

    .value-item {
        display: flex;
        align-items: flex-start;
        gap: 0.9rem;
        background: #fff;
        border: 1.5px solid var(--sky-light);
        border-radius: 12px;
        padding: 1.2rem;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .value-item:hover {
        border-color: var(--sky);
        box-shadow: 0 4px 14px rgba(14,165,233,0.12);
    }

    .value-dot {
        width: 36px; height: 36px;
        flex-shrink: 0;
        border-radius: 8px;
        background: var(--sky-pale);
        border: 1.5px solid var(--sky-light);
        display: flex; align-items: center; justify-content: center;
        color: var(--sky-dark);
        font-size: 1rem;
    }

    .value-text strong {
        display: block;
        font-size: 0.88rem;
        font-weight: 700;
        color: var(--sky-deeper);
        margin-bottom: 0.2rem;
    }

    .value-text span {
        font-size: 0.82rem;
        color: var(--muted);
        line-height: 1.5;
    }

    .story-section {
        background: var(--sky-pale);
        border: 1.5px solid var(--sky-light);
        border-radius: 16px;
        padding: 2rem;
        margin-bottom: 3rem;
        position: relative;
    }

    .story-section::before {
        content: '\201C';
        font-family: 'Lora', serif;
        font-size: 6rem;
        color: var(--sky-light);
        position: absolute;
        top: -10px; left: 20px;
        line-height: 1;
        pointer-events: none;
    }

    .story-section p {
        font-size: 0.95rem;
        color: var(--text);
        line-height: 1.8;
        margin: 0;
        position: relative;
        z-index: 1;
    }

    
    .cta-banner {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        border-radius: 16px;
        padding: 2.2rem 2rem;
        text-align: center;
        color: #fff;
        margin-bottom: 1rem;
    }

    .cta-banner h3 {
        font-family: 'Lora', serif;
        font-size: 1.3rem;
        margin: 0 0 0.5rem;
        color: #fff;
    }

    .cta-banner p {
        font-size: 0.9rem;
        color: rgba(255,255,255,0.8);
        margin: 0 0 1.4rem;
    }

    .cta-btn {
        display: inline-block;
        background: var(--accent);
        color: var(--text);
        font-weight: 700;
        font-size: 0.9rem;
        padding: 0.65rem 1.8rem;
        border-radius: 8px;
        text-decoration: none;
        transition: opacity 0.2s, transform 0.1s;
        margin: 0 0.3rem;
    }

    .cta-btn:hover {
        opacity: 0.9;
        transform: translateY(-1px);
        color: var(--text);
        text-decoration: none;
    }

    .cta-btn.outline {
        background: transparent;
        border: 2px solid rgba(255,255,255,0.5);
        color: #fff;
    }

    .cta-btn.outline:hover { color: #fff; border-color: #fff; }

    @media (max-width: 600px) {
        .stats-row      { grid-template-columns: 1fr 1fr; }
        .mv-grid        { grid-template-columns: 1fr; }
        .values-grid    { grid-template-columns: 1fr; }
        .about-hero     { padding: 2.5rem 1.5rem; }
    }
</style>
 
<div class="about-hero">
    <div class="hero-eyebrow">KuGompo City, Eastern Cape</div>
    <h1>Connecting the <span>Townships</span> to<br />Quality Services</h1>
    <div class="hero-accent-bar"></div>
    <p class="lead">
        Unleashing Potential is a community-driven platform that bridges the gap
        between skilled local service providers and the households that need them, all
        right here in KuGompo City.
    </p>
</div>


<div class="stats-row">
    <div class="stat-card">
        <div class="stat-number">4+</div>
        <div class="stat-label">Service Categories</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">4</div>
        <div class="stat-label">Townships Served</div>
    </div>
    <div class="stat-card">
        <div class="stat-number">100%</div>
        <div class="stat-label">Local Providers</div>
    </div>
</div>


<div class="mv-grid">
    <div class="mv-card mission">
        <div class="mv-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                 viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M13 10V3L4 14h7v7l9-11h-7z" />
            </svg>
        </div>
        <h3>Our Mission</h3>
        <p>To empower local talent and make quality household services accessible
           to every family in KuGompo City providing fairly priced services that are easy to book, and
           delivered by people from the community.</p>
    </div>
    <div class="mv-card vision">
        <div class="mv-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="none"
                 viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943
                         9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
        </div>
        <h3>Our Vision</h3>
        <p>A thriving KuGompo City where local service providers earn a sustainable
           income, every resident has access to trusted help, and the township
           economy grows from within.</p>
    </div>
</div>

<div class="values-section">
    <p class="section-heading">What We Stand For</p>
    <p class="section-sub">The principles that guide everything we do.</p>
    <div class="values-grid">
        <div class="value-item">
            <div class="value-dot">&#127968;</div>
            <div class="value-text">
                <strong>Community First</strong>
                <span>Every decision we make puts KuGompo City residents and providers at the centre.</span>
            </div>
        </div>
        <div class="value-item">
            <div class="value-dot">&#9989;</div>
            <div class="value-text">
                <strong>Trust &amp; Quality</strong>
                <span>All service providers are reviewed by real customers so you always know what to expect.</span>
            </div>
        </div>
        <div class="value-item">
            <div class="value-dot">&#128203;</div>
            <div class="value-text">
                <strong>Transparency</strong>
                <span>Clear pricing, honest reviews, and no hidden fees.</span>
            </div>
        </div>
        <div class="value-item">
            <div class="value-dot">&#127775;</div>
            <div class="value-text">
                <strong>Local Pride</strong>
                <span>We celebrate the skill and dedication of Kasi entrepreneurs and tradespeople.</span>
            </div>
        </div>
    </div>
</div>

<div class="story-section">
    <p class="section-heading" style="margin-bottom:0.8rem;">Our Story</p>
    <p>
        Unleashing Potential was born out of a simple observation: KuGompo City is full of
        talented, hardworking people such as plumbers, tailors, painters, hairdressers, and more but
        residents often struggle to find and trust local help. At the same time, skilled
        providers had no easy way to reach customers beyond word of mouth.
        <br /><br />
        We built this platform to change that. By bringing bookings, reviews, and payments
        into one place, we make it easier for the Kasi to support itself and to show the
        world the incredible potential that has always been here.
    </p>
</div>


<div class="cta-banner">
    <h3>Ready to get started?</h3>
    <p>Join our growing community of providers and customers today.</p>
    <a href="Register.aspx" class="cta-btn">Create an Account</a>
    <a href="Login.aspx"    class="cta-btn outline">Sign In</a>
</div>

</asp:Content>