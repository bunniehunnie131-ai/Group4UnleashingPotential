<%@ Page Title="My Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookingStatus.aspx.cs" Inherits="Unleashing_Potential.WebForm11" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root { --sky:#0ea5e9; --sky-dark:#0369a1; --sky-deeper:#0c4a6e; --sky-light:#bae6fd; --sky-pale:#f0f9ff; --muted:#64748b; }
    .page-wrap { max-width:860px; margin:0 auto; }
    .page-header {
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        border-radius:16px; padding:1.6rem 2rem; margin-bottom:1.5rem;
        display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;
    }
    .page-header h2 { font-family:'Lora',serif; color:#f0f9ff; font-size:1.6rem; margin:0; }
    .booking-card {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.07);
        margin-bottom:1.5rem; overflow:hidden;
    }
    .booking-card-head {
        background:var(--sky-pale); padding:1rem 1.5rem;
        display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:0.5rem;
        border-bottom:1px solid var(--sky-light);
    }
    .booking-ref { font-family:'IBM Plex Mono',monospace; font-size:0.9rem; font-weight:700; color:var(--sky-deeper); }
    .booking-date { font-size:0.8rem; color:var(--muted); }
    .booking-card-body { padding:1.3rem 1.5rem; }

    /* Status badges */
    .status-badge {
        display:inline-flex; align-items:center; gap:0.4rem;
        border-radius:20px; padding:0.3rem 0.9rem;
        font-size:0.8rem; font-weight:600;
    }
    .status-Pending       { background:#fef3c7; border:1px solid #fcd34d; color:#92400e; }
    .status-Confirmed     { background:#dbeafe; border:1px solid #93c5fd; color:#1e40af; }
    .status-Completed     { background:#dcfce7; border:1px solid #86efac; color:#166534; }
    .status-Cancelled     { background:#fee2e2; border:1px solid #fca5a5; color:#991b1b; }
    .status-Accepted      { background:#dbeafe; border:1px solid #93c5fd; color:#1e40af; }
    .status-InProgress    { background:#f3e8ff; border:1px solid #c4b5fd; color:#5b21b6; }
    .status-AppointmentDay{ background:#fce7f3; border:1px solid #f9a8d4; color:#9d174d; }

    /* Timeline */
    .timeline { display:flex; align-items:center; gap:0; margin:1rem 0; overflow-x:auto; padding-bottom:0.5rem; }
    .tl-step {
        display:flex; flex-direction:column; align-items:center;
        min-width:100px; text-align:center; flex:1;
    }
    .tl-circle {
        width:36px; height:36px; border-radius:50%;
        display:flex; align-items:center; justify-content:center;
        font-size:1rem; border:2px solid #e2e8f0; background:#f8fafc;
        position:relative; z-index:1;
    }
    .tl-circle.done  { background:var(--sky-dark); border-color:var(--sky-dark); color:#fff; }
    .tl-circle.active{ background:var(--sky); border-color:var(--sky); color:#fff; }
    .tl-label { font-size:0.72rem; color:var(--muted); margin-top:0.4rem; font-weight:500; }
    .tl-label.done  { color:var(--sky-dark); font-weight:600; }
    .tl-label.active{ color:var(--sky-dark); font-weight:700; }
    .tl-line { flex:1; height:2px; background:#e2e8f0; margin-top:-18px; }
    .tl-line.done { background:var(--sky-dark); }

    .service-tag {
        display:inline-block; background:var(--sky-pale); border:1px solid var(--sky-light);
        border-radius:6px; padding:0.2rem 0.6rem; font-size:0.78rem; color:var(--sky-dark);
        font-weight:500; margin:0.2rem;
    }
    .booking-meta { font-size:0.84rem; color:#475569; margin-bottom:0.3rem; }
    .btn-review {
        background:linear-gradient(135deg,#166534,#15803d);
        border:none; color:#fff; border-radius:8px;
        padding:0.5rem 1.2rem; font-size:0.85rem; font-weight:600;
        cursor:pointer; transition:opacity 0.2s; text-decoration:none;
        display:inline-block;
    }
    .btn-review:hover { opacity:0.88; color:#fff; text-decoration:none; }
    .empty-state {
        background:#fff; border-radius:16px;
        box-shadow:0 4px 18px rgba(12,74,110,0.07);
        padding:3rem; text-align:center;
    }
    .btn-browse {
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        border:none; color:#fff; border-radius:10px;
        padding:0.7rem 1.8rem; font-size:0.92rem; font-weight:600;
        text-decoration:none; display:inline-block; margin-top:1rem;
    }
    .btn-browse:hover { opacity:0.88; color:#fff; text-decoration:none; }
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrap">

    <div class="page-header">
        <h2>📋 My Bookings</h2>
        <a href="ServiceCategories.aspx" style="color:var(--sky-light);font-size:0.85rem;text-decoration:none;">+ Book New Service</a>
    </div>

    <asp:Panel ID="pnlEmpty" runat="server" Visible="false">
        <div class="empty-state">
            <div style="font-size:3rem;margin-bottom:0.5rem;">📋</div>
            <h4 style="font-family:'Lora',serif;color:var(--sky-deeper);">No Bookings Yet</h4>
            <p style="color:var(--muted);">You haven't made any bookings. Start by browsing our services.</p>
            <a href="ServiceCategories.aspx" class="btn-browse">Browse Services</a>
        </div>
    </asp:Panel>

    <asp:Repeater ID="rptBookings" runat="server">
        <ItemTemplate>
            <div class="booking-card">
                <div class="booking-card-head">
                    <div>
                        <div class="booking-ref">Ref: <%# Eval("ReferenceNumber") %></div>
                        <div class="booking-date">Booked on <%# Convert.ToDateTime(Eval("BookingDate")).ToString("dd MMM yyyy, HH:mm") %></div>
                    </div>
                    <div><%# GetStatusBadge(Eval("Status").ToString()) %></div>
                </div>
                <div class="booking-card-body">

                    <!-- Status Timeline -->
                    <%# GetTimeline(Eval("Status").ToString()) %>

                    <div style="margin:1rem 0 0.6rem;">
                        <div class="booking-meta">📅 Appointment: <strong><%# Convert.ToDateTime(Eval("AppointmentDate")).ToString("dd MMMM yyyy") %></strong></div>
                        <div class="booking-meta">📍 <%# Eval("CustomerAddress") %></div>
                        <div class="booking-meta">💳 <%# Eval("PaymentMethod") %> — Paid: <strong style="color:#166534;">R<%# String.Format("{0:0.00}", Eval("AmountPaid")) %></strong> of R<%# String.Format("{0:0.00}", Eval("TotalAmount")) %></div>
                    </div>

                    <div style="margin-bottom:1rem;">
                        <%# GetServiceTags(Container.DataItem) %>
                    </div>

                    <%# GetReviewButton(Container.DataItem) %>
                </div>
            </div>
        </ItemTemplate>
    </asp:Repeater>

</div>
</asp:Content>
