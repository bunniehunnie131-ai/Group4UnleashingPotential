<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Services.aspx.cs" Inherits="Unleashing_Potential.WebForm3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

        <style>
    :root {
        --sky:        #0ea5e9;
        --sky-dark:   #0369a1;
        --sky-deeper: #0c4a6e;
        --sky-light:  #bae6fd;
        --sky-pale:   #f0f9ff;
        --muted:      #64748b;
    }

    .services-wrap {
        max-width: 960px;
        margin: 0 auto;
    }

    .services-header {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        border-radius: 16px;
        padding: 2rem 2.5rem 1.8rem;
        margin-bottom: 2rem;
        box-shadow: 0 4px 24px rgba(12, 74, 110, 0.10);
    }

    .services-header h2 {
        font-family: 'Lora', serif;
        color: #f0f9ff;
        font-size: 1.7rem;
        margin: 0 0 0.3rem;
    }

    .services-header p {
        color: var(--sky-light);
        font-size: 0.9rem;
        margin: 0;
    }

    .service-card {
        background: #ffffff;
        border: none;
        border-radius: 16px;
        box-shadow: 0 4px 18px rgba(12, 74, 110, 0.08);
        transition: transform 0.25s ease, box-shadow 0.25s ease;
        overflow: hidden;
    }

    .service-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 10px 28px rgba(12, 74, 110, 0.16);
    }

    .service-card-top {
        background: linear-gradient(135deg, #e0f2fe, var(--sky-light));
        padding: 1.6rem 1rem 1.2rem;
        text-align: center;
    }

    .service-icon {
        font-size: 42px;
        margin-bottom: 0.5rem;
        display: block;
    }

    .service-card-body {
        padding: 1.2rem 1.3rem 1.5rem;
        text-align: center;
    }

    .service-card-body h5 {
        font-family: 'Lora', serif;
        color: var(--sky-deeper);
        font-size: 1.05rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
    }

    .service-card-body p {
        font-size: 0.88rem;
        color: var(--muted);
        margin-bottom: 1.1rem;
        line-height: 1.55;
    }

    .btn-service {
        background: linear-gradient(135deg, var(--sky), var(--sky-dark));
        border: none;
        color: white;
        font-weight: 600;
        padding: 0.55rem 1.4rem;
        border-radius: 8px;
        font-size: 0.88rem;
        transition: opacity 0.2s, transform 0.1s;
        cursor: pointer;
    }

    .btn-service:hover {
        opacity: 0.88;
        transform: translateY(-1px);
        color: white;
    }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

    <div class="services-wrap">

        <div class="services-header">
            <h2>Our Services</h2>
            <p>Connecting communities with trusted local skills.</p>
        </div>

        <div class="row g-4">

            <div class="col-sm-6 col-md-3">
                <div class="service-card">
                    <div class="service-card-top">
                        <span class="service-icon">💇</span>
                    </div>
                    <div class="service-card-body">
                        <h5>Hairdressing</h5>
                        <p>Professional braiding, styling and grooming services.</p>
                        <button class="btn btn-service">Request Service</button>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-md-3">
                <div class="service-card">
                    <div class="service-card-top">
                        <span class="service-icon">🧵</span>
                    </div>
                    <div class="service-card-body">
                        <h5>Tailoring</h5>
                        <p>Clothing design, alterations and fashion repairs.</p>
                        <button class="btn btn-service">Request Service</button>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-md-3">
                <div class="service-card">
                    <div class="service-card-top">
                        <span class="service-icon">🔧</span>
                    </div>
                    <div class="service-card-body">
                        <h5>Plumbing</h5>
                        <p>Pipe installation, leak repairs and plumbing maintenance.</p>
                        <button class="btn btn-service">Request Service</button>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-md-3">
                <div class="service-card">
                    <div class="service-card-top">
                        <span class="service-icon">🎨</span>
                    </div>
                    <div class="service-card-body">
                        <h5>Painting</h5>
                        <p>Interior and exterior painting for homes and businesses.</p>
                        <button class="btn btn-service">Request Service</button>
                    </div>
                </div>
            </div>

        </div>

    </div>



</asp:Content>
