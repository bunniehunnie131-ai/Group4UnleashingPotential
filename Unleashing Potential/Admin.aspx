<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="Unleashing_Potential.WebForm4" %>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
       <link rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<style>
:root {
    --sky: #0ea5e9; --sky-dark: #0369a1;
    --sky-deeper: #0c4a6e; --sky-light: #bae6fd;
    --sky-pale: #f0f9ff; --muted: #64748b;
    --sidebar-w: 230px;
    --green: #22c55e; --amber: #f59e0b; --red: #ef4444;
}

.admin-shell {
    display: flex;
    gap: 0;
    min-height: calc(100vh - 200px);
    background: #f1f5f9;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 4px 32px rgba(12,74,110,0.10);
}


.admin-sidebar {
    width: var(--sidebar-w);
    background: #fff;
    border-right: 1px solid #e2e8f0;
    display: flex;
    flex-direction: column;
    flex-shrink: 0;
}

.sidebar-profile {
    padding: 1.4rem 1.2rem 1rem;
    border-bottom: 1px solid #e2e8f0;
}

.sidebar-avatar {
    width: 42px; height: 42px;
    background: linear-gradient(135deg, var(--sky), var(--sky-dark));
    border-radius: 50%;
    display: flex; align-items: center; justify-content: center;
    color: #fff; font-weight: 700; font-size: 1rem;
    margin-bottom: 0.5rem;
}

.sidebar-name {
    font-weight: 700; font-size: 0.9rem; color: var(--sky-deeper);
    margin: 0;
}

.sidebar-role {
    font-size: 0.72rem; color: var(--muted);
    text-transform: uppercase; letter-spacing: 0.8px;
}

.sidebar-section {
    font-size: 0.68rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: 1px;
    color: var(--muted); padding: 1rem 1.2rem 0.4rem;
}

.sidebar-nav { list-style: none; padding: 0; margin: 0; }

.sidebar-nav li button {
    width: 100%;
    background: none; border: none;
    display: flex; align-items: center; gap: 0.7rem;
    padding: 0.6rem 1.2rem;
    font-family: 'Nunito', sans-serif;
    font-size: 0.88rem; font-weight: 500;
    color: var(--muted); cursor: pointer;
    border-left: 3px solid transparent;
    transition: all 0.15s; text-align: left;
}

.sidebar-nav li button:hover {
    background: var(--sky-pale);
    color: var(--sky-dark);
}

.sidebar-nav li button.active {
    background: var(--sky-pale);
    color: var(--sky-dark);
    border-left-color: var(--sky);
    font-weight: 700;
}

.sidebar-nav li button i { font-size: 1rem; width: 18px; }

.sidebar-badge {
    margin-left: auto;
    background: var(--red);
    color: #fff; border-radius: 10px;
    font-size: 0.7rem; font-weight: 700;
    padding: 1px 7px; min-width: 20px;
    text-align: center;
}

.sidebar-badge.amber { background: var(--amber); }
.sidebar-badge.green { background: var(--green); }

.admin-main {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.admin-topbar {
    background: #fff;
    border-bottom: 1px solid #e2e8f0;
    padding: 0.9rem 1.8rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1rem;
}

.admin-topbar h5 {
    font-family: 'Lora', serif;
    color: var(--sky-deeper);
    font-size: 1.1rem;
    margin: 0;
}

.admin-search {
    display: flex; align-items: center;
    background: var(--sky-pale);
    border: 1.5px solid var(--sky-light);
    border-radius: 8px; padding: 0.35rem 0.8rem;
    gap: 0.4rem; flex: 0 0 220px;
}

.admin-search input {
    border: none; background: none;
    font-size: 0.85rem; color: var(--sky-deeper);
    outline: none; width: 100%;
}

.admin-content { padding: 1.8rem; overflow-y: auto; flex: 1; }


.admin-panel { display: none; }
.admin-panel.active { display: block; }


.kpi-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 1rem; margin-bottom: 1.8rem;
}

.kpi-card {
    background: #fff; border-radius: 12px;
    padding: 1.2rem 1.4rem;
    box-shadow: 0 2px 10px rgba(12,74,110,0.07);
    display: flex; flex-direction: column; gap: 0.4rem;
}

.kpi-label {
    font-size: 0.75rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: 0.8px;
    color: var(--muted);
}

.kpi-value {
    font-size: 1.9rem; font-weight: 700;
    color: var(--sky-deeper); line-height: 1;
}

.kpi-sub { font-size: 0.78rem; color: var(--muted); }

.kpi-icon {
    width: 38px; height: 38px; border-radius: 10px;
    display: flex; align-items: center; justify-content: center;
    font-size: 1.1rem; margin-bottom: 0.3rem;
}

.kpi-icon.blue   { background: #dbeafe; color: var(--sky-dark); }
.kpi-icon.green  { background: #dcfce7; color: #15803d; }
.kpi-icon.amber  { background: #fef9c3; color: #92400e; }
.kpi-icon.red    { background: #fee2e2; color: #991b1b; }


.section-head {
    display: flex; align-items: center;
    justify-content: space-between;
    margin-bottom: 1rem;
}

.section-head h6 {
    font-family: 'Lora', serif;
    font-size: 1rem; color: var(--sky-deeper); margin: 0;
}


.kanban-board {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.2rem;
}

.kanban-col {
    background: #f8fafc;
    border-radius: 12px;
    padding: 1rem;
    border: 1px solid #e2e8f0;
}

.kanban-col-head {
    display: flex; align-items: center;
    justify-content: space-between;
    margin-bottom: 0.9rem;
}

.kanban-col-title {
    font-size: 0.82rem; font-weight: 700;
    text-transform: uppercase; letter-spacing: 0.8px;
    color: var(--muted);
}

.kanban-count {
    background: var(--sky-pale);
    color: var(--sky-dark);
    border-radius: 50%; width: 22px; height: 22px;
    display: flex; align-items: center; justify-content: center;
    font-size: 0.72rem; font-weight: 700;
}

.kanban-count.amber { background: #fef9c3; color: #92400e; }
.kanban-count.green { background: #dcfce7; color: #15803d; }

.kanban-card {
    background: #fff; border-radius: 10px;
    padding: 0.9rem 1rem; margin-bottom: 0.7rem;
    box-shadow: 0 1px 6px rgba(12,74,110,0.07);
    border: 1px solid #e2e8f0;
}

.kanban-card h6 {
    font-size: 0.88rem; font-weight: 700;
    color: var(--sky-deeper); margin: 0 0 0.2rem;
}

.kanban-card p {
    font-size: 0.78rem; color: var(--muted);
    margin: 0 0 0.6rem;
}

.kanban-actions { display: flex; gap: 0.5rem; }

.btn-approve {
    background: #dcfce7; color: #15803d;
    border: none; border-radius: 6px;
    font-size: 0.75rem; font-weight: 700;
    padding: 0.3rem 0.8rem; cursor: pointer;
    transition: background 0.15s;
}

.btn-approve:hover { background: #bbf7d0; }

.btn-reject {
    background: #fee2e2; color: #991b1b;
    border: none; border-radius: 6px;
    font-size: 0.75rem; font-weight: 700;
    padding: 0.3rem 0.8rem; cursor: pointer;
    transition: background 0.15s;
}

.btn-reject:hover { background: #fecaca; }

.status-pill {
    display: inline-block;
    font-size: 0.7rem; font-weight: 700;
    padding: 0.2rem 0.65rem; border-radius: 20px;
    text-transform: uppercase; letter-spacing: 0.4px;
}

.pill-pending  { background: #fef9c3; color: #92400e; }
.pill-active   { background: #dbeafe; color: #1d4ed8; }
.pill-verified { background: #dcfce7; color: #15803d; }
.pill-rejected { background: #fee2e2; color: #991b1b; }
.pill-process  { background: #ede9fe; color: #5b21b6; }
.pill-complete { background: #dcfce7; color: #15803d; }

.admin-table {
    width: 100%; border-collapse: collapse;
    background: #fff; border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(12,74,110,0.07);
    font-size: 0.85rem;
}

.admin-table thead tr {
    background: var(--sky-deeper);
}

.admin-table th {
    padding: 0.75rem 1rem;
    color: #f0f9ff; font-size: 0.75rem;
    text-transform: uppercase; letter-spacing: 0.8px;
    font-weight: 600; text-align: left; border: none;
}

.admin-table td {
    padding: 0.7rem 1rem;
    border-bottom: 1px solid #f1f5f9;
    color: #334155; vertical-align: middle;
}

.admin-table tr:last-child td { border-bottom: none; }
.admin-table tr:hover td { background: var(--sky-pale); }


.btn-sm-sky {
    background: linear-gradient(135deg, var(--sky), var(--sky-dark));
    color: #fff; border: none; border-radius: 6px;
    font-size: 0.78rem; font-weight: 600;
    padding: 0.3rem 0.8rem; cursor: pointer;
    transition: opacity 0.15s;
    font-family: 'Nunito', sans-serif;
}

.btn-sm-sky:hover { opacity: 0.88; color: #fff; }

.btn-sm-outline {
    background: none;
    color: var(--sky-dark);
    border: 1.5px solid var(--sky-light);
    border-radius: 6px;
    font-size: 0.78rem; font-weight: 600;
    padding: 0.3rem 0.8rem; cursor: pointer;
    transition: background 0.15s;
    font-family: 'Nunito', sans-serif;
}

.btn-sm-outline:hover { background: var(--sky-pale); }

.btn-sm-red {
    background: #fee2e2; color: #991b1b;
    border: none; border-radius: 6px;
    font-size: 0.78rem; font-weight: 600;
    padding: 0.3rem 0.8rem; cursor: pointer;
    font-family: 'Nunito', sans-serif;
}


.report-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 1.2rem;
}

.report-card {
    background: #fff; border-radius: 12px;
    padding: 1.4rem;
    box-shadow: 0 2px 10px rgba(12,74,110,0.07);
    border: 1px solid #e2e8f0;
    text-align: center;
}

.report-card i {
    font-size: 2rem; margin-bottom: 0.6rem;
    color: var(--sky-dark); display: block;
}

.report-card h6 {
    font-family: 'Lora', serif;
    color: var(--sky-deeper); font-size: 0.95rem;
    margin-bottom: 0.4rem;
}

.report-card p {
    font-size: 0.8rem; color: var(--muted); margin-bottom: 1rem;
}


.audit-row td:first-child { color: var(--muted); font-size: 0.78rem; }


.admin-msg {
    padding: 0.7rem 1rem; border-radius: 8px;
    font-size: 0.88rem; margin-bottom: 1rem;
    display: none;
}

.admin-msg.show { display: block; }
.admin-msg.success { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
.admin-msg.error   { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }


@media (max-width: 900px) {
    .kpi-grid { grid-template-columns: repeat(2,1fr); }
    .kanban-board { grid-template-columns: 1fr; }
    .report-grid { grid-template-columns: 1fr; }
    .admin-sidebar { width: 56px; }
    .sidebar-nav li button span { display: none; }
    .sidebar-profile { display: none; }
    .sidebar-section { display: none; }
    .sidebar-badge { display: none; }
}
</style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

<asp:HiddenField ID="hfActivePanel" runat="server" Value="pnlDashboard" />
<asp:Label ID="lblAdminMsg" runat="server" CssClass="admin-msg" />
    
<div class="admin-shell">

 
    <div class="admin-sidebar">

        <div class="sidebar-profile">
            <div class="sidebar-avatar">A</div>
            <p class="sidebar-name">Administrator</p>
            <p class="sidebar-role">Admin</p>
        </div>

        <div class="sidebar-section">Dashboards</div>
        <ul class="sidebar-nav">
            <li>
                <button type="button" class="active" onclick="showPanel('pnlDashboard', this)">
                    <i class="bi bi-speedometer2"></i>
                    <span>Dashboard</span>
                </button>
            </li>
        </ul>

        <div class="sidebar-section">Management</div>
        <ul class="sidebar-nav">
            <li>
                <button type="button" onclick="showPanel('pnlApprovals', this)">
                    <i class="bi bi-person-check"></i>
                    <span>Approvals</span>
                    <asp:Label ID="lblPendingBadge" runat="server"
                        CssClass="sidebar-badge amber" Text="0" />
                </button>
            </li>
            <li>
                <button type="button" onclick="showPanel('pnlBookings', this)">
                    <i class="bi bi-calendar2-check"></i>
                    <span>Bookings</span>
                </button>
            </li>
            <li>
                <button type="button" onclick="showPanel('pnlUsers', this)">
                    <i class="bi bi-people"></i>
                    <span>User Accounts</span>
                </button>
            </li>
            <li>
                <button type="button" onclick="showPanel('pnlCategories', this)">
                    <i class="bi bi-grid"></i>
                    <span>Services</span>
                </button>
            </li>
        </ul>

        <div class="sidebar-section">Insights</div>
        <ul class="sidebar-nav">
            <li>
                <button type="button" onclick="showPanel('pnlReports', this)">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Reports</span>
                </button>
            </li>
            <li>
                <button type="button" onclick="showPanel('pnlAudit', this)">
                    <i class="bi bi-shield-check"></i>
                    <span>Audit Log</span>
                </button>
            </li>
        </ul>

    </div>

    
    <div class="admin-main">

        <div class="admin-topbar">
            <h5 id="topbarTitle">Dashboard</h5>
            <div class="admin-search">
                <i class="bi bi-search" style="color:var(--muted); font-size:0.85rem;"></i>
                <input type="text" placeholder="Search..." />
            </div>
        </div>

        <div class="admin-content">

           
            <div id="pnlDashboard" class="admin-panel active">

                <div class="kpi-grid">
                    <div class="kpi-card">
                        <div class="kpi-icon blue"><i class="bi bi-calendar2-check"></i></div>
                        <div class="kpi-label">Total Bookings</div>
                        <div class="kpi-value">
                            <asp:Label ID="lblTotalBookings" runat="server" Text="0" />
                        </div>
                        <div class="kpi-sub">All time</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon green"><i class="bi bi-cash-stack"></i></div>
                        <div class="kpi-label">Total Revenue</div>
                        <div class="kpi-value">
                            R<asp:Label ID="lblRevenue" runat="server" Text="0" />
                        </div>
                        <div class="kpi-sub">Completed bookings</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon amber"><i class="bi bi-person-badge"></i></div>
                        <div class="kpi-label">Active Providers</div>
                        <div class="kpi-value">
                            <asp:Label ID="lblActiveProviders" runat="server" Text="0" />
                        </div>
                        <div class="kpi-sub">Active and live</div>
                    </div>
                    <div class="kpi-card">
                        <div class="kpi-icon red"><i class="bi bi-check2-circle"></i></div>
                        <div class="kpi-label">Completion Rate</div>
                        <div class="kpi-value">
                            <asp:Label ID="lblCompletionRate" runat="server" Text="0" />%
                        </div>
                        <div class="kpi-sub">Bookings completed</div>
                    </div>
                </div>

              
                <div class="section-head">
                    <h6>Recent Bookings</h6>
                </div>
                <asp:GridView ID="gvRecentBookings" runat="server"
                    CssClass="admin-table"
                    AutoGenerateColumns="false"
                    EmptyDataText="No bookings yet."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="BookingID"    HeaderText="#" />
                        <asp:BoundField DataField="ReferenceNumber" HeaderText="Reference" />
                        <asp:BoundField DataField="CustomerID"   HeaderText="Customer ID" />
                        <asp:BoundField DataField="LocationID"   HeaderText="Location ID" />
                        <asp:BoundField DataField="BookingDate"  HeaderText="Date"
                            DataFormatString="{0:dd MMM yyyy}" HtmlEncode="false" />
                        <asp:BoundField DataField="BookingStatusID" HeaderText="Status ID" />
                    </Columns>
                </asp:GridView>

            </div>

           
            <div id="pnlApprovals" class="admin-panel">

                <div class="section-head">
                    <h6>Service Provider Registrations</h6>
                </div>

                <div class="kanban-board">

                   
                    <div class="kanban-col">
                        <div class="kanban-col-head">
                            <span class="kanban-col-title">Pending</span>
                            <span class="kanban-count amber">
                                <asp:Label ID="lblPendingCount" runat="server" Text="0" />
                            </span>
                        </div>
                        <asp:Repeater ID="rptPending" runat="server">
                            <ItemTemplate>
                                <div class="kanban-card">
                                    <h6><%# Eval("FullName") %></h6>
                                    <p><%# Eval("Category") %> &nbsp;·&nbsp; <%# Eval("Township") %></p>
                                    <p style="font-size:0.75rem; color:var(--muted);">
                                        Registered: <%# Eval("DateCreated", "{0:dd MMM yyyy}") %>
                                    </p>
                                    <div class="kanban-actions">
                                        <asp:Button runat="server" Text="Approve"
                                            CssClass="btn-approve"
                                            CommandName="Approve"
                                            CommandArgument='<%# Eval("ProviderID") %>'
                                            OnCommand="ProviderAction_Command"
                                            CausesValidation="false" />
                                        <asp:Button runat="server" Text="Reject"
                                            CssClass="btn-reject"
                                            CommandName="Reject"
                                            CommandArgument='<%# Eval("ProviderID") %>'
                                            OnCommand="ProviderAction_Command"
                                            CausesValidation="false" />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                 
                    <div class="kanban-col">
                        <div class="kanban-col-head">
                            <span class="kanban-col-title">Active</span>
                            <span class="kanban-count">
                                <asp:Label ID="lblActiveCount" runat="server" Text="0" />
                            </span>
                        </div>
                        <asp:Repeater ID="rptActive" runat="server">
                            <ItemTemplate>
                                <div class="kanban-card">
                                    <h6><%# Eval("FullName") %></h6>
                                    <p><%# Eval("Category") %> &nbsp;·&nbsp; <%# Eval("Township") %></p>
                                    <span class="status-pill pill-active">Active</span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                    
                    <div class="kanban-col">
                        <div class="kanban-col-head">
                            <span class="kanban-col-title">Verified</span>
                            <span class="kanban-count green">
                                <asp:Label ID="lblVerifiedCount" runat="server" Text="0" />
                            </span>
                        </div>
                        <asp:Repeater ID="rptVerified" runat="server">
                            <ItemTemplate>
                                <div class="kanban-card">
                                    <h6><%# Eval("FullName") %></h6>
                                    <p><%# Eval("Category") %> &nbsp;·&nbsp; <%# Eval("Township") %></p>
                                    <span class="status-pill pill-verified">Verified</span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>

                </div>
            </div>

   
            <div id="pnlBookings" class="admin-panel">

                <div class="section-head">
                    <h6>All Bookings</h6>
                </div>

                <asp:GridView ID="gvBookings" runat="server"
                    CssClass="admin-table"
                    AutoGenerateColumns="false"
                    DataKeyNames="BookingID"
                    EmptyDataText="No bookings found."
                    OnRowCommand="gvBookings_RowCommand"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="BookingID"    HeaderText="#" />
                        <asp:BoundField DataField="ReferenceNumber" HeaderText="Reference" />
                        <asp:BoundField DataField="CustomerID"   HeaderText="Customer ID" />
                        <asp:BoundField DataField="LocationID"   HeaderText="Location ID" />
                        <asp:BoundField DataField="BookingStatusID" HeaderText="Status ID" />
                        <asp:BoundField DataField="BookingDate"  HeaderText="Date"
                            DataFormatString="{0:dd MMM yyyy}" HtmlEncode="false" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlStatus" runat="server"
                                    CssClass="form-select form-select-sm"
                                    style="font-size:0.78rem; padding:0.2rem 0.5rem; width:130px;">
                                    <asp:ListItem Text="Pending"    Value="1" />
                                    <asp:ListItem Text="In Process" Value="2" />
                                    <asp:ListItem Text="Complete"   Value="3" />
                                    <asp:ListItem Text="Cancelled"  Value="4" />
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button runat="server" Text="Update"
                                    CssClass="btn-sm-sky"
                                    CommandName="UpdateStatus"
                                    CommandArgument='<%# Eval("BookingID") %>'
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

            </div>

           
            <div id="pnlUsers" class="admin-panel">

                <div class="section-head">
                    <h6>User Accounts</h6>
                </div>

                <asp:GridView ID="gvUsers" runat="server"
                    CssClass="admin-table"
                    AutoGenerateColumns="false"
                    DataKeyNames="UserID"
                    EmptyDataText="No users found."
                    OnRowCommand="gvUsers_RowCommand"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="UserID"      HeaderText="#" />
                        <asp:BoundField DataField="FullName"    HeaderText="Name" />
                        <asp:BoundField DataField="Email"       HeaderText="Email" />
                        <asp:BoundField DataField="Phone"       HeaderText="Phone" />
                        <asp:BoundField DataField="DateCreated" HeaderText="Joined"
                            DataFormatString="{0:dd MMM yyyy}" HtmlEncode="false" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# (bool)Eval("IsActive") ? "status-pill pill-active" : "status-pill pill-rejected" %>'>
                                    <%# (bool)Eval("IsActive") ? "Active" : "Inactive" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button runat="server"
                                    Text='<%# (bool)Eval("IsActive") ? "Deactivate" : "Activate" %>'
                                    CssClass='<%# (bool)Eval("IsActive") ? "btn-sm-red" : "btn-sm-sky" %>'
                                    CommandName="ToggleUser"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CausesValidation="false" />
                                <asp:Button runat="server" Text="Reset PW"
                                    CssClass="btn-sm-outline"
                                    CommandName="ResetPW"
                                    CommandArgument='<%# Eval("UserID") %>'
                                    CausesValidation="false"
                                    style="margin-left:4px;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

            </div>

            <div id="pnlCategories" class="admin-panel">

                <div class="section-head">
                    <h6>Service Categories</h6>
                    <button type="button" class="btn-sm-sky"
                        onclick="document.getElementById('addCatForm').style.display='block'">
                        <i class="bi bi-plus-lg me-1"></i> Add Category
                    </button>
                </div>

         >
                <div id="addCatForm" style="display:none; background:#fff; border-radius:12px; padding:1.2rem; margin-bottom:1rem; box-shadow:0 2px 10px rgba(12,74,110,0.07);">
                    <div class="row g-2 align-items-end">
                        <div class="col-sm-4">
                            <label style="font-size:0.78rem; font-weight:700; color:var(--sky-dark); text-transform:uppercase;">Category Name</label>
                            <asp:TextBox ID="txtCatName" runat="server"
                                CssClass="form-control form-control-sm mt-1"
                                placeholder="e.g. Electricians" />
                        </div>
                        <div class="col-sm-5">
                            <label style="font-size:0.78rem; font-weight:700; color:var(--sky-dark); text-transform:uppercase;">Description</label>
                            <asp:TextBox ID="txtCatDesc" runat="server"
                                CssClass="form-control form-control-sm mt-1"
                                placeholder="Short description" />
                        </div>
                        <div class="col-sm-3">
                            <asp:Button ID="btnAddCategory" runat="server" Text="Save Category"
                                CssClass="btn-sm-sky w-100"
                                OnClick="btnAddCategory_Click"
                                CausesValidation="false" />
                        </div>
                    </div>
                </div>

                <asp:GridView ID="gvCategories" runat="server"
                    CssClass="admin-table"
                    AutoGenerateColumns="false"
                    DataKeyNames="CategoryID"
                    EmptyDataText="No categories found."
                    OnRowCommand="gvCategories_RowCommand"
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="CategoryID"   HeaderText="#" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" />
                        <asp:BoundField DataField="Description"  HeaderText="Description" />
                        <asp:BoundField DataField="ProviderCount" HeaderText="Providers" />
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:Button runat="server" Text="Delete"
                                    CssClass="btn-sm-red"
                                    CommandName="DeleteCat"
                                    CommandArgument='<%# Eval("CategoryID") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Delete this category?');" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

            </div>

          
            <div id="pnlReports" class="admin-panel">

                <div class="section-head">
                    <h6>Generate Reports</h6>
                </div>

                <div class="report-grid">
                    <div class="report-card">
                        <i class="bi bi-calendar2-range"></i>
                        <h6>Bookings Report</h6>
                        <p>Total bookings by date range, status and category.</p>
                        <asp:Button ID="btnRptBookings" runat="server"
                            Text="Generate"
                            CssClass="btn-sm-sky"
                            OnClick="btnRptBookings_Click"
                            CausesValidation="false" />
                    </div>
                    <div class="report-card">
                        <i class="bi bi-person-lines-fill"></i>
                        <h6>Provider Report</h6>
                        <p>Active providers, completion rates and ratings.</p>
                        <asp:Button ID="btnRptProviders" runat="server"
                            Text="Generate"
                            CssClass="btn-sm-sky"
                            OnClick="btnRptProviders_Click"
                            CausesValidation="false" />
                    </div>
                    <div class="report-card">
                        <i class="bi bi-cash"></i>
                        <h6>Revenue Report</h6>
                        <p>Revenue breakdown by category and time period.</p>
                        <asp:Button ID="btnRptRevenue" runat="server"
                            Text="Generate"
                            CssClass="btn-sm-sky"
                            OnClick="btnRptRevenue_Click"
                            CausesValidation="false" />
                    </div>
                </div>

                <div style="margin-top: 1.5rem;">
                    <asp:GridView ID="gvReport" runat="server"
                        CssClass="admin-table"
                        AutoGenerateColumns="true"
                        EmptyDataText="Click Generate to load a report."
                        GridLines="None"
                        Visible="false" />
                </div>

            </div>

            
            <div id="pnlAudit" class="admin-panel">

                <div class="section-head">
                    <h6>Audit Log</h6>
                </div>

                <asp:GridView ID="gvAudit" runat="server"
                    CssClass="admin-table audit-row"
                    AutoGenerateColumns="false"
                    EmptyDataText="No audit records found."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="LogDate"     HeaderText="Date / Time"
                            DataFormatString="{0:dd MMM yyyy HH:mm}" HtmlEncode="false" />
                        <asp:BoundField DataField="AdminName"   HeaderText="Admin" />
                        <asp:BoundField DataField="Action"      HeaderText="Action" />
                        <asp:BoundField DataField="Description" HeaderText="Details" />
                    </Columns>
                </asp:GridView>

            </div>

        </div>
    </div>
</div>

<script>
    function showPanel(id, btn) {
       
        document.querySelectorAll('.admin-panel').forEach(p => p.classList.remove('active'));
       
        document.querySelectorAll('.sidebar-nav li button').forEach(b => b.classList.remove('active'));
       
        document.getElementById(id).classList.add('active');
        btn.classList.add('active');
        document.getElementById('<%= hfActivePanel.ClientID %>').value = id;
       
        document.getElementById('topbarTitle').textContent = btn.querySelector('span')?.textContent || '';
    }

    (function restoreActivePanel() {
        const panelId = document.getElementById('<%= hfActivePanel.ClientID %>').value || 'pnlDashboard';
        const panel = document.getElementById(panelId);
        if (!panel) return;

        document.querySelectorAll('.admin-panel').forEach(p => p.classList.remove('active'));
        panel.classList.add('active');

        const button = document.querySelector(`.sidebar-nav li button[onclick*="${panelId}"]`);
        if (button) {
            document.querySelectorAll('.sidebar-nav li button').forEach(b => b.classList.remove('active'));
            button.classList.add('active');
            document.getElementById('topbarTitle').textContent = button.querySelector('span')?.textContent || '';
        }
    })();
</script>

</asp:Content>
