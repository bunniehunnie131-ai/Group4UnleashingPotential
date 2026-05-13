<%@ Page Title="Booking Confirmation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookingConfirmation.aspx.cs" Inherits="Unleashing_Potential.WebForm10" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root { --sky:#0ea5e9; --sky-dark:#0369a1; --sky-deeper:#0c4a6e; --sky-light:#bae6fd; --sky-pale:#f0f9ff; --muted:#64748b; }
    .page-wrap { max-width:700px; margin:0 auto; }
    .confirm-hero {
        background:linear-gradient(135deg,#166534,#15803d);
        border-radius:16px; padding:2.5rem; text-align:center; margin-bottom:1.5rem;
        box-shadow:0 4px 24px rgba(21,128,61,0.2);
    }
    .check-circle {
        width:80px; height:80px; background:rgba(255,255,255,0.2);
        border-radius:50%; display:flex; align-items:center;
        justify-content:center; font-size:2.5rem; margin:0 auto 1rem;
    }
    .confirm-hero h2 { font-family:'Lora',serif; color:#fff; font-size:1.7rem; margin:0 0 0.5rem; }
    .confirm-hero p  { color:rgba(255,255,255,0.85); font-size:0.9rem; margin:0; }
    .ref-number {
        background:rgba(255,255,255,0.15); border:2px solid rgba(255,255,255,0.3);
        border-radius:12px; padding:0.8rem 1.5rem; display:inline-block; margin-top:1.2rem;
        font-size:1.4rem; font-weight:700; color:#fff; letter-spacing:0.08em;
    }
    .detail-card {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.07);
        padding:1.5rem 1.8rem; margin-bottom:1.2rem;
    }
    .detail-title { font-family:'Lora',serif; font-size:1rem; font-weight:700; color:var(--sky-deeper); margin-bottom:1rem; border-bottom:2px solid var(--sky-light); padding-bottom:0.5rem; }
    .detail-row { display:flex; justify-content:space-between; padding:0.45rem 0; font-size:0.88rem; border-bottom:1px solid #f8fafc; }
    .detail-label { color:var(--muted); }
    .detail-value { font-weight:600; color:#1e293b; }
    .status-pending {
        display:inline-flex; align-items:center; gap:0.4rem;
        background:#fef3c7; border:1px solid #fcd34d; border-radius:20px;
        padding:0.35rem 1rem; font-size:0.82rem; font-weight:600; color:#92400e;
    }
    .action-row { display:flex; gap:1rem; flex-wrap:wrap; margin-top:1.5rem; }
    .btn-primary-custom {
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        border:none; color:#fff; border-radius:10px;
        padding:0.75rem 1.5rem; font-size:0.92rem; font-weight:600;
        text-decoration:none; display:inline-block; cursor:pointer;
    }
    .btn-primary-custom:hover { opacity:0.88; color:#fff; text-decoration:none; }
    .btn-outline {
        background:transparent; border:2px solid var(--sky-dark);
        color:var(--sky-dark); border-radius:10px;
        padding:0.75rem 1.5rem; font-size:0.92rem; font-weight:600;
        text-decoration:none; display:inline-block;
    }
    .btn-outline:hover { background:var(--sky-pale); text-decoration:none; }
    .item-row { display:flex; justify-content:space-between; padding:0.5rem 0; font-size:0.86rem; border-bottom:1px solid #f1f5f9; }
    .item-row:last-child { border-bottom:none; }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrap">

    <div class="confirm-hero">
        <div class="check-circle">✅</div>
        <h2>Booking Confirmed!</h2>
        <p>Your booking has been received and is awaiting provider acceptance.</p>
        <div class="ref-number">
            Ref: <asp:Label ID="lblRef" runat="server" />
        </div>
    </div>

    <div class="detail-card">
        <div class="detail-title">Booking Information</div>
        <div class="detail-row">
            <span class="detail-label">Customer Name</span>
            <span class="detail-value"><asp:Label ID="lblName" runat="server" /></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Phone</span>
            <span class="detail-value"><asp:Label ID="lblPhone" runat="server" /></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Service Address</span>
            <span class="detail-value"><asp:Label ID="lblAddress" runat="server" /></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Appointment Date</span>
            <span class="detail-value"><asp:Label ID="lblDate" runat="server" /></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Payment Method</span>
            <span class="detail-value"><asp:Label ID="lblPayment" runat="server" /></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Amount Paid</span>
            <span class="detail-value" style="color:#166534;">R<asp:Label ID="lblAmtPaid" runat="server" /></span>
        </div>
        <div class="detail-row">
            <span class="detail-label">Booking Status</span>
            <span><div class="status-pending">⏳ Pending</div></span>
        </div>
    </div>

    <div class="detail-card">
        <div class="detail-title">Services Booked</div>
        <asp:Repeater ID="rptItems" runat="server">
            <ItemTemplate>
                <div class="item-row">
                    <span><%# Eval("ProviderName") %> — <%# Eval("Service") %></span>
                    <span style="font-weight:600;">R<%# String.Format("{0:0.00}",Eval("LineTotal")) %></span>
                </div>
            </ItemTemplate>
        </asp:Repeater>
        <div style="display:flex;justify-content:space-between;padding:0.7rem 0 0;font-size:1rem;font-weight:700;color:var(--sky-deeper);">
            <span>Total</span>
            <span>R<asp:Label ID="lblTotal" runat="server" /></span>
        </div>
    </div>

    <div class="action-row">
        <a href="BookingStatus.aspx" class="btn-primary-custom">📋 Track Booking Status</a>
        <a href="ServiceCategories.aspx" class="btn-outline">Browse More Services</a>
    </div>

</div>
</asp:Content>