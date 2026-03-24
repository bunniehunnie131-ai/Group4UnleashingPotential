<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="Unleashing_Potential.WebForm1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <style>
    :root {
        --sky:        #0ea5e9;
        --sky-dark:   #0369a1;
        --sky-deeper: #0c4a6e;
        --sky-light:  #bae6fd;
        --sky-pale:   #f0f9ff;
        --accent:     #f59e0b;
        --text:       #0f172a;
        --muted:      #64748b;
    }

    .register-wrap {
        max-width: 600px;
        margin: 0 auto;
    }
    .register-card {
        background: #ffffff;
        border: none;
        border-radius: 16px;
        box-shadow: 0 4px 24px rgba(12, 74, 110, 0.10);
        overflow: hidden;
    }
    .register-card-header {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        padding: 1.8rem 2rem 1.4rem;
    }
    .register-card-header h4 {
        font-family: 'Lora', serif;
        color: #f0f9ff;
        font-size: 1.4rem;
        margin: 0;
    }
    .register-card-header p {
        color: var(--sky-light);
        font-size: 0.85rem;
        margin: 0.3rem 0 0;
    }
    .register-card-body {
        padding: 2rem;
    }
    .form-label {
        font-weight: 600;
        font-size: 0.88rem;
        color: var(--sky-dark);
        margin-bottom: 0.3rem;
        text-transform: uppercase;
        letter-spacing: 0.4px;
    }
    .form-control, .form-select {
        border: 1.5px solid var(--sky-light);
        border-radius: 8px;
        font-size: 0.95rem;
        padding: 0.55rem 0.85rem;
        background-color: var(--sky-pale);
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .form-control:focus, .form-select:focus {
        border-color: var(--sky);
        box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.15);
        background-color: #fff;
    }
    .field-group {
        margin-bottom: 1.3rem;
    }
    .divider {
        border: none;
        border-top: 1px solid #e0f2fe;
        margin: 1.5rem 0;
    }
    .section-label {
        font-size: 0.75rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--sky);
        margin-bottom: 1rem;
    }
    .btn-register {
        background: linear-gradient(135deg, var(--sky), var(--sky-dark));
        border: none;
        color: white;
        font-weight: 600;
        padding: 0.65rem 2rem;
        border-radius: 8px;
        font-size: 0.95rem;
        transition: opacity 0.2s, transform 0.1s;
    }
    .btn-register:hover {
        opacity: 0.9;
        transform: translateY(-1px);
        color: white;
    }
    .btn-clear {
        background: transparent;
        border: 1.5px solid #93c5fd;
        color: var(--sky-dark);
        font-weight: 600;
        padding: 0.65rem 1.5rem;
        border-radius: 8px;
        font-size: 0.95rem;
        transition: background 0.2s;
    }
    .btn-clear:hover {
        background: #e0f2fe;
        color: var(--sky-deeper);
    }
    .terms-box {
        background: var(--sky-pale);
        border: 1.5px solid var(--sky-light);
        border-radius: 8px;
        padding: 0.85rem 1rem;
        display: flex;
        align-items: flex-start;
        gap: 0.6rem;
    }
    .terms-box .form-check-input {
        margin-top: 3px;
        width: 1.1em;
        height: 1.1em;
        border-color: var(--sky);
        flex-shrink: 0;
    }
    .terms-box .form-check-input:checked {
        background-color: var(--sky-dark);
        border-color: var(--sky-dark);
    }
    .terms-label {
        font-size: 0.9rem;
        color: var(--sky-deeper);
        line-height: 1.5;
    }
    .terms-label a {
        color: var(--sky-dark);
        font-weight: 600;
        text-decoration: underline;
    }
    .success-msg {
        background: var(--sky-pale);
        border: 1.5px solid var(--sky-light);
        border-radius: 8px;
        padding: 0.9rem 1.1rem;
        color: var(--sky-deeper);
        font-weight: 600;
        font-size: 0.95rem;
    }
    .password-wrap {
        position: relative;
    }
    .toggle-pw {
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
        background: none;
        border: none;
        padding: 0;
        cursor: pointer;
        color: var(--sky);
        display: flex;
        align-items: center;
    }
    .toggle-pw:hover {
        color: var(--sky-deeper);
    }
    .toggle-pw .eye-off { display: none; }
    .toggle-pw.active .eye-on  { display: none; }
    .toggle-pw.active .eye-off { display: block; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="register-wrap">
    <div class="register-card">

        <div class="register-card-header">
            <h4>Create your account</h4>
        </div>

        <div class="register-card-body">

            <p class="section-label">Personal Information</p>

            <div class="field-group">
                <label for="txtFullName" class="form-label">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="field-group">
                <label for="txtEmail" class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="field-group">
                <label for="txtPhone" class="form-label">Phone Number</label>
                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"></asp:TextBox>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    <div class="field-group">
                        <label for="txtDOB" class="form-label">Date of Birth</label>
                        <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="field-group">
                        <label for="ddlTownship" class="form-label">Township</label>
                        <asp:DropDownList ID="ddlTownship" runat="server" CssClass="form-select">
                            <asp:ListItem Text="-- Select --" Value="" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Quigney" Value="QG"></asp:ListItem>
                            <asp:ListItem Text="Southernwood" Value="SW"></asp:ListItem>
                            <asp:ListItem Text="Beacon Bay" Value="BB"></asp:ListItem>
                            <asp:ListItem Text="Mdantsane" Value="Ntsane"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <hr class="divider" />

            <p class="section-label">Security</p>

            <div class="field-group">
                <label for="txtPassword" class="form-label">Password</label>
                <div class="password-wrap">
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Choose a strong password" style="padding-right: 3rem;"></asp:TextBox>
                    <button type="button" class="toggle-pw" onclick="togglePassword('pw', this)">
                        <svg class="eye-on" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                        <svg class="eye-off" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.956 9.956 0 012.223-3.592M6.53 6.533A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.966 9.966 0 01-4.077 5.198M15 12a3 3 0 11-4.243-4.243M3 3l18 18" />
                        </svg>
                    </button>
                </div>
            </div>

            <div class="field-group">
                <label for="txtConfirmPassword" class="form-label">Confirm Password</label>
                <div class="password-wrap">
                    <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Repeat your password" style="padding-right: 3rem;"></asp:TextBox>
                    <button type="button" class="toggle-pw" onclick="togglePassword('cpw', this)">
                        <svg class="eye-on" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                        <svg class="eye-off" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.956 9.956 0 012.223-3.592M6.53 6.533A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.966 9.966 0 01-4.077 5.198M15 12a3 3 0 11-4.243-4.243M3 3l18 18" />
                        </svg>
                    </button>
                </div>
            </div>

            <hr class="divider" />

            <div class="field-group">
                <div class="terms-box">
                    <asp:CheckBox ID="chkTerms" runat="server" CssClass="form-check-input" />
                    <label class="terms-label" for="chkTerms">
                        I agree to the <a href="#">Terms and Conditions</a> and confirm that all information provided is accurate.
                    </label>
                </div>
            </div>

            <div class="d-flex gap-2 mt-3">
                <asp:Button ID="btnRegister" runat="server" Text="Create Account"
                    CssClass="btn btn-register"
                    OnClick="btnRegister_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear"
                    CssClass="btn btn-clear"
                    CausesValidation="False"
                    OnClick="btnClear_Click" />
            </div>

            <div class="mt-3">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </div>

            <asp:ValidationSummary ID="ValidationSummary1" runat="server" 
                HeaderText="Oops! Please check the following:" 
                ForeColor="Red" />

        </div>
    </div>
    </div>

    <script>
        function togglePassword(field, btn) {
            var input;
            if (field === 'pw') {
                input = document.getElementById('<%= txtPassword.ClientID %>');
            } else {
                input = document.getElementById('<%= txtConfirmPassword.ClientID %>');
            }
            if (input.type === 'password') {
                input.type = 'text';
                btn.classList.add('active');
            } else {
                input.type = 'password';
                btn.classList.remove('active');
            }
        }
    </script>
</asp:Content>  