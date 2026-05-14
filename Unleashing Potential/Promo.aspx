<%@ Page Title="Unleashing Potential Promo" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Promo.aspx.cs" Inherits="Unleashing_Potential.Promo" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .promo-hero {
            background: linear-gradient(135deg, #0f172a, #0c4a6e, #0284c7);
            color: white;
            padding: 100px 20px;
            text-align: center;
        }

        .promo-hero h1 {
            font-size: 3.5rem;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .promo-hero p {
            font-size: 1.2rem;
            max-width: 700px;
            margin: auto;
            color: #dbeafe;
        }

        .promo-buttons {
            margin-top: 35px;
        }

        .promo-buttons a {
            margin: 10px;
            padding: 14px 28px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: bold;
            display: inline-block;
        }

        .btn-primary-custom {
            background: #facc15;
            color: #111827;
        }

        .btn-primary-custom:hover {
            background: #eab308;
            color: #111827;
        }

        .btn-secondary-custom {
            border: 2px solid white;
            color: white;
        }

        .btn-secondary-custom:hover {
            background: white;
            color: #0c4a6e;
        }

        .features-section {
            padding: 80px 20px;
            background: #f8fafc;
            text-align: center;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-top: 40px;
        }

        .feature-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            transition: 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-8px);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 15px;
        }

        .stats-section {
            background: #0c4a6e;
            color: white;
            padding: 70px 20px;
            text-align: center;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 30px;
            margin-top: 40px;
        }

        .stat-box h2 {
            font-size: 3rem;
            color: #facc15;
        }

        .testimonial-section {
            padding: 80px 20px;
            background: #e0f2fe;
            text-align: center;
        }

        .testimonial-card {
            background: white;
            max-width: 700px;
            margin: auto;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            font-style: italic;
        }

        .cta-section {
            padding: 90px 20px;
            text-align: center;
            background: linear-gradient(135deg, #0369a1, #0f172a);
            color: white;
        }

        .cta-section h2 {
            font-size: 2.5rem;
            margin-bottom: 20px;
        }

        @media (max-width: 768px) {
            .promo-hero h1 {
                font-size: 2.4rem;
            }

            .promo-hero p {
                font-size: 1rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    <!-- HERO SECTION -->
    <section class="promo-hero">
        <h1>Empowering Local Talent Across South Africa</h1>

        <p>
            Unleashing Potential connects communities with trusted local service providers.
            Customers can browse services, track bookings, and support small businesses from one place.
        </p>

        <div class="promo-buttons">
            <a href="ServiceCategories.aspx" class="btn-primary-custom">Browse Services</a>
            <a href="ServiceProviderDashboard.aspx" class="btn-secondary-custom">Service Provider Portal</a>
            <a href="Admin.aspx" class="btn-primary-custom">Admin Panel</a>
        </div>
    </section>


    <!-- FEATURES -->
    <section class="features-section">
        <div class="container">
            <h2>Why Choose Unleashing Potential?</h2>

            <h4 style="margin-top:20px; color:#475569;">
                Customers can browse and book services, service providers can manage listings,
                and administrators can oversee users, bookings, and reports.
            </h4>

            <div class="features-grid">

                <div class="feature-card">
                    <div class="feature-icon">🔍</div>
                    <h4>Easy Discovery</h4>
                    <p>Find trusted plumbers, hairdressers, painters, tailors, and more in your community.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">🤝</div>
                    <h4>Trusted Connections</h4>
                    <p>Connect directly with verified service providers and support local businesses.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">📈</div>
                    <h4>Grow Your Business</h4>
                    <p>Service providers can showcase their skills and attract more customers online.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">⭐</div>
                    <h4>Community Reviews</h4>
                    <p>Customers can leave reviews and ratings to help others choose quality services.</p>
                </div>

            </div>
        </div>
    </section>


    <!-- STATS -->
    <section class="stats-section">
        <div class="container">
            <h2>Our Growing Community</h2>

            <div class="stats-grid">
                <div class="stat-box">
                    <h2>500+</h2>
                    <p>Registered Users</p>
                </div>

                <div class="stat-box">
                    <h2>120+</h2>
                    <p>Service Providers</p>
                </div>

                <div class="stat-box">
                    <h2>1K+</h2>
                    <p>Bookings Completed</p>
                </div>
            </div>
        </div>
    </section>


    <!-- TESTIMONIAL -->
    <section class="testimonial-section">
        <h2>What Our Users Say</h2>

        <div class="testimonial-card">
            “Unleashing Potential helped me find reliable local services quickly.
            The platform is easy to use and supports small businesses in our community.”
            <br /><br />
            <strong>- Happy Customer</strong>
        </div>
    </section>


    <!-- FINAL CTA -->
    <section class="cta-section">
        <h2>Ready to Unlock Opportunities?</h2>

        <p>
            Join the growing platform that connects communities with skilled local talent.
        </p>

        <br />

        <a href="RegisterServiceProvider.aspx" class="btn btn-warning btn-lg">
            Become a Service Provider
        </a>
    </section>

</asp:Content>
