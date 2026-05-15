<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="Unleashing_Potential.WebForm13" %>

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

    .fp-wrap {
        max-width: 480px;
        margin: 0 auto;
    }

    .fp-card {
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 4px 24px rgba(12,74,110,0.10);
        overflow: hidden;
    }

    .fp-header {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        padding: 1.8rem 2rem 1.4rem;
    }

    .fp-header h4 {
        font-family: 'Lora', serif;
        color: #f0f9ff;
        font-size: 1.4rem;
        margin: 0;
    }

    .fp-header p {
        color: var(--sky-light);
        font-size: 0.85rem;
        margin: 0.3rem 0 0;
    }

    .fp-body {
        padding: 2rem;
    }

    .form-label {
        font-weight: 600;
        font-size: 0.88rem;
        color: var(--sky-dark);
        margin-bottom: 0.3rem;
        text-transform: uppercase;
        letter-spacing: 0.4px;
        display: block;
    }

    .form-control {
        border: 1.5px solid var(--sky-light);
        border-radius: 8px;
        font-size: 0.95rem;
        padding: 0.55rem 0.85rem;
        background-color: var(--sky-pale);
        width: 100%;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-control:focus {
        border-color: var(--sky);
        box-shadow: 0 0 0 3px rgba(14,165,233,0.15);
        background-color: #fff;
        outline: none;
    }

    .field-group { margin-bottom: 1.1rem; }

    .field-error {
        color: #dc2626;
        font-size: 0.8rem;
        margin-top: 0.25rem;
        display: block;
    }

    .btn-primary-fp {
        background: linear-gradient(135deg, var(--sky), var(--sky-dark));
        border: none;
        color: white;
        font-weight: 700;
        padding: 0.65rem 2rem;
        border-radius: 8px;
        font-size: 0.95rem;
        letter-spacing: 0.5px;
        cursor: pointer;
        transition: opacity 0.2s;
    }

    .btn-primary-fp:hover { opacity: 0.9; color: white; }

    .step-indicator {
        display: flex;
        gap: 0.5rem;
        margin-bottom: 1.5rem;
    }

    .step-dot {
        width: 10px; height: 10px;
        border-radius: 50%;
        background: var(--sky-light);
    }

    .step-dot.active { background: var(--sky-dark); }

    .divider {
        border: none;
        border-top: 1px solid #e0f2fe;
        margin: 1.5rem 0;
    }

    .back-link {
        font-size: 0.88rem;
        color: var(--sky-dark);
        text-decoration: underline;
        cursor: pointer;
        background: none;
        border: none;
        padding: 0;
    }

    .password-wrap { position: relative; }

    .toggle-pw {
        position: absolute;
        right: 10px; top: 50%;
        transform: translateY(-50%);
        background: none; border: none;
        cursor: pointer; color: var(--sky);
        display: flex; align-items: center;
    }

    .toggle-pw:hover { color: var(--sky-deeper); }
    .toggle-pw .eye-off { display: none; }
    .toggle-pw.active .eye-on  { display: none; }
    .toggle-pw.active .eye-off { display: block; }
</style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<div class="fp-wrap">
<div class="fp-card">

    <div class="fp-header">
        <h4>Reset your password</h4>
        <asp:Label ID="lblStepSubtitle" runat="server"
            Text="Enter your registered email address to begin."
            style="color: #bae6fd; font-size: 0.85rem;"></asp:Label>
    </div>

    <div class="fp-body">

        
        <div class="step-indicator">
            <asp:Panel ID="dot1" runat="server" CssClass="step-dot active"></asp:Panel>
            <asp:Panel ID="dot2" runat="server" CssClass="step-dot"></asp:Panel>
            <asp:Panel ID="dot3" runat="server" CssClass="step-dot"></asp:Panel>
        </div>

        
        <asp:Panel ID="pnlStep1" runat="server">
            <div class="field-group">
                <label for="txtEmail" class="form-label">Email Address</label>
                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                    placeholder="Enter your registered email"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationGroup="Step1"
                    ErrorMessage="Email address is required."
                    Display="Dynamic" CssClass="field-error" ForeColor="">
                    Email address is required.
                </asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                    ControlToValidate="txtEmail"
                    ValidationGroup="Step1"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Please enter a valid email address."
                    Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please enter a valid email address.
                </asp:RegularExpressionValidator>
            </div>

            <asp:Button ID="btnStep1" runat="server" Text="Continue"
                CssClass="btn btn-primary-fp"
                ValidationGroup="Step1"
                OnClick="btnStep1_Click" />
        </asp:Panel>

        
        <asp:Panel ID="pnlStep2" runat="server" Visible="false">
            <div class="field-group">
                <label class="form-label">Security Question</label>
                <asp:Label ID="lblSecurityQuestion" runat="server"
                    CssClass="form-control"
                    style="background:#f0f9ff; display:block; padding:0.55rem 0.85rem;
                           border:1.5px solid #bae6fd; border-radius:8px;
                           font-size:0.95rem; color:#0f172a;">
                </asp:Label>
            </div>

            <div class="field-group">
                <label for="txtAnswer" class="form-label">Your Answer</label>
                <asp:TextBox ID="txtAnswer" runat="server" CssClass="form-control"
                    placeholder="Type your answer"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvAnswer" runat="server"
                    ControlToValidate="txtAnswer"
                    ValidationGroup="Step2"
                    ErrorMessage="Please enter your answer."
                    Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please enter your answer.
                </asp:RequiredFieldValidator>
            </div>

            <div class="d-flex gap-2">
                <asp:Button ID="btnStep2" runat="server" Text="Verify Answer"
                    CssClass="btn btn-primary-fp"
                    ValidationGroup="Step2"
                    OnClick="btnStep2_Click" />
                <asp:Button ID="btnBack1" runat="server" Text="← Back"
                    CssClass="btn back-link"
                    CausesValidation="false"
                    OnClick="btnBack1_Click" />
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlStep3" runat="server" Visible="false">
            <div class="field-group">
                <label for="txtNewPassword" class="form-label">New Password</label>
                <div class="password-wrap">
                    <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control"
                        TextMode="Password" placeholder="Choose a strong password"
                        style="padding-right:3rem;"></asp:TextBox>
                    <button type="button" class="toggle-pw" onclick="togglePw('np', this)">
                        <svg class="eye-on" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                        </svg>
                        <svg class="eye-off" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.956 9.956 0 012.223-3.592M6.53 6.533A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.966 9.966 0 01-4.077 5.198M15 12a3 3 0 11-4.243-4.243M3 3l18 18"/>
                        </svg>
                    </button>
                </div>
                <asp:RequiredFieldValidator ID="rfvNewPassword" runat="server"
                    ControlToValidate="txtNewPassword"
                    ValidationGroup="Step3"
                    ErrorMessage="New password is required."
                    Display="Dynamic" CssClass="field-error" ForeColor="">
                    New password is required.
                </asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revNewPassword" runat="server"
                    ControlToValidate="txtNewPassword"
                    ValidationGroup="Step3"
                    ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$"
                    ErrorMessage="Password must be 8+ characters with uppercase, lowercase, number, and special character."
                    Display="Dynamic" CssClass="field-error" ForeColor="">
                    Password must be 8+ characters with uppercase, lowercase, number, and special character.
                </asp:RegularExpressionValidator>
            </div>

            <div class="field-group">
                <label for="txtConfirmNewPassword" class="form-label">Confirm New Password</label>
                <div class="password-wrap">
                    <asp:TextBox ID="txtConfirmNewPassword" runat="server" CssClass="form-control"
                        TextMode="Password" placeholder="Repeat new password"
                        style="padding-right:3rem;"></asp:TextBox>
                    <button type="button" class="toggle-pw" onclick="togglePw('cnp', this)">
                        <svg class="eye-on" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                        </svg>
                        <svg class="eye-off" xmlns="http://www.w3.org/2000/svg" width="18" height="18" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.956 9.956 0 012.223-3.592M6.53 6.533A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.966 9.966 0 01-4.077 5.198M15 12a3 3 0 11-4.243-4.243M3 3l18 18"/>
                        </svg>
                    </button>
                </div>
                <asp:RequiredFieldValidator ID="rfvConfirmNewPassword" runat="server"
                    ControlToValidate="txtConfirmNewPassword"
                    ValidationGroup="Step3"
                    ErrorMessage="Please confirm your new password."
                    Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please confirm your new password.
                </asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPasswordMatch" runat="server"
                    ControlToValidate="txtConfirmNewPassword"
                    ControlToCompare="txtNewPassword"
                    ValidationGroup="Step3"
                    ErrorMessage="Passwords do not match."
                    Display="Dynamic" CssClass="field-error" ForeColor="">
                    Passwords do not match.
                </asp:CompareValidator>
            </div>

            <div class="d-flex gap-2">
                <asp:Button ID="btnStep3" runat="server" Text="Reset Password"
                    CssClass="btn btn-primary-fp"
                    ValidationGroup="Step3"
                    OnClick="btnStep3_Click" />
                <asp:Button ID="btnBack2" runat="server" Text="← Back"
                    CssClass="btn back-link"
                    CausesValidation="false"
                    OnClick="btnBack2_Click" />
            </div>
        </asp:Panel>

        
        <div class="mt-3">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </div>

        <hr class="divider" />
        <p style="font-size:0.9rem; color:#64748b; text-align:center; margin:0;">
            Remember your password? <a href="Login.aspx"
                style="color:#0369a1; font-weight:600; text-decoration:underline;">Sign in here</a>
        </p>

    </div>
</div>
</div>

<script>
    function togglePw(field, btn) {
        var input;
        if      (field === 'np')  input = document.getElementById('<%= txtNewPassword.ClientID %>');
        else                      input = document.getElementById('<%= txtConfirmNewPassword.ClientID %>');

        input.type = input.type === 'password' ? 'text' : 'password';
        btn.classList.toggle('active');
    }
</script>
</asp:Content>
