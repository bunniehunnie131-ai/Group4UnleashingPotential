<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ServiceProviderDashboard.aspx.cs" Inherits="Unleashing_Potential.ServiceProviderDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --primary:  #0369a1;
            --accent:   #0ea5e9;
            --accent2:  #f59e0b;
            --danger:   #dc2626;
            --light-bg: #f0f9ff;
            --card-bg:  #ffffff;
            --text:     #0f172a;
            --muted:    #6b7280;
            --border:   #bae6fd;
            --radius:   10px;
        }
        body { background: var(--light-bg); }

        /* Header */
        .prov-header {
            background: linear-gradient(135deg, var(--primary) 50%, #0c4a6e);
            color: #fff;
            padding: 32px;
            border-radius: var(--radius);
            margin-bottom: 28px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
        }
        .prov-header h2 { margin:0; font-size:1.7rem; font-weight:700; }
        .prov-header p  { margin:4px 0 0; opacity:.8; font-size:.92rem; }
        .prov-header .status-pill {
            background: rgba(255,255,255,.2);
            border: 1px solid rgba(255,255,255,.4);
            color: #fff;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: .82rem;
            font-weight: 700;
        }
        .prov-header .status-pill.approved { background: rgba(34,197,94,.3); }
        .prov-header .status-pill.pending  { background: rgba(245,158,11,.3); }

        /* KPI */
        .kpi-row { display:flex; gap:16px; flex-wrap:wrap; margin-bottom:28px; }
        .kpi-card {
            flex: 1 1 150px;
            background: var(--card-bg);
            border-radius: var(--radius);
            padding: 20px 18px;
            border-left: 5px solid var(--primary);
            box-shadow: 0 2px 10px rgba(0,0,0,.06);
        }
        .kpi-card.ac  { border-left-color: var(--accent);  }
        .kpi-card.am  { border-left-color: var(--accent2); }
        .kpi-card.dng { border-left-color: var(--danger);  }
        .kpi-card .val { font-size:2rem; font-weight:800; color:var(--text); line-height:1; }
        .kpi-card .lbl { font-size:.78rem; color:var(--muted); margin-top:4px; text-transform:uppercase; letter-spacing:.05em; }

        /* Tabs */
        .tab-bar { display:flex; gap:6px; border-bottom:2px solid var(--border); margin-bottom:24px; flex-wrap:wrap; }
        .tab-btn {
            background:none; border:none; padding:10px 20px; font-size:.92rem;
            color:var(--muted); cursor:pointer; border-bottom:3px solid transparent;
            margin-bottom:-2px; border-radius:6px 6px 0 0;
            transition:color .2s, border-color .2s; font-weight:600;
        }
        .tab-btn.active, .tab-btn:hover { color:var(--primary); border-bottom-color:var(--primary); }

        .dash-section { display:none; }
        .dash-section.active { display:block; }

        /* Panel */
        .panel { background:var(--card-bg); border-radius:var(--radius); box-shadow:0 2px 10px rgba(0,0,0,.06); padding:24px; margin-bottom:22px; }
        .panel h4 { margin:0 0 16px; color:var(--primary); font-size:1.05rem; font-weight:700; border-bottom:1px solid var(--border); padding-bottom:10px; }

        /* Badges */
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.75rem; font-weight:700; text-transform:uppercase; }
        .badge-pending    { background:#fff3cd; color:#856404; }
        .badge-confirmed  { background:#dbeafe; color:#1e40af; }
        .badge-completed  { background:#d1e7dd; color:#0a3622; }
        .badge-cancelled  { background:#f8d7da; color:#842029; }
        .badge-rejected   { background:#fed7aa; color:#9a3412; }
        .badge-accepted   { background:#dbeafe; color:#1e40af; }
        .badge-inprogress { background:#d1ecf1; color:#0c5460; }

        /* Grid */
        .grid-wrap { overflow-x:auto; }
        .styled-grid { width:100%; border-collapse:collapse; font-size:.88rem; }
        .styled-grid th { background:var(--primary); color:#fff; padding:10px 14px; text-align:left; font-weight:600; white-space:nowrap; }
        .styled-grid td { padding:10px 14px; border-bottom:1px solid var(--border); vertical-align:middle; }
        .styled-grid tr:hover td { background:#f0fdf4; }

        /* Forms */
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        @media(max-width:600px){ .form-row{grid-template-columns:1fr;} .kpi-row{flex-direction:column;} }
        .form-group { margin-bottom:14px; }
        .form-group label { display:block; font-weight:600; font-size:.85rem; color:var(--text); margin-bottom:5px; }
        .form-group input, .form-group select, .form-group textarea {
            width:100%; padding:9px 12px; border:1.5px solid var(--border);
            border-radius:6px; font-size:.92rem; box-sizing:border-box; transition:border-color .2s;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { border-color:var(--primary); outline:none; }

        /* Buttons */
        .btn-primary { background:var(--primary); color:#fff; border:none; padding:10px 24px; border-radius:6px; font-size:.92rem; font-weight:600; cursor:pointer; }
        .btn-primary:hover { background:#075985; }
        .btn-sm { padding:6px 14px; font-size:.8rem; border:none; border-radius:5px; cursor:pointer; font-weight:600; color:#fff; }
        .btn-confirm  { background:#2563eb; }
        .btn-accept   { background:#2563eb; }
        .btn-reject   { background:#d97706; }
        .btn-progress { background:#d97706; }
        .btn-complete { background:var(--primary); }
        .btn-cancel   { background:var(--danger); }

        /* Message */
        .msg { padding:12px 18px; border-radius:6px; margin-bottom:16px; font-size:.9rem; display:none; }
        .msg.show { display:block; }
        .msg.success { background:#d1e7dd; color:#0a3622; border:1px solid #a3cfbb; }
        .msg.error   { background:#f8d7da; color:#842029; border:1px solid #f1aeb5; }

        /* Star rating */
        .stars { color:#f59e0b; font-size:1.1rem; }
        .review-card { border:1px solid var(--border); border-radius:8px; padding:14px 18px; margin-bottom:12px; }
        .review-card .reviewer { font-weight:700; font-size:.9rem; }
        .review-card .review-date { font-size:.78rem; color:var(--muted); }
        .review-card .review-text { margin-top:6px; font-size:.9rem; color:var(--text); }

        /* Earnings chart row */
        .earn-row { display:flex; gap:16px; flex-wrap:wrap; }
        .earn-box { flex:1 1 180px; background:var(--light-bg); border:1px solid var(--border); border-radius:8px; padding:18px; text-align:center; }
        .earn-box .earn-val { font-size:1.6rem; font-weight:800; color:var(--primary); }
        .earn-box .earn-lbl { font-size:.8rem; color:var(--muted); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Label ID="lblMsg" runat="server" CssClass="msg" EnableViewState="false" />

    <!-- Hidden field to keep providerID across postbacks -->
    <asp:HiddenField ID="hfProviderID" runat="server" />

    <!-- Page Header -->
    <div class="prov-header">
        <div>
            <h2><asp:Literal ID="litProvName" runat="server" /></h2>
            <p>
                <asp:Literal ID="litCategory" runat="server" /> &nbsp;|&nbsp;
                <asp:Literal ID="litLocation" runat="server" /> &nbsp;|&nbsp;
                R<asp:Literal ID="litPrice" runat="server" /> / <asp:Literal ID="litPriceUnit" runat="server" />
            </p>
        </div>
        <asp:Label ID="lblApprovalStatus" runat="server" CssClass="status-pill" Text="Approved" />
    </div>

    <!-- KPI Cards -->
    <div class="kpi-row">
        <div class="kpi-card">
            <div class="val"><asp:Literal ID="litTotalJobs" runat="server">0</asp:Literal></div>
            <div class="lbl">Total Bookings</div>
        </div>
        <div class="kpi-card ac">
            <div class="val"><asp:Literal ID="litActiveJobs" runat="server">0</asp:Literal></div>
            <div class="lbl">Active Jobs</div>
        </div>
        <div class="kpi-card am">
            <div class="val">R<asp:Literal ID="litEarnings" runat="server">0</asp:Literal></div>
            <div class="lbl">Total Earnings</div>
        </div>
        <div class="kpi-card dng">
            <div class="val"><asp:Literal ID="litRating" runat="server">0</asp:Literal>★</div>
            <div class="lbl">Avg Rating</div>
        </div>
    </div>

    <!-- Tabs -->
    <asp:HiddenField ID="hfActiveTab" runat="server" />
    <div class="tab-bar">
        <button type="button" class='tab-btn <%= TabButtonClass("bookings") %>' onclick="switchTab('bookings',this)">Bookings</button>
        <button type="button" class='tab-btn <%= TabButtonClass("earnings") %>' onclick="switchTab('earnings',this)">Earnings</button>
        <button type="button" class='tab-btn <%= TabButtonClass("reviews") %>' onclick="switchTab('reviews',this)">Reviews</button>
        <button type="button" class='tab-btn <%= TabButtonClass("profile") %>' onclick="switchTab('profile',this)">My Profile</button>
    </div>

    <!-- ═══ TAB: BOOKINGS ═══ -->
    <div id="tab-bookings" class='dash-section <%= TabSectionClass("bookings") %>'>
        <div class="panel">
            <h4>Assigned Bookings</h4>
            <div style="margin-bottom:14px;display:flex;gap:10px;align-items:center;flex-wrap:wrap;">
                <label style="font-weight:600;font-size:.88rem;">Filter:</label>
                    <asp:DropDownList ID="ddlFilter" runat="server"
                        style="padding:7px 10px;border:1.5px solid var(--border);border-radius:6px;font-size:.9rem;max-width:200px;"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlFilter_Changed">
                        <asp:ListItem Value="">All</asp:ListItem>
                        <asp:ListItem Value="Pending">Pending</asp:ListItem>
                        <asp:ListItem Value="Confirmed">Confirmed</asp:ListItem>
                        <asp:ListItem Value="Completed">Completed</asp:ListItem>
                        <asp:ListItem Value="Cancelled">Cancelled</asp:ListItem>
                        <asp:ListItem Value="Rejected">Rejected</asp:ListItem>
                    </asp:DropDownList>
                </div>

            <div class="grid-wrap">
                <asp:GridView ID="gvBookings" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="styled-grid"
                    EmptyDataText="No bookings assigned to you yet."
                    GridLines="None"
                    OnRowCommand="gvBookings_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="ReferenceNumber" HeaderText="Ref #" />
                        <asp:BoundField DataField="CustomerName"    HeaderText="Customer" />
                        <asp:BoundField DataField="CustomerPhone"   HeaderText="Phone" />
                        <asp:BoundField DataField="AppointmentDate" HeaderText="Appointment" DataFormatString="{0:dd MMM yyyy}" />
                        <asp:BoundField DataField="Service"         HeaderText="Service" />
                        <asp:BoundField DataField="Price"           HeaderText="Price" DataFormatString="R {0:N2}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='badge badge-<%# Eval("Status").ToString().ToLower().Replace(" ","") %>'><%# Eval("Status") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Update Status">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnConfirm" runat="server"
                                    Text="Confirm"
                                    CommandName="Confirm"
                                    CommandArgument='<%# Eval("BookingID") %>'
                                    CssClass="btn-sm btn-confirm"
                                    Visible='<%# Eval("Status").ToString() == "Pending" %>'
                                    CausesValidation="false" />
                                <asp:LinkButton ID="btnComplete" runat="server"
                                    Text="Complete"
                                    CommandName="Complete"
                                    CommandArgument='<%# Eval("BookingID") %>'
                                    CssClass="btn-sm btn-complete"
                                    Visible='<%# Eval("Status").ToString() == "Confirmed" %>'
                                    CausesValidation="false" />
                                <asp:LinkButton ID="btnReject" runat="server"
                                    Text="Reject"
                                    CommandName="RejectBooking"
                                    CommandArgument='<%# Eval("BookingID") %>'
                                    CssClass="btn-sm btn-reject"
                                    Visible='<%# Eval("Status").ToString() == "Pending" %>'
                                    CausesValidation="false" />
                                <asp:LinkButton ID="btnCancel" runat="server"
                                    Text="Cancel"
                                    CommandName="CancelBooking"
                                    CommandArgument='<%# Eval("BookingID") %>'
                                    CssClass="btn-sm btn-cancel"
                                    Visible='<%# Eval("Status").ToString() == "Confirmed" %>'
                                    CausesValidation="false" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- ═══ TAB: EARNINGS ═══ -->
    <div id="tab-earnings" class='dash-section <%= TabSectionClass("earnings") %>'>
        <div class="panel">
            <h4>Earnings Overview</h4>
            <div class="earn-row">
                <div class="earn-box">
                    <div class="earn-val">R<asp:Literal ID="litEarnMonth" runat="server">0</asp:Literal></div>
                    <div class="earn-lbl">This Month</div>
                </div>
                <div class="earn-box">
                    <div class="earn-val">R<asp:Literal ID="litEarnYear" runat="server">0</asp:Literal></div>
                    <div class="earn-lbl">This Year</div>
                </div>
                <div class="earn-box">
                    <div class="earn-val"><asp:Literal ID="litJobsMonth" runat="server">0</asp:Literal></div>
                    <div class="earn-lbl">Jobs This Month</div>
                </div>
                <div class="earn-box">
                    <div class="earn-val"><asp:Literal ID="litJobsTotal" runat="server">0</asp:Literal></div>
                    <div class="earn-lbl">Total Completed</div>
                </div>
            </div>
        </div>

        <div class="panel">
            <h4>Completed Bookings</h4>
            <div class="grid-wrap">
                <asp:GridView ID="gvCompleted" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="styled-grid"
                    EmptyDataText="No completed bookings yet."
                    GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="ReferenceNumber" HeaderText="Ref #" />
                        <asp:BoundField DataField="CustomerName"    HeaderText="Customer" />
                        <asp:BoundField DataField="AppointmentDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy}" />
                        <asp:BoundField DataField="Service"         HeaderText="Service" />
                        <asp:BoundField DataField="Price"           HeaderText="Earned" DataFormatString="R {0:N2}" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <!-- ═══ TAB: REVIEWS ═══ -->
    <div id="tab-reviews" class='dash-section <%= TabSectionClass("reviews") %>'>
        <div class="panel">
            <h4>Customer Reviews</h4>
            <asp:Repeater ID="rptReviews" runat="server">
                <ItemTemplate>
                    <div class="review-card">
                        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:8px;">
                            <span class="reviewer"><%# Eval("ReviewerName") %></span>
                            <span class="review-date"><%# ((DateTime)Eval("ReviewDate")).ToString("dd MMM yyyy") %></span>
                        </div>
                        <div class="stars"><%# new string('★', Convert.ToInt32(Eval("Rating"))) %><%# new string('☆', 5 - Convert.ToInt32(Eval("Rating"))) %></div>
                        <div class="review-text"><%# Eval("Comment") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Label ID="lblNoReviews" runat="server" Text="No reviews yet."
                style="color:var(--muted);display:none;" />
        </div>
    </div>

    <!-- ═══ TAB: PROFILE ═══ -->
    <div id="tab-profile" class='dash-section <%= TabSectionClass("profile") %>'>
        <div class="panel">
            <h4>My Service Profile</h4>
            <asp:Label ID="lblProfileMsg" runat="server" CssClass="msg" EnableViewState="false" />
            <div class="form-row">
                <div class="form-group">
                    <label>Business / Your Name</label>
                    <asp:TextBox ID="txtName" runat="server" MaxLength="100" />
                    <asp:RequiredFieldValidator ControlToValidate="txtName" runat="server"
                        ValidationGroup="Prov" ErrorMessage="Name is required." ForeColor="Red" Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server">
                        <asp:ListItem>Tailoring</asp:ListItem>
                        <asp:ListItem>Plumbing</asp:ListItem>
                        <asp:ListItem>Painting</asp:ListItem>
                        <asp:ListItem>Hairdressing</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Specialty</label>
                    <asp:TextBox ID="txtSpecialty" runat="server" MaxLength="100" />
                </div>
                <div class="form-group">
                    <label>Price (R)</label>
                    <asp:TextBox ID="txtPrice" runat="server" TextMode="Number" />
                    <asp:RequiredFieldValidator ControlToValidate="txtPrice" runat="server"
                        ValidationGroup="Prov" ErrorMessage="Price is required." ForeColor="Red" Display="Dynamic" />
                    <asp:CustomValidator ControlToValidate="txtPrice" runat="server"
                        ValidationGroup="Prov" OnServerValidate="cvPrice_ServerValidate"
                        ForeColor="Red" Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label>Price Unit</label>
                    <asp:DropDownList ID="ddlPriceUnit" runat="server">
                        <asp:ListItem>per hour</asp:ListItem>
                        <asp:ListItem>per day</asp:ListItem>
                        <asp:ListItem>per job</asp:ListItem>
                        <asp:ListItem>per session</asp:ListItem>
                        <asp:ListItem>per month</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Location / Area</label>
                    <asp:TextBox ID="txtLocation" runat="server" MaxLength="100" />
                </div>
                <div class="form-group">
                    <label>Phone</label>
                    <asp:TextBox ID="txtPhone" runat="server" MaxLength="20" />
                    <asp:RegularExpressionValidator ControlToValidate="txtPhone" runat="server"
                        ValidationGroup="Prov" ValidationExpression="^[\d\s\+\-]{7,20}$"
                        ErrorMessage="Enter a valid phone number." ForeColor="Red" Display="Dynamic" />
                </div>
                <div class="form-group">
                    <label>Years of Experience</label>
                    <asp:TextBox ID="txtYears" runat="server" TextMode="Number" />
                    <asp:RangeValidator ControlToValidate="txtYears" runat="server"
                        MinimumValue="0" MaximumValue="60" Type="Integer"
                        ValidationGroup="Prov" ErrorMessage="Enter valid years." ForeColor="Red" Display="Dynamic" />
                </div>
            </div>
            <div class="form-group">
                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4" MaxLength="500" />
            </div>
            <asp:Button ID="btnSaveProfile" runat="server" Text="Save Profile"
                CssClass="btn-primary" ValidationGroup="Prov"
                OnClick="btnSaveProfile_Click" />
        </div>
    </div>

    <script>
        function switchTab(name, btn) {
            document.querySelectorAll('.dash-section').forEach(s => s.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            var section = document.getElementById('tab-' + name);
            if (section) section.classList.add('active');
            if (btn) btn.classList.add('active');

            var activeTabField = document.getElementById('<%= hfActiveTab.ClientID %>');
            if (activeTabField) activeTabField.value = name;
        }
    </script>

</asp:Content>
