<%@ Page Title="Services" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Unleashing_Potential.WebForm4" %>
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

    .admin-wrap {
        max-width: 960px;
        margin: 0 auto;
    }

    .admin-header {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        border-radius: 16px;
        padding: 2rem 2.5rem 1.8rem;
        margin-bottom: 2rem;
        box-shadow: 0 4px 24px rgba(12, 74, 110, 0.10);
    }

    .admin-header h2 {
        font-family: 'Lora', serif;
        color: #f0f9ff;
        font-size: 1.7rem;
        margin: 0 0 0.3rem;
    }

    .admin-header p {
        color: var(--sky-light);
        font-size: 0.9rem;
        margin: 0;
    }

    .admin-card {
        background: #ffffff;
        border: none;
        border-radius: 16px;
        box-shadow: 0 4px 18px rgba(12, 74, 110, 0.08);
        transition: transform 0.25s ease, box-shadow 0.25s ease;
        overflow: hidden;
    }

    .admin-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 10px 28px rgba(12, 74, 110, 0.16);
    }

    .admin-card-top {
        background: linear-gradient(135deg, #e0f2fe, var(--sky-light));
        padding: 1.6rem 1rem 1.2rem;
        text-align: center;
    }

    .admin-icon {
        font-size: 42px;
        margin-bottom: 0.5rem;
        display: block;
    }

    .admin-card-body {
        padding: 1.2rem 1.3rem 1.5rem;
        text-align: center;
    }

    .admin-card-body h5 {
        font-family: 'Lora', serif;
        color: var(--sky-deeper);
        font-size: 1.05rem;
        font-weight: 700;
        margin-bottom: 0.5rem;
    }

    .admin-card-body p {
        font-size: 0.88rem;
        color: var(--muted);
        margin-bottom: 1.1rem;
        line-height: 1.55;
    }

    .btn-admin {
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

    .btn-admin:hover {
        opacity: 0.88;
        transform: translateY(-1px);
        color: white;
    }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    

        <div class="admin-header">
            <h2>Admin Dashboard</h2>
            <p>Manage services, users, and requests.</p>
        </div>

        <div class="row g-4">

            <div class="col-sm-6 col-md-3">
                <div class="admin-card">
                    <div class="admin-card-top">
                        <i class="bi bi-plus-circle-fill admin-icon"></i>
        </div>
                    </div>
                    <div class="admin-card-body">
                        <h5>Add Service</h5>
                        <p>Create a new service offered on the platform.</p>
                        <asp:Button ID="btnAddService" runat="server" Text="Add Service" CssClass="btn btn-admin" />
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-md-3">
                <div class="admin-card">
                    <div class="admin-card-top">
                       <i class="bi bi-card-list admin-icon"></i>
                    </div>
                    <div class="admin-card-body">
                        <h5>View Services</h5>
                        <p>See all services available on the platform.</p>
                        <asp:Button ID="btnViewServices" runat="server" Text="View Services" CssClass="btn btn-admin" />
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-md-3">
                <div class="admin-card">
                    <div class="admin-card-top">
                       <i class="bi bi-people-fill admin-icon"></i>
                    </div>
                    <div class="admin-card-body">
                        <h5>Manage Users</h5>
                        <p>View and manage registered users.</p>
                        <asp:Button ID="btnManageUsers" runat="server" Text="Manage Users" CssClass="btn btn-admin" />
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-md-3">
                <div class="admin-card">
                    <div class="admin-card-top">
                      <i class="bi bi-box-seam admin-icon"></i>
                    </div>
                    <div class="admin-card-body">
                        <h5>Service Requests</h5>
                        <p>Check customer service requests.</p>
                        <asp:Button ID="btnRequests" runat="server" Text="View Requests" CssClass="btn btn-admin" />
                    </div>
                </div>
            </div>

</asp:Content>