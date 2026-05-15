<%@ Page Title="Privacy Policy" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PrivacyTerms.aspx.cs" Inherits="Unleashing_Potential.PrivacyTerms" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --sky: #0ea5e9;
            --sky-dark: #0369a1;
            --sky-deeper: #0c4a6e;
            --sky-light: #bae6fd;
            --sky-pale: #f0f9ff;
            --accent: #f59e0b;
            --text: #0f172a;
            --muted: #64748b;
        }

        .pt-wrap {
            max-width: 800px;
            margin: 0 auto;
        }

        .pt-hero {
            background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
            border-radius: 16px;
            padding: 2.5rem 2.5rem 2rem;
            margin-bottom: 1.5rem;
            color: #f0f9ff;
        }

        .pt-hero h1 {
            font-family: 'Lora', serif;
            font-size: 1.8rem;
            margin: 0 0 0.4rem;
        }

        .pt-hero p {
            color: var(--sky-light);
            font-size: 0.9rem;
            margin: 0;
        }

        .pt-tabs {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #e0f2fe;
            padding-bottom: 0;
        }

        .pt-tab-btn {
            background: none;
            border: none;
            padding: 0.7rem 1.4rem;
            font-weight: 700;
            font-size: 0.9rem;
            color: var(--muted);
            border-bottom: 3px solid transparent;
            margin-bottom: -2px;
            cursor: pointer;
            transition: color 0.2s, border-color 0.2s;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .pt-tab-btn:hover {
            color: var(--sky-dark);
        }

        .pt-tab-btn.active {
            color: var(--sky-dark);
            border-bottom: 3px solid var(--sky-dark);
        }

        .pt-card {
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(12, 74, 110, 0.10);
            overflow: hidden;
        }

        .pt-card-body {
            padding: 2rem 2.5rem;
        }

        .pt-panel {
            display: none;
        }

        .pt-panel.active {
            display: block;
        }

        .pt-section-title {
            font-family: 'Lora', serif;
            font-size: 1.15rem;
            color: var(--sky-deeper);
            margin: 1.8rem 0 0.5rem;
            padding-bottom: 0.4rem;
            border-bottom: 1.5px solid #e0f2fe;
        }

        .pt-section-title:first-child {
            margin-top: 0;
        }

        .pt-card-body p,
        .pt-card-body li {
            font-size: 0.92rem;
            color: var(--text);
            line-height: 1.75;
        }

        .pt-card-body ul {
            padding-left: 1.4rem;
            margin-bottom: 0.8rem;
        }

        .pt-card-body li {
            margin-bottom: 0.3rem;
        }

        .pt-highlight {
            background: var(--sky-pale);
            border-left: 4px solid var(--sky);
            border-radius: 0 8px 8px 0;
            padding: 0.85rem 1.1rem;
            margin: 1rem 0;
            font-size: 0.9rem;
            color: var(--sky-deeper);
        }

        .pt-highlight strong {
            color: var(--sky-dark);
        }

        .pt-updated {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: var(--sky-pale);
            border: 1.5px solid var(--sky-light);
            border-radius: 20px;
            padding: 0.3rem 0.9rem;
            font-size: 0.8rem;
            color: var(--sky-dark);
            font-weight: 600;
            margin-bottom: 1.4rem;
        }

        .pt-accept-bar {
            background: linear-gradient(135deg, #f0f9ff, #e0f2fe);
            border: 1.5px solid var(--sky-light);
            border-radius: 12px;
            padding: 1.2rem 1.5rem;
            margin-top: 2rem;
            display: flex;
            align-items: center;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .pt-accept-bar p {
            flex: 1;
            margin: 0;
            font-size: 0.88rem;
            color: var(--sky-deeper);
        }

        .btn-accept {
            background: linear-gradient(135deg, var(--sky), var(--sky-dark));
            border: none;
            color: white;
            font-weight: 700;
            padding: 0.6rem 1.6rem;
            border-radius: 8px;
            font-size: 0.9rem;
            transition: opacity 0.2s, transform 0.1s;
            white-space: nowrap;
            text-decoration: none;
        }

        .btn-accept:hover {
            opacity: 0.9;
            transform: translateY(-1px);
            color: white;
        }

        .contact-chip {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: var(--sky-pale);
            border: 1.5px solid var(--sky-light);
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-size: 0.88rem;
            color: var(--sky-dark);
            font-weight: 600;
            text-decoration: none;
        }

        .contact-chip:hover {
            background: #e0f2fe;
            color: var(--sky-deeper);
        }

        @media (max-width: 576px) {
            .pt-hero {
                padding: 1.5rem;
            }

            .pt-hero h1 {
                font-size: 1.35rem;
            }

            .pt-card-body {
                padding: 1.5rem;
            }

            .pt-tabs {
                overflow-x: auto;
                flex-wrap: nowrap;
            }

            .pt-tab-btn {
                padding: 0.6rem 1rem;
                font-size: 0.82rem;
                white-space: nowrap;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="pt-wrap">
        <div class="pt-hero">
            <h1>Privacy Policy &amp; Terms of Use</h1>
            <p>How we collect, use, and protect your information and the rules that govern your use of our platform.</p>
        </div>

        <div class="pt-tabs">
            <button type="button" class="pt-tab-btn active">Privacy Policy</button>
            <button type="button" class="pt-tab-btn">Terms &amp; Conditions</button>
            <button type="button" class="pt-tab-btn">Cookie Policy</button>
        </div>

        <div class="pt-card">
            <div class="pt-card-body">
                <div id="panelPrivacy" class="pt-panel active">
                    <span class="pt-updated">
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        Last updated: January 2025
                    </span>

                    <h2 class="pt-section-title">1. Who We Are</h2>
                    <p>Unleashing Potential is a township-based services marketplace that connects customers with local service providers across East London and surrounding areas. This Privacy Policy explains how we handle personal information collected through our platform.</p>

                    <h2 class="pt-section-title">2. Information We Collect</h2>
                    <p>When you register or use our platform, we may collect:</p>
                    <ul>
                        <li><strong>Identity data</strong> - your full name and date of birth</li>
                        <li><strong>Contact data</strong> - email address and phone number</li>
                        <li><strong>Location data</strong> - your township or area</li>
                        <li><strong>Account data</strong> - hashed password and security question/answer</li>
                        <li><strong>Usage data</strong> - pages visited, bookings made, and audit logs</li>
                        <li><strong>Service provider data</strong> - business name, category, specialty, and experience</li>
                    </ul>

                    <h2 class="pt-section-title">3. How We Use Your Information</h2>
                    <p>Your data is used to:</p>
                    <ul>
                        <li>Create and manage your account securely</li>
                        <li>Process and track service bookings</li>
                        <li>Match customers with appropriate service providers</li>
                        <li>Send booking confirmations and notifications</li>
                        <li>Improve platform performance and user experience</li>
                        <li>Maintain audit logs for security and compliance purposes</li>
                    </ul>

                    <div class="pt-highlight">
                        <strong>We do not sell your personal data.</strong> Your information is never shared with third parties for marketing purposes without your explicit consent.
                    </div>

                    <h2 class="pt-section-title">4. Data Security</h2>
                    <p>We take security seriously. Passwords are stored as SHA-256 hashes and are never stored in plain text. Access to personal data is restricted to authorised platform administrators only.</p>

                    <h2 class="pt-section-title">5. Data Retention</h2>
                    <p>Your data is retained for as long as your account is active. You may request account deletion at any time by contacting our support team. Audit logs may be retained for up to 12 months for security purposes.</p>

                    <h2 class="pt-section-title">6. Your Rights</h2>
                    <p>Under applicable South African law (POPIA), you have the right to:</p>
                    <ul>
                        <li>Access the personal information we hold about you</li>
                        <li>Request correction of inaccurate information</li>
                        <li>Request deletion of your account and data</li>
                        <li>Lodge a complaint with the Information Regulator</li>
                    </ul>

                    <h2 class="pt-section-title">7. Contact Us</h2>
                    <p>For privacy-related queries, please reach out:</p>
                    <a href="mailto:support@unleashinpotential.co.za" class="contact-chip">
                        <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                        </svg>
                        support@unleashinpotential.co.za
                    </a>
                </div>

                <div id="panelTerms" class="pt-panel">
                    <span class="pt-updated">
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        Last updated: January 2025
                    </span>

                    <h2 class="pt-section-title">1. Acceptance of Terms</h2>
                    <p>By creating an account on the Unleashing Potential platform, you confirm that you have read, understood, and agree to be bound by these Terms and Conditions. If you do not agree, please do not register.</p>

                    <h2 class="pt-section-title">2. Eligibility</h2>
                    <p>You must be at least <strong>18 years of age</strong> to register on this platform. By registering, you confirm that the information you provide is accurate, current, and complete.</p>

                    <h2 class="pt-section-title">3. Account Responsibilities</h2>
                    <ul>
                        <li>You are responsible for maintaining the confidentiality of your login credentials.</li>
                        <li>You agree not to share your account with any third party.</li>
                        <li>Notify us immediately of any unauthorised access to your account.</li>
                        <li>You are responsible for all activity that occurs under your account.</li>
                    </ul>

                    <h2 class="pt-section-title">4. Customer Obligations</h2>
                    <ul>
                        <li>Provide accurate booking and contact information.</li>
                        <li>Treat service providers with respect and professionalism.</li>
                        <li>Pay for services as agreed at the time of booking.</li>
                        <li>Leave honest and fair reviews based on your experience.</li>
                    </ul>

                    <h2 class="pt-section-title">5. Service Provider Obligations</h2>
                    <ul>
                        <li>Provide services as described on your profile.</li>
                        <li>Maintain accurate pricing and availability information.</li>
                        <li>Arrive on time for scheduled appointments.</li>
                        <li>Hold any required licences or certifications for your trade.</li>
                        <li>Treat customers with professionalism and respect.</li>
                    </ul>

                    <h2 class="pt-section-title">6. Prohibited Conduct</h2>
                    <p>You must not:</p>
                    <ul>
                        <li>Use the platform for any unlawful purpose</li>
                        <li>Post false, misleading, or fraudulent listings</li>
                        <li>Circumvent the platform to arrange off-platform payments</li>
                        <li>Harass, abuse, or threaten other users</li>
                        <li>Attempt to gain unauthorised access to platform systems</li>
                    </ul>

                    <h2 class="pt-section-title">7. Intellectual Property</h2>
                    <p>All content on this platform, including text, graphics, logos, and software, is the property of Unleashing Potential and is protected by applicable intellectual property laws. You may not reproduce or distribute any content without prior written consent.</p>

                    <h2 class="pt-section-title">8. Limitation of Liability</h2>
                    <p>Unleashing Potential acts as a marketplace and is not liable for the quality, safety, or legality of services offered by providers listed on the platform. We are not responsible for disputes between customers and service providers.</p>

                    <h2 class="pt-section-title">9. Termination</h2>
                    <p>We reserve the right to suspend or terminate your account at any time if you violate these Terms and Conditions or engage in conduct deemed harmful to the platform or its users.</p>

                    <h2 class="pt-section-title">10. Changes to Terms</h2>
                    <p>We may update these Terms and Conditions from time to time. Continued use of the platform following any changes constitutes your acceptance of the updated terms. We will notify registered users of significant changes via email.</p>

                    <h2 class="pt-section-title">11. Governing Law</h2>
                    <p>These Terms and Conditions are governed by the laws of the Republic of South Africa. Any disputes shall be subject to the exclusive jurisdiction of the South African courts.</p>
                </div>

                <div id="panelCookies" class="pt-panel">
                    <span class="pt-updated">
                        <svg xmlns="http://www.w3.org/2000/svg" width="13" height="13" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                        Last updated: January 2025
                    </span>

                    <h2 class="pt-section-title">What Are Cookies?</h2>
                    <p>Cookies are small text files placed on your device by a website when you visit it. They are widely used to make websites work more efficiently and provide information to site owners.</p>

                    <h2 class="pt-section-title">How We Use Cookies</h2>
                    <p>Unleashing Potential uses session-based cookies to maintain your login state while you navigate the platform. We do not use advertising or tracking cookies.</p>

                    <div class="pt-highlight">
                        <strong>Session cookies only.</strong> Our cookies expire when you close your browser and are never used to track you across other websites.
                    </div>

                    <h2 class="pt-section-title">Types of Cookies We Use</h2>
                    <ul>
                        <li><strong>Essential session cookies</strong> - required to keep you logged in as you navigate the platform. Without these, features such as booking and account management would not function.</li>
                        <li><strong>Security cookies</strong> - help us identify and prevent fraudulent activity on your account.</li>
                    </ul>

                    <h2 class="pt-section-title">Managing Cookies</h2>
                    <p>You can control cookies through your browser settings. Disabling essential session cookies will prevent you from logging in. Most browsers allow you to:</p>
                    <ul>
                        <li>View the cookies currently stored on your device</li>
                        <li>Delete individual or all cookies</li>
                        <li>Block cookies from specific websites</li>
                        <li>Block all cookies (note: this will break login functionality)</li>
                    </ul>

                    <h2 class="pt-section-title">Third-Party Cookies</h2>
                    <p>We do not embed third-party advertising or analytics scripts that would place cookies on your device from external parties.</p>
                </div>

                <div class="pt-accept-bar">
                    <p>By using Unleashing Potential, you confirm you have read and agree to our Privacy Policy and Terms of Use.</p>
                    <a href="Register.aspx" class="btn-accept">Back to Register</a>
                </div>
            </div>
        </div>
    </div>

    <script>
        function switchTab(panel, btn) {
            document.querySelectorAll('.pt-panel').forEach(function (p) {
                p.classList.remove('active');
            });

            document.querySelectorAll('.pt-tab-btn').forEach(function (b) {
                b.classList.remove('active');
            });

            var map = { privacy: 'panelPrivacy', terms: 'panelTerms', cookies: 'panelCookies' };
            document.getElementById(map[panel]).classList.add('active');
            btn.classList.add('active');
        }

        window.addEventListener('DOMContentLoaded', function () {
            var tabs = document.querySelectorAll('.pt-tab-btn');
            var panels = ['privacy', 'terms', 'cookies'];

            tabs.forEach(function (btn, index) {
                btn.addEventListener('click', function () {
                    switchTab(panels[index], btn);
                });
            });

            var hash = window.location.hash;
            if (hash === '#terms') {
                switchTab('terms', tabs[1]);
            } else if (hash === '#cookies') {
                switchTab('cookies', tabs[2]);
            }
        });
    </script>
</asp:Content>
