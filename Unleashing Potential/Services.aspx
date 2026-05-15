<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Services.aspx.cs" Inherits="Unleashing_Potential.WebForm3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <link href="https://fonts.googleapis.com/css2?family=Lora:wght@600;700&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet" />

    <style>
        :root {
            --sky:         #0ea5e9;
            --sky-dark:    #0369a1;
            --sky-deeper:  #0c4a6e;
            --sky-light:   #bae6fd;
            --sky-pale:    #f0f9ff;
            --sky-mid:     #e0f2fe;
            --muted:       #64748b;
            --muted-light: #94a3b8;
            --white:       #ffffff;
            --card-shadow: 0 2px 12px rgba(12,74,110,0.07);
            --card-shadow-hover: 0 12px 32px rgba(12,74,110,0.16);
        }

        body, .services-wrap * {
            font-family: 'DM Sans', sans-serif;
        }

        /* ── Page wrapper ── */
        .services-wrap {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 0 3rem;
        }

        /* ── Header ── */
        .services-header {
            position: relative;
            background: linear-gradient(135deg, var(--sky-deeper) 0%, var(--sky-dark) 100%);
            border-radius: 20px;
            padding: 2.6rem 2.8rem 2.4rem;
            margin-bottom: 2.4rem;
            overflow: hidden;
        }

        /* decorative circles */
        .services-header::before,
        .services-header::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
            pointer-events: none;
        }
        .services-header::before {
            width: 260px; height: 260px;
            top: -80px; right: -60px;
        }
        .services-header::after {
            width: 140px; height: 140px;
            bottom: -50px; right: 160px;
        }

        .services-header-inner {
            position: relative;
            z-index: 1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .services-header h2 {
            font-family: 'Lora', serif;
            color: #f0f9ff;
            font-size: 1.85rem;
            font-weight: 700;
            margin: 0 0 0.3rem;
            letter-spacing: -0.01em;
        }

        .services-header p {
            color: var(--sky-light);
            font-size: 0.92rem;
            margin: 0;
            opacity: 0.88;
        }

        .services-badge {
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.2);
            color: #e0f2fe;
            font-size: 0.78rem;
            font-weight: 600;
            padding: 0.4rem 0.9rem;
            border-radius: 999px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        /* ── Grid ── */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 1.5rem;
        }

        /* ── Card ── */
        .service-card {
            background: var(--white);
            border-radius: 18px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(14,165,233,0.10);
            transition: transform 0.28s cubic-bezier(.22,.68,0,1.2),
                        box-shadow 0.28s ease,
                        border-color 0.28s ease;

            /* staggered entrance */
            opacity: 0;
            animation: cardIn 0.5s ease forwards;
        }
        .service-card:nth-child(1) { animation-delay: 0.05s; }
        .service-card:nth-child(2) { animation-delay: 0.14s; }
        .service-card:nth-child(3) { animation-delay: 0.23s; }
        .service-card:nth-child(4) { animation-delay: 0.32s; }

        @keyframes cardIn {
            from { opacity: 0; transform: translateY(18px); }
            to   { opacity: 1; transform: translateY(0);    }
        }

        .service-card:hover {
            transform: translateY(-7px);
            box-shadow: var(--card-shadow-hover);
            border-color: rgba(14,165,233,0.30);
        }

        /* ── Card image area ── */
        .service-card-img {
            position: relative;
            overflow: hidden;
            height: 168px;
            background: var(--sky-mid);
        }

        .service-card-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
            transition: transform 0.4s ease;
        }

        .service-card:hover .service-card-img img {
            transform: scale(1.06);
        }

        /* category pill overlay */
        .service-pill {
            position: absolute;
            top: 10px;
            left: 12px;
            background: rgba(12,74,110,0.72);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            color: #e0f2fe;
            font-size: 0.72rem;
            font-weight: 600;
            padding: 0.28rem 0.7rem;
            border-radius: 999px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        /* ── Card body ── */
        .service-card-body {
            padding: 1.25rem 1.3rem 1.5rem;
            display: flex;
            flex-direction: column;
            flex: 1;
            gap: 0.55rem;
        }

    
        .service-accent {
            width: 36px;
            height: 3px;
            border-radius: 999px;
            background: linear-gradient(90deg, var(--sky), var(--sky-dark));
            margin-bottom: 0.1rem;
        }

        .service-card-body h5 {
            font-family: 'Lora', serif;
            color: var(--sky-deeper);
            font-size: 1.05rem;
            font-weight: 700;
            margin: 0;
            letter-spacing: -0.01em;
        }

        .service-card-body p {
            font-size: 0.84rem;
            color: var(--muted);
            margin: 0;
            line-height: 1.6;
            flex: 1;
        }

        .btn-service {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            background: linear-gradient(135deg, var(--sky), var(--sky-dark));
            border: none;
            color: white !important;
            font-family: 'DM Sans', sans-serif;
            font-weight: 600;
            font-size: 0.83rem;
            padding: 0.58rem 1.3rem;
            border-radius: 10px;
            cursor: pointer;
            transition: opacity 0.2s, transform 0.15s;
            align-self: flex-start;
            margin-top: 0.3rem;
        }

        .btn-service::after {
            content: '→';
            font-size: 0.9rem;
            transition: transform 0.2s;
            display: inline-block;
        }

        .btn-service:hover {
            opacity: 0.88;
            transform: translateY(-1px);
        }

        .btn-service:hover::after {
            transform: translateX(3px);
        }

        .btn-service:active {
            transform: scale(0.97);
        }
    </style>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="services-wrap">

        <div class="services-header">
            <div class="services-header-inner">
                <div>
                    <h2>Our Services</h2>
                    <p>Connecting communities with trusted local skills.</p>
                </div>
                <span class="services-badge">4 Services Available</span>
            </div>
        </div>

        <div class="services-grid">

            <div class="service-card">
                <div class="service-card-img">
                    <img src="images/hairdressing.png" alt="Hairdressing" />
                    <span class="service-pill">Beauty</span>
                </div>
                <div class="service-card-body">
                    <div class="service-accent"></div>
                    <h5>Hairdressing</h5>
                    <p>Professional braiding, styling and grooming services.</p>
                    <asp:Button runat="server" ID="btnHairdressing" Text="Request Service"
                        CssClass="btn-service" CausesValidation="false"
                        OnClick="btnRequestService_Click" />
                </div>
            </div>

            <div class="service-card">
                <div class="service-card-img">
                    <img src="images/tailoring.png" alt="Tailoring" />
                    <span class="service-pill">Fashion</span>
                </div>
                <div class="service-card-body">
                    <div class="service-accent"></div>
                    <h5>Tailoring</h5>
                    <p>Clothing design, alterations and fashion repairs.</p>
                    <asp:Button runat="server" ID="btnTailoring" Text="Request Service"
                        CssClass="btn-service" CausesValidation="false"
                        OnClick="btnRequestService_Click" />
                </div>
            </div>

            <div class="service-card">
                <div class="service-card-img">
                    <img src="images/plumbing.png" alt="Plumbing" />
                    <span class="service-pill">Trade</span>
                </div>
                <div class="service-card-body">
                    <div class="service-accent"></div>
                    <h5>Plumbing</h5>
                    <p>Pipe installation, leak repairs and plumbing maintenance.</p>
                    <asp:Button runat="server" ID="btnPlumbing" Text="Request Service"
                        CssClass="btn-service" CausesValidation="false"
                        OnClick="btnRequestService_Click" />
                </div>
            </div>

            <div class="service-card">
                <div class="service-card-img">
                    <img src="images/painting.png" alt="Painting" />
                    <span class="service-pill">Trade</span>
                </div>
                <div class="service-card-body">
                    <div class="service-accent"></div>
                    <h5>Painting</h5>
                    <p>Interior and exterior painting for homes and businesses.</p>
                    <asp:Button runat="server" ID="btnPainting" Text="Request Service"
                        CssClass="btn-service" CausesValidation="false"
                        OnClick="btnRequestService_Click" />
                </div>
            </div>

        </div>

    </div>

</asp:Content>











