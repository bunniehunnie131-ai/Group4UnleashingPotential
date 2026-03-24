<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Unleashing_Potential.Default" %>

<asp:Content ID="HeadContent" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        
        .hero {
            background: linear-gradient(135deg, #0c4a6e, #0369a1);
            padding: 80px 20px;
            text-align: center;
            color: white;
        }

        .hero h1 {
            font-family: 'Lora', serif;
            font-size: 2.8rem;
        }

        .hero p {
            max-width: 600px;
            margin: 20px auto;
            color: #bae6fd;
        }

        .hero a {
            margin-top: 20px;
        }

        
        .how-section {
            padding: 60px 20px;
            text-align: center;
        }

        .steps {
            display: flex;
            justify-content: center;
            gap: 30px;
            flex-wrap: wrap;
        }

        .step {
            background: white;
            padding: 20px;
            border-radius: 10px;
            width: 250px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        }

       
        .services {
            padding: 60px 20px;
            background: #e0f2fe;
            text-align: center;
        }

        .service-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .service-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-decoration: none;
            color: #0c4a6e;
            font-weight: 600;
            display: block;
            transition: transform 0.2s;
        }

        .service-card:hover {
            transform: translateY(-5px);
        }

     
        .cta {
            background: #0c4a6e;
            color: white;
            text-align: center;
            padding: 60px 20px;
        }
    </style>
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">

    
    <section class="hero">
        <h1>Your Kasi, Your People, Your Services</h1>
        <p>
            Connect with skilled local service providers in your community. 
            From plumbers to hairdressers, find trusted professionals near you.
        </p>
        <a href="Register.aspx" class="btn btn-warning">Join for Free</a>
        <br /><br />
        <a href="Services.aspx" class="btn btn-outline-light">Browse Services</a>
    </section>

  
    <section class="how-section">
        <h2>How It Works</h2>
        <div class="steps">
            <div class="step">
                <h4>1. Register</h4>
                <p>Create your free account in minutes.</p>
            </div>
            <div class="step">
                <h4>2. Find Services</h4>
                <p>Browse trusted local providers.</p>
            </div>
            <div class="step">
                <h4>3. Connect</h4>
                <p>Contact and hire the right person.</p>
            </div>
        </div>
    </section>

    
    <section class="services">
        <h2>Our Services</h2>
        <div class="service-grid">
            <a href="Services.aspx?cat=plumbing" class="service-card">Plumbing</a>
            <a href="Services.aspx?cat=painting" class="service-card">Painting</a>
            <a href="Services.aspx?cat=haircare" class="service-card">Hairdressing</a>
            <a href="Services.aspx?cat=tailoring" class="service-card">Tailoring</a>
        </div>
    </section>

   
    <section class="cta">
        <h2>Are You a Service Provider?</h2>
        <p>Register today and grow your business in your community.</p>
        <a href="Register.aspx" class="btn btn-warning">Get Started</a>
    </section>

</asp:Content>