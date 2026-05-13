<%@ Page Title="Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Unleashing_Potential.Contact" %>

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

    /* ── Hero ───────────────────────────────────────────── */
    .contact-hero {
        position: relative;
        background: linear-gradient(135deg, var(--sky-deeper) 0%, var(--sky-dark) 60%, #0284c7 100%);
        border-radius: 20px;
        padding: 4rem 2.5rem 3.5rem;
        margin-bottom: 3rem;
        overflow: hidden;
        color: #fff;
    }

    .contact-hero::before {
        content: '';
        position: absolute;
        top: -60px; right: -60px;
        width: 280px; height: 280px;
        border-radius: 50%;
        background: rgba(255,255,255,0.06);
        pointer-events: none;
    }

    .contact-hero::after {
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

    .contact-hero h1 {
        font-family: 'Lora', serif;
        font-size: clamp(1.9rem, 4vw, 2.8rem);
        font-weight: 700;
        line-height: 1.2;
        margin: 0 0 1rem;
        color: #fff;
    }

    .contact-hero h1 span { color: var(--accent); }

    .contact-hero .lead {
        font-size: 1rem;
        color: rgba(255,255,255,0.82);
        max-width: 520px;
        line-height: 1.75;
        margin: 0;
    }

    .hero-accent-bar {
        width: 48px; height: 4px;
        background: var(--accent);
        border-radius: 4px;
        margin: 1.2rem 0;
    }

    /* ── Contact cards ───────────────────────────────────── */
    .contact-cards {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 1.2rem;
        margin-bottom: 3rem;
    }

    .contact-card {
        background: #fff;
        border: 1.5px solid var(--sky-light);
        border-radius: 16px;
        padding: 1.8rem 1.4rem;
        text-align: center;
        box-shadow: 0 2px 12px rgba(12,74,110,0.07);
        transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
        text-decoration: none;
        display: block;
        color: inherit;
    }

    .contact-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 28px rgba(12,74,110,0.13);
        border-color: var(--sky);
        text-decoration: none;
        color: inherit;
    }

    .contact-card-icon {
        width: 52px; height: 52px;
        border-radius: 14px;
        background: var(--sky-pale);
        border: 1.5px solid var(--sky-light);
        display: flex; align-items: center; justify-content: center;
        margin: 0 auto 1.1rem;
        color: var(--sky-dark);
    }

    .contact-card-icon svg { width: 22px; height: 22px; }

    .contact-card-label {
        font-size: 0.72rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--muted);
        margin-bottom: 0.4rem;
    }

    .contact-card-value {
        font-size: 0.92rem;
        font-weight: 600;
        color: var(--sky-dark);
        line-height: 1.5;
        word-break: break-word;
    }

    .contact-card-hint {
        font-size: 0.78rem;
        color: var(--muted);
        margin-top: 0.3rem;
    }

    /* ── Two-column layout (map + hours) ─────────────────── */
    .contact-lower {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1.2rem;
        margin-bottom: 3rem;
    }

    /* ── Map card ────────────────────────────────────────── */
    .map-card {
        background: #fff;
        border: 1.5px solid var(--sky-light);
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(12,74,110,0.07);
    }

    .map-card-header {
        padding: 1.2rem 1.5rem 0.8rem;
        border-bottom: 1px solid #e0f2fe;
    }

    .map-card-header h3 {
        font-family: 'Lora', serif;
        font-size: 1rem;
        font-weight: 700;
        color: var(--sky-deeper);
        margin: 0 0 0.15rem;
    }

    .map-card-header p {
        font-size: 0.82rem;
        color: var(--muted);
        margin: 0;
    }

    .map-embed {
        width: 100%;
        height: 220px;
        border: none;
        display: block;
        filter: saturate(0.85);
    }

    /* ── Hours card ──────────────────────────────────────── */
    .hours-card {
        background: #fff;
        border: 1.5px solid var(--sky-light);
        border-radius: 16px;
        padding: 1.5rem;
        box-shadow: 0 2px 12px rgba(12,74,110,0.07);
    }

    .hours-card h3 {
        font-family: 'Lora', serif;
        font-size: 1rem;
        font-weight: 700;
        color: var(--sky-deeper);
        margin: 0 0 1.1rem;
    }

    .hours-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0.6rem 0;
        border-bottom: 1px solid #f0f9ff;
        font-size: 0.88rem;
    }

    .hours-row:last-child { border-bottom: none; }

    .hours-day { color: var(--text); font-weight: 500; }

    .hours-time {
        color: var(--sky-dark);
        font-weight: 600;
    }

    .hours-time.closed { color: #94a3b8; font-weight: 400; }

    .hours-badge {
        display: inline-block;
        background: #dcfce7;
        color: #15803d;
        font-size: 0.7rem;
        font-weight: 700;
        padding: 0.15rem 0.55rem;
        border-radius: 100px;
        margin-left: 0.4rem;
        vertical-align: middle;
    }

    /* ── FAQ strip ───────────────────────────────────────── */
    .faq-section { margin-bottom: 3rem; }

    .faq-heading {
        font-family: 'Lora', serif;
        font-size: 1.3rem;
        font-weight: 700;
        color: var(--sky-deeper);
        margin: 0 0 0.25rem;
    }

    .faq-sub {
        font-size: 0.88rem;
        color: var(--muted);
        margin: 0 0 1.2rem;
    }

    .faq-item {
        background: var(--sky-pale);
        border: 1.5px solid var(--sky-light);
        border-radius: 12px;
        margin-bottom: 0.7rem;
        overflow: hidden;
    }

    .faq-question {
        width: 100%;
        background: none;
        border: none;
        padding: 1rem 1.2rem;
        text-align: left;
        font-size: 0.9rem;
        font-weight: 600;
        color: var(--sky-deeper);
        cursor: pointer;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 1rem;
    }

    .faq-question:hover { color: var(--sky-dark); }

    .faq-chevron {
        flex-shrink: 0;
        transition: transform 0.25s;
        color: var(--sky);
    }

    .faq-item.open .faq-chevron { transform: rotate(180deg); }

    .faq-answer {
        display: none;
        padding: 0 1.2rem 1rem;
        font-size: 0.88rem;
        color: var(--muted);
        line-height: 1.7;
    }

    .faq-item.open .faq-answer { display: block; }

    /* ── CTA banner ──────────────────────────────────────── */
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

    /* ── Responsive ──────────────────────────────────────── */
    @media (max-width: 700px) {
        .contact-cards  { grid-template-columns: 1fr; }
        .contact-lower  { grid-template-columns: 1fr; }
        .contact-hero   { padding: 2.5rem 1.5rem; }
    }
</style>

<%-- ── HERO ──────────────────────────────────────────────────── --%>
<div class="contact-hero">
    <div class="hero-eyebrow">We&rsquo;re here to help</div>
    <h1>Get in <span>Touch</span><br />With Us</h1>
    <div class="hero-accent-bar"></div>
    <p class="lead">
        Have a question, need support, or want to join our network of local
        service providers? We&rsquo;d love to hear from you.
    </p>
</div>

<%-- ── CONTACT CARDS ───────────────────────────────────────────── --%>
<div class="contact-cards">

    <%-- Email --%>
    <a href="mailto:unleashingpotential@gmail.com" class="contact-card">
        <div class="contact-card-icon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                 stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7
                         a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
            </svg>
        </div>
        <div class="contact-card-label">Email Us</div>
        <div class="contact-card-value">unleashingpotential<br />@gmail.com</div>
        <div class="contact-card-hint">We reply within 24 hours</div>
    </a>

    <%-- Phone --%>
    <a href="tel:+27731234567" class="contact-card">
        <div class="contact-card-icon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                 stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0
                         01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13
                         -2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2
                         2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
            </svg>
        </div>
        <div class="contact-card-label">Call Us</div>
        <div class="contact-card-value">+27 73 123 4567</div>
        <div class="contact-card-hint">Mon – Fri, 8 AM – 5 PM</div>
    </a>

    <%-- Location --%>
    <div class="contact-card" style="cursor:default;">
        <div class="contact-card-icon">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"
                 stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827
                         0l-4.244-4.243a8 8 0 1111.314 0z" />
                <path stroke-linecap="round" stroke-linejoin="round"
                      d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
            </svg>
        </div>
        <div class="contact-card-label">Find Us</div>
        <div class="contact-card-value">Mdantsane, East London<br />Eastern Cape, SA</div>
        <div class="contact-card-hint">Serving all Mdantsane units</div>
    </div>

</div>

<%-- ── MAP + HOURS ─────────────────────────────────────────────── --%>
<div class="contact-lower">

    <%-- Embedded map --%>
    <div class="map-card">
        <div class="map-card-header">
            <h3>Our Location</h3>
            <p>Mdantsane, East London, Eastern Cape</p>
        </div>
        <iframe class="map-embed"
            src="https://www.openstreetmap.org/export/embed.html?bbox=27.8500%2C-32.9300%2C27.9500%2C-32.8500&amp;layer=mapnik&amp;marker=-32.8900%2C27.9000"
            title="Mdantsane, East London map">
        </iframe>
    </div>

    <%-- Office hours --%>
    <div class="hours-card">
        <h3>Office Hours</h3>
        <div class="hours-row">
            <span class="hours-day">Monday</span>
            <span class="hours-time">08:00 – 17:00 <span class="hours-badge">Open</span></span>
        </div>
        <div class="hours-row">
            <span class="hours-day">Tuesday</span>
            <span class="hours-time">08:00 – 17:00</span>
        </div>
        <div class="hours-row">
            <span class="hours-day">Wednesday</span>
            <span class="hours-time">08:00 – 17:00</span>
        </div>
        <div class="hours-row">
            <span class="hours-day">Thursday</span>
            <span class="hours-time">08:00 – 17:00</span>
        </div>
        <div class="hours-row">
            <span class="hours-day">Friday</span>
            <span class="hours-time">08:00 – 16:00</span>
        </div>
        <div class="hours-row">
            <span class="hours-day">Saturday</span>
            <span class="hours-time">09:00 – 13:00</span>
        </div>
        <div class="hours-row">
            <span class="hours-day">Sunday</span>
            <span class="hours-time closed">Closed</span>
        </div>
    </div>

</div>

<%-- ── FAQ ─────────────────────────────────────────────────────── --%>
<div class="faq-section">
    <p class="faq-heading">Frequently Asked Questions</p>
    <p class="faq-sub">Quick answers before you reach out.</p>

    <div class="faq-item">
        <button class="faq-question" onclick="toggleFaq(this)">
            How do I book a service provider?
            <svg class="faq-chevron" xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                 fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
        </button>
        <div class="faq-answer">
            Create a free account, browse service providers by category, add your preferred
            provider to your basket, and complete the booking with your chosen payment method.
            You will receive a reference number to track your booking.
        </div>
    </div>

    <div class="faq-item">
        <button class="faq-question" onclick="toggleFaq(this)">
            How do I register as a service provider?
            <svg class="faq-chevron" xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                 fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
        </button>
        <div class="faq-answer">
            Send us an email at unleashingpotential@gmail.com or call us directly.
            Our team will guide you through the onboarding process and get your
            profile listed on the platform.
        </div>
    </div>

    <div class="faq-item">
        <button class="faq-question" onclick="toggleFaq(this)">
            What areas do you currently serve?
            <svg class="faq-chevron" xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                 fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
        </button>
        <div class="faq-answer">
            We currently serve Quigney, Southernwood, Beacon Bay, and Mdantsane.
            We are actively expanding — contact us if you would like to see your
            area added.
        </div>
    </div>

    <div class="faq-item">
        <button class="faq-question" onclick="toggleFaq(this)">
            I forgot my password. What do I do?
            <svg class="faq-chevron" xmlns="http://www.w3.org/2000/svg" width="18" height="18"
                 fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
            </svg>
        </button>
        <div class="faq-answer">
            Click the <a href="ForgotPassword.aspx" style="color:var(--sky-dark);font-weight:600;">
            Forgot Password</a> link on the login page. You will be guided through a
            three-step security question reset process.
        </div>
    </div>

</div>

<%-- ── CTA ─────────────────────────────────────────────────────── --%>
<div class="cta-banner">
    <h3>Still have questions?</h3>
    <p>Our team is happy to help. Drop us an email and we&rsquo;ll get back to you.</p>
    <a href="mailto:unleashingpotential@gmail.com" class="cta-btn">
        Email Us Now
    </a>
</div>

<script>
    function toggleFaq(btn) {
        var item = btn.closest('.faq-item');
        item.classList.toggle('open');
    }
</script>

</asp:Content>