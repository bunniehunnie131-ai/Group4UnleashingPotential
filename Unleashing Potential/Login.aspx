<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Unleashing_Potential.WebForm2" %>
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

    .login-wrap {
        max-width: 460px;
        margin: 0 auto;
    }
    .login-card {
        background: #ffffff;
        border: none;
        border-radius: 16px;
        box-shadow: 0 4px 24px rgba(12, 74, 110, 0.10);
        overflow: hidden;
    }
    .login-card-header {
        background: linear-gradient(135deg, var(--sky-dark), var(--sky-deeper));
        padding: 1.8rem 2rem 1.4rem;
    }
    .login-card-header h4 {
        font-family: 'Lora', serif;
        color: #f0f9ff;
        font-size: 1.4rem;
        margin: 0;
    }
    .login-card-header p {
        color: var(--sky-light);
        font-size: 0.85rem;
        margin: 0.3rem 0 0;
    }
    .login-card-body {
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
    .form-control {
        border: 1.5px solid var(--sky-light);
        border-radius: 8px;
        font-size: 0.95rem;
        padding: 0.55rem 0.85rem;
        background-color: var(--sky-pale);
        transition: border-color 0.2s, box-shadow 0.2s;
    }
    .form-control:focus {
        border-color: var(--sky);
        box-shadow: 0 0 0 3px rgba(14, 165, 233, 0.15);
        background-color: #fff;
    }
    .field-group {
        margin-bottom: 1.3rem;
    }
    .btn-login {
        background: linear-gradient(135deg, var(--sky), var(--sky-dark));
        border: none;
        color: white;
        font-weight: 600;
        padding: 0.65rem 2rem;
        border-radius: 8px;
        font-size: 0.95rem;
        width: 100%;
        transition: opacity 0.2s, transform 0.1s;
    }
    .btn-login:hover {
        opacity: 0.9;
        transform: translateY(-1px);
        color: white;
    }
    .divider {
        border: none;
        border-top: 1px solid #e0f2fe;
        margin: 1.5rem 0;
    }
    .forgot-link {
        font-size: 0.88rem;
        color: var(--sky-dark);
        text-decoration: underline;
        font-weight: 600;
    }
    .forgot-link:hover {
        color: var(--sky-deeper);
    }
    .register-prompt {
        font-size: 0.9rem;
        color: var(--muted);
        text-align: center;
        margin-top: 1.2rem;
    }
    .register-prompt a {
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
    .toggle-pw:hover { color: var(--sky-deeper); }
    .toggle-pw .eye-off { display: none; }
    .toggle-pw.active .eye-on  { display: none; }
    .toggle-pw.active .eye-off { display: block; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="login-wrap">
        <div class="login-card">

            <div class="login-card-header">
                <h4>Welcome back</h4>
                <p>Sign in to your account</p>
            </div>

            <div class="login-card-body">

                <div class="field-group">
                    <label for="txtEmail" class="form-label">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="field-group">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <label for="txtPassword" class="form-label mb-0">Password</label>
                        <a href="#" class="forgot-link">Forgot password?</a>
                    </div>
                    <div class="password-wrap">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                            TextMode="Password" placeholder="Enter your password"
                            style="padding-right: 3rem;"></asp:TextBox>
                        <button type="button" class="toggle-pw" onclick="togglePassword(this)">
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

                <asp:Button ID="btnLogin" runat="server" Text="Sign In"
                    CssClass="btn btn-login"
                    OnClick="btnLogin_Click" />

                <div class="mt-3">
                    <asp:Label ID="lblLoginMessage" runat="server"></asp:Label>
                </div>

                <hr class="divider" />

                <p class="register-prompt">
                    Don't have an account? <a href="Register.aspx">Create one here</a>
                </p>

            </div>
        </div>
    </div>

    <script>
        function togglePassword(btn) {
            var input = document.getElementById('<%= txtPassword.ClientID %>');
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