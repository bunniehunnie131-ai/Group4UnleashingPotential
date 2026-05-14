<%@ Page Title="Customer Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ServiceCategories.aspx.cs" Inherits="Unleashing_Potential.WebForm6" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --sky: #0ea5e9;
            --sky-dark: #0369a1;
            --sky-deeper: #0c4a6e;
            --sky-light: #bae6fd;
            --sky-pale: #f0f9ff;
            --ink: #0f172a;
            --muted: #64748b;
            --border: rgba(12, 74, 110, 0.12);
        }

        body {
            background:
                radial-gradient(circle at top left, rgba(14, 165, 233, 0.14), transparent 32%),
                radial-gradient(circle at top right, rgba(245, 158, 11, 0.10), transparent 28%),
                var(--sky-pale);
        }

        .customer-shell {
            max-width: 1180px;
            margin: 0 auto;
            display: grid;
            gap: 1.35rem;
        }

        .hero-band {
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #0b4f73 0%, var(--sky-dark) 45%, var(--sky) 100%);
            color: #fff;
            border-radius: 28px;
            padding: 2rem;
            box-shadow: 0 24px 48px rgba(3, 105, 161, 0.2);
        }

        .hero-band::after {
            content: "";
            position: absolute;
            inset: auto -8rem -8rem auto;
            width: 18rem;
            height: 18rem;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.12);
            filter: blur(6px);
            pointer-events: none;
        }

        .hero-grid {
            position: relative;
            z-index: 1;
            display: grid;
            grid-template-columns: minmax(0, 1.55fr) minmax(260px, 0.85fr);
            gap: 1.25rem;
            align-items: stretch;
        }

        .hero-copy h2 {
            font-family: 'Lora', serif;
            font-size: clamp(2rem, 3vw, 2.75rem);
            line-height: 1.08;
            margin: 0 0 0.85rem;
        }

        .hero-copy p {
            margin: 0;
            max-width: 44rem;
            color: rgba(255, 255, 255, 0.86);
            font-size: 0.98rem;
            line-height: 1.72;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.38rem 0.78rem;
            margin-bottom: 0.9rem;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.2);
            font-size: 0.8rem;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .hero-meta {
            display: flex;
            gap: 0.65rem;
            flex-wrap: wrap;
            margin-top: 1.2rem;
        }

        .hero-meta span {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.6rem 0.9rem;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.16);
            color: #fff;
            font-size: 0.84rem;
            font-weight: 600;
        }

        .teaser-card {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 1rem;
            min-height: 100%;
            padding: 1.35rem;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.09);
            border: 1px solid rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(10px);
        }

        .teaser-card h3 {
            font-family: 'Lora', serif;
            margin: 0;
            font-size: 1.35rem;
        }

        .teaser-card p {
            margin: 0;
            color: rgba(255, 255, 255, 0.84);
            line-height: 1.65;
            font-size: 0.92rem;
        }

        .teaser-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 1rem;
        }

        .stat-card {
            background: rgba(255, 255, 255, 0.96);
            border: 1px solid var(--border);
            border-radius: 22px;
            padding: 1.15rem 1.2rem;
            box-shadow: 0 16px 32px rgba(15, 23, 42, 0.08);
        }

        .stat-value {
            display: block;
            font-size: 1.8rem;
            line-height: 1;
            font-weight: 800;
            color: var(--ink);
            margin-bottom: 0.35rem;
        }

        .stat-label {
            display: block;
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--muted);
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 1rem;
        }

        .action-card {
            display: flex;
            align-items: flex-start;
            gap: 0.95rem;
            padding: 1.15rem 1.2rem;
            border-radius: 20px;
            text-decoration: none;
            color: inherit;
            background: linear-gradient(180deg, #ffffff, #f8fbff);
            border: 1px solid rgba(14, 165, 233, 0.14);
            box-shadow: 0 12px 24px rgba(12, 74, 110, 0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .action-card:hover {
            color: inherit;
            text-decoration: none;
            transform: translateY(-3px);
            box-shadow: 0 18px 30px rgba(12, 74, 110, 0.14);
        }

        .action-icon {
            width: 46px;
            height: 46px;
            border-radius: 14px;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, var(--sky), var(--sky-dark));
            color: #fff;
            font-size: 1.15rem;
            flex-shrink: 0;
        }

        .action-card h3 {
            margin: 0 0 0.25rem;
            font-size: 1rem;
            color: var(--ink);
        }

        .action-card p {
            margin: 0;
            color: var(--muted);
            font-size: 0.86rem;
            line-height: 1.55;
        }

        .section-card {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 28px;
            padding: 1.4rem;
            box-shadow: 0 16px 34px rgba(12, 74, 110, 0.08);
            border: 1px solid rgba(14, 165, 233, 0.1);
        }

        .section-head {
            display: flex;
            justify-content: space-between;
            gap: 1rem;
            align-items: end;
            margin-bottom: 1rem;
        }

        .section-head h3 {
            margin: 0;
            font-family: 'Lora', serif;
            color: var(--sky-deeper);
            font-size: 1.34rem;
        }

        .section-head p {
            margin: 0;
            color: var(--muted);
            font-size: 0.9rem;
        }

        .catalog-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
        }

        .catalog-card {
            overflow: hidden;
            display: flex;
            flex-direction: column;
            text-decoration: none;
            color: inherit;
            background: #fff;
            border-radius: 22px;
            border: 1px solid #d9ecfb;
            box-shadow: 0 12px 24px rgba(12, 74, 110, 0.08);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .catalog-card:hover {
            color: inherit;
            text-decoration: none;
            transform: translateY(-4px);
            box-shadow: 0 18px 32px rgba(12, 74, 110, 0.16);
        }

        .catalog-image {
            height: 170px;
            background: linear-gradient(135deg, #e0f2fe, #bae6fd);
            overflow: hidden;
        }

        .catalog-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .catalog-body {
            padding: 1.1rem 1.15rem 1.2rem;
            display: flex;
            flex-direction: column;
            gap: 0.7rem;
        }

        .catalog-body h4 {
            margin: 0;
            font-family: 'Lora', serif;
            color: var(--sky-deeper);
            font-size: 1.08rem;
        }

        .catalog-body p {
            margin: 0;
            color: var(--muted);
            font-size: 0.88rem;
            line-height: 1.55;
        }

        .catalog-meta {
            display: flex;
            justify-content: space-between;
            gap: 0.75rem;
            align-items: center;
            margin-top: auto;
            font-size: 0.8rem;
            font-weight: 700;
            color: var(--sky-dark);
        }

        .catalog-link {
            color: var(--sky-dark);
            text-decoration: none;
        }

        .recent-card {
            display: grid;
            gap: 0.85rem;
        }

        .booking-card {
            padding: 1rem 1.05rem;
            border-radius: 20px;
            background: #f8fbff;
            border: 1px solid rgba(12, 74, 110, 0.12);
        }

        .booking-top {
            display: flex;
            justify-content: space-between;
            gap: 0.75rem;
            flex-wrap: wrap;
            align-items: flex-start;
        }

        .booking-ref {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.35rem 0.65rem;
            border-radius: 999px;
            background: #e0f2fe;
            color: var(--sky-deeper);
            font-size: 0.76rem;
            font-weight: 800;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .booking-card h4 {
            margin: 0.6rem 0 0.2rem;
            font-size: 1rem;
            color: var(--ink);
        }

        .booking-subline {
            margin: 0;
            color: var(--muted);
            font-size: 0.86rem;
            line-height: 1.55;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.34rem 0.74rem;
            border-radius: 999px;
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .status-pending { background: #fff3cd; color: #7c5e00; }
        .status-confirmed { background: #dbeafe; color: #1e40af; }
        .status-completed { background: #d1e7dd; color: #0f5132; }
        .status-cancelled { background: #f8d7da; color: #842029; }

        .booking-tags {
            display: flex;
            flex-wrap: wrap;
            gap: 0.45rem;
            margin-top: 0.85rem;
        }

        .booking-pill {
            display: inline-flex;
            align-items: center;
            padding: 0.35rem 0.65rem;
            border-radius: 999px;
            background: #fff;
            border: 1px solid rgba(12, 74, 110, 0.12);
            color: var(--sky-deeper);
            font-size: 0.75rem;
            font-weight: 700;
        }

        .booking-pill.more {
            background: #eef6fb;
            color: var(--muted);
        }

        .booking-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 0.6rem;
            margin-top: 0.9rem;
        }

        .btn-inline {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.55rem 0.95rem;
            border-radius: 999px;
            background: linear-gradient(135deg, var(--sky), var(--sky-dark));
            color: #fff;
            text-decoration: none;
            font-size: 0.82rem;
            font-weight: 800;
            border: 0;
        }

        .btn-inline:hover {
            color: #fff;
            text-decoration: none;
        }

        .btn-inline.alt {
            background: #fff;
            color: var(--sky-dark);
            border: 1px solid rgba(12, 74, 110, 0.16);
        }

        .empty-state {
            padding: 1.4rem 1rem 0.6rem;
            text-align: center;
        }

        .empty-state h4 {
            margin: 0 0 0.4rem;
            color: var(--ink);
        }

        .empty-state p {
            margin: 0;
            color: var(--muted);
            line-height: 1.6;
        }

        .basket-btn {
            position: fixed;
            bottom: 1.6rem;
            right: 1.6rem;
            background: linear-gradient(135deg, var(--sky), var(--sky-dark));
            color: #fff;
            border: none;
            border-radius: 999px;
            padding: 0.75rem 1.15rem;
            font-size: 0.9rem;
            font-weight: 700;
            box-shadow: 0 10px 24px rgba(14, 165, 233, 0.34);
            cursor: pointer;
            z-index: 999;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .basket-btn:hover {
            color: #fff;
            text-decoration: none;
        }

        .basket-badge {
            background: #fff;
            color: var(--sky-dark);
            border-radius: 999px;
            min-width: 22px;
            height: 22px;
            padding: 0 0.35rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.74rem;
            font-weight: 800;
        }

        @media (max-width: 992px) {
            .hero-grid,
            .stat-grid,
            .action-grid {
                grid-template-columns: 1fr;
            }

            .basket-btn {
                right: 1rem;
                bottom: 1rem;
            }
        }

        @media (max-width: 640px) {
            .hero-band,
            .section-card {
                border-radius: 22px;
                padding: 1.1rem;
            }

            .section-head {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="customer-shell">
        <section class="hero-band">
            <div class="hero-grid">
                <div class="hero-copy">
                    <span class="eyebrow">Customer home</span>
                    <h2>Welcome back, <asp:Label ID="lblUserName" runat="server" />!</h2>
                    <p>
                        Pick up where you left off. Browse a category, check your latest booking,
                        and keep your basket close without leaving the page.
                    </p>
                    <div class="hero-meta">
                        <span><i class="bi bi-geo-alt-fill me-1"></i><asp:Literal ID="litTownship" runat="server" /></span>
                        <span><i class="bi bi-calendar3 me-1"></i>Member since <asp:Literal ID="litJoined" runat="server" /></span>
                    </div>
                </div>

                <div class="teaser-card">
                    <div>
                        <span class="eyebrow">Quick check</span>
                        <h3>Need to compare options?</h3>
                        <p>
                            Open the promo page for current highlights, then jump back into the catalog
                            when you're ready to book.
                        </p>
                    </div>

                    <div class="teaser-actions">
                        <a href="Promo.aspx" class="btn-inline">View offers</a>
                        <a href="BookingStatus.aspx" class="btn-inline alt">Track bookings</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="stat-grid">
            <div class="stat-card">
                <span class="stat-value"><asp:Literal ID="litTotalBookings" runat="server">0</asp:Literal></span>
                <span class="stat-label">Total bookings</span>
            </div>
            <div class="stat-card">
                <span class="stat-value"><asp:Literal ID="litPendingBookings" runat="server">0</asp:Literal></span>
                <span class="stat-label">Pending</span>
            </div>
            <div class="stat-card">
                <span class="stat-value"><asp:Literal ID="litActiveBookings" runat="server">0</asp:Literal></span>
                <span class="stat-label">Active</span>
            </div>
            <div class="stat-card">
                <span class="stat-value">R <asp:Literal ID="litTotalSpent" runat="server">0</asp:Literal></span>
                <span class="stat-label">Total spent</span>
            </div>
        </section>

        <section class="section-card">
            <div class="section-head">
                <div>
                    <h3>Browse services</h3>
                    <p>Start with a category and move into provider profiles from there.</p>
                </div>
            </div>

            <div class="catalog-grid">
                <a href="ServiceProviders.aspx?category=Hairdressing" class="catalog-card">
                    <div class="catalog-image">
                        <img src="Images/Hairdressing.png" alt="Hairdressing" />
                    </div>
                    <div class="catalog-body">
                        <h4>Hairdressing</h4>
                        <p>Braiding, styling, colouring, locs and wig services.</p>
                        <div class="catalog-meta">
                            <span>Trusted community services</span>
                            <span class="catalog-link">Open category</span>
                        </div>
                    </div>
                </a>

                <a href="ServiceProviders.aspx?category=Tailoring" class="catalog-card">
                    <div class="catalog-image">
                        <img src="Images/Tailoring.png" alt="Tailoring" />
                    </div>
                    <div class="catalog-body">
                        <h4>Tailoring</h4>
                        <p>Alterations, custom garments, traditional and bridal wear.</p>
                        <div class="catalog-meta">
                            <span>Trusted community services</span>
                            <span class="catalog-link">Open category</span>
                        </div>
                    </div>
                </a>

                <a href="ServiceProviders.aspx?category=Plumbing" class="catalog-card">
                    <div class="catalog-image">
                        <img src="Images/Plumbing.png" alt="Plumbing" />
                    </div>
                    <div class="catalog-body">
                        <h4>Plumbing</h4>
                        <p>Pipe installation, leak repairs, geysers and renovations.</p>
                        <div class="catalog-meta">
                            <span>Trusted community services</span>
                            <span class="catalog-link">Open category</span>
                        </div>
                    </div>
                </a>

                <a href="ServiceProviders.aspx?category=Painting" class="catalog-card">
                    <div class="catalog-image">
                        <img src="Images/Painting.png" alt="Painting" />
                    </div>
                    <div class="catalog-body">
                        <h4>Painting</h4>
                        <p>Interior, exterior, commercial and decorative painting.</p>
                        <div class="catalog-meta">
                            <span>Trusted community services</span>
                            <span class="catalog-link">Open category</span>
                        </div>
                    </div>
                </a>
            </div>
        </section>

        <section class="action-grid">
            <a href="ServiceProviders.aspx" class="action-card">
                <span class="action-icon"><i class="bi bi-people-fill" aria-hidden="true"></i></span>
                <div>
                    <h3>Find providers</h3>
                    <p>Open the provider list and start from the default category.</p>
                </div>
            </a>

            <a href="Basket.aspx" class="action-card">
                <span class="action-icon"><i class="bi bi-basket2-fill" aria-hidden="true"></i></span>
                <div>
                    <h3>View basket</h3>
                    <p>Check what you have already added before you checkout.</p>
                </div>
            </a>

            <a href="BookingStatus.aspx" class="action-card">
                <span class="action-icon"><i class="bi bi-clipboard2-check-fill" aria-hidden="true"></i></span>
                <div>
                    <h3>Track bookings</h3>
                    <p>See the latest status updates and review completed jobs.</p>
                </div>
            </a>
        </section>

        <section class="section-card">
            <div class="section-head">
                <div>
                    <h3>Recent bookings</h3>
                    <p>Pick up right where you left off with your latest requests.</p>
                </div>
            </div>

            <asp:Repeater ID="rptRecentBookings" runat="server">
                <ItemTemplate>
                    <article class="booking-card">
                        <div class="booking-top">
                            <div>
                                <span class="booking-ref"><%# Eval("ReferenceNumber") %></span>
                                <h4><%# Eval("AppointmentDate", "{0:dddd, dd MMM yyyy}") %></h4>
                                <p class="booking-subline">
                                    Booked on <%# Eval("BookingDate", "{0:dd MMM yyyy}") %>
                                    &nbsp;&middot;&nbsp;
                                    <%# Eval("PaymentMethod") %>
                                </p>
                            </div>
                            <%# GetStatusBadge(Container.DataItem) %>
                        </div>

                        <div class="booking-tags">
                            <%# GetBookingTags(Container.DataItem) %>
                        </div>

                        <div class="booking-actions">
                            <a href='BookingStatus.aspx?ref=<%# Eval("ReferenceNumber") %>' class="btn-inline">Track</a>
                            <%# GetReviewAction(Container.DataItem) %>
                        </div>
                    </article>
                </ItemTemplate>

            </asp:Repeater>

            <asp:Panel ID="pnlNoBookings" runat="server" CssClass="empty-state" Visible="false">
                <h4>No bookings yet</h4>
                <p>
                    Start with a service category, then come back here to keep an eye on progress.
                </p>
                <div class="booking-actions" style="justify-content:center; margin-top: 1rem;">
                    <a href="ServiceProviders.aspx" class="btn-inline">Explore providers</a>
                    <a href="Promo.aspx" class="btn-inline alt">See offers</a>
                </div>
            </asp:Panel>
        </section>
    </div>

    <a href="Basket.aspx" class="basket-btn">
        Basket
        <asp:Label ID="lblBasketCount" runat="server" CssClass="basket-badge" Text="0" />
    </a>
</asp:Content>
