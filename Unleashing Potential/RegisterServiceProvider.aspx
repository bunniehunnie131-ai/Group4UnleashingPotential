<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RegisterServiceProvider.aspx.cs" Inherits="Unleashing_Potential.WebForm14" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        :root {
            --sky: #0ea5e9;
            --sky-dark: #0369a1;
            --sky-deeper: #0c4a6e;
            --sky-light: #bae6fd;
            --sky-pale: #f0f9ff;
            --accent: #f59e0b;
            --text: #0f172a;
            --muted: #64748b;
        }

        .register-wrap {
            max-width: 640px;
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
                outline: none;
            }

        .field-group {
            margin-bottom: 1.1rem;
        }

        .section-label {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--sky-dark);
            margin-bottom: 0.8rem;
        }

        .divider {
            border: none;
            border-top: 1px solid #e0f2fe;
            margin: 1.5rem 0;
        }

        .btn-register {
            background: linear-gradient(135deg, var(--sky), var(--sky-dark));
            border: none;
            color: white;
            font-weight: 700;
            padding: 0.65rem 2rem;
            border-radius: 8px;
            font-size: 0.95rem;
            transition: opacity 0.2s, transform 0.1s;
            letter-spacing: 0.5px;
        }

            .btn-register:hover {
                opacity: 0.9;
                transform: translateY(-1px);
                color: white;
            }

        .btn-clear {
            background: var(--sky-pale);
            border: 1.5px solid var(--sky-light);
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

            .toggle-pw .eye-off {
                display: none;
            }

            .toggle-pw.active .eye-on {
                display: none;
            }

            .toggle-pw.active .eye-off {
                display: block;
            }

        .field-error {
            color: #dc2626;
            font-size: 0.8rem;
            margin-top: 0.25rem;
            display: block;
        }

        .login-prompt {
            font-size: 0.9rem;
            color: var(--muted);
            text-align: center;
            margin-top: 1.2rem;
        }

            .login-prompt a {
                color: var(--sky-dark);
                font-weight: 600;
                text-decoration: underline;
            }

        .role-selector {
            background: var(--sky-pale);
            border-bottom: 1px solid #e0f2fe;
        }

            .role-selector input[type="radio"] {
                accent-color: var(--sky-dark);
                transform: scale(1.1);
                cursor: pointer;
            }

            .role-selector label {
                font-weight: 600;
                color: var(--sky-dark);
                margin-right: 15px;
                cursor: pointer;
            }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="register-wrap">
        <div class="register-card">

            <div class="register-card-header">
                <h4>Register as a Service Provider</h4>
                <p>Fill in your details to list your services on the platform</p>
            </div>

            <div class="role-selector text-center py-3">
                <asp:RadioButton
                    ID="rbCustomer"
                    runat="server"
                    GroupName="UserType"
                    Text=" Customer"
                    AutoPostBack="false"
                    onclick="window.location.href='Register.aspx';" />

                &nbsp;&nbsp;&nbsp;

    <asp:RadioButton
        ID="rbServiceProvider"
        runat="server"
        GroupName="UserType"
        Text=" Service Provider"
        Checked="true"
        AutoPostBack="false"
        onclick="window.location.href='RegisterServiceProvider.aspx';" />

            </div>

            <div class="register-card-body">

                <%-- ===== ACCOUNT DETAILS ===== --%>
                <p class="section-label">Account Details</p>

                <%-- Full Name --%>
                <div class="field-group">
                    <label for="txtFullName" class="form-label">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control"
                        placeholder="Enter your full name" />
                    <asp:RequiredFieldValidator ID="rfvFullName" runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Full name is required.</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revFullName" runat="server"
                        ControlToValidate="txtFullName"
                        ValidationExpression="^[a-zA-Z\s'\-]{2,100}$"
                        ErrorMessage="Full name must contain letters only (2–100 characters)."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Full name must contain letters only (2–100 characters).</asp:RegularExpressionValidator>
                </div>

                <%-- Email --%>
                <div class="field-group">
                    <label for="txtEmail" class="form-label">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                        placeholder="Enter your email address" />
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email address is required."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Email address is required.</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server"
                        ControlToValidate="txtEmail"
                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                        ErrorMessage="Please enter a valid email address."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please enter a valid email address.</asp:RegularExpressionValidator>
                </div>

                <%-- Phone --%>
                <div class="field-group">
                    <label for="txtPhone" class="form-label">Phone Number</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"
                        placeholder="Enter your phone number" />
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server"
                        ControlToValidate="txtPhone"
                        ErrorMessage="Phone number is required."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Phone number is required.</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPhone" runat="server"
                        ControlToValidate="txtPhone"
                        ValidationExpression="^[\d\s\+\-\(\)]{7,15}$"
                        ErrorMessage="Please enter a valid phone number (7–15 digits)."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please enter a valid phone number (7–15 digits).</asp:RegularExpressionValidator>
                </div>

                <div class="row">
                    <%-- Date of Birth --%>
                    <div class="col-sm-6">
                        <div class="field-group">
                            <label for="txtDOB" class="form-label">Date of Birth</label>
                            <asp:TextBox ID="txtDOB" runat="server" CssClass="form-control"
                                TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDOB" runat="server"
                                ControlToValidate="txtDOB"
                                ErrorMessage="Date of birth is required."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Date of birth is required.</asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <%-- Township --%>
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
                            <asp:RequiredFieldValidator ID="rfvTownship" runat="server"
                                ControlToValidate="ddlTownship"
                                InitialValue=""
                                ErrorMessage="Please select a township."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Please select a township.</asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>

                <%-- Password --%>
                <div class="field-group">
                    <label for="txtPassword" class="form-label">Password</label>
                    <div class="password-wrap">
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control"
                            TextMode="Password" placeholder="Choose a strong password"
                            Style="padding-right: 3rem;" />
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
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Password is required.</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ValidationExpression="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$"
                        ErrorMessage="Password must be at least 8 characters and include an uppercase letter, lowercase letter, number, and special character."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Password must be at least 8 characters and include an uppercase letter, lowercase letter, number, and special character.</asp:RegularExpressionValidator>
                </div>

                <%-- Confirm Password --%>
                <div class="field-group">
                    <label for="txtConfirmPassword" class="form-label">Confirm Password</label>
                    <div class="password-wrap">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control"
                            TextMode="Password" placeholder="Repeat your password"
                            Style="padding-right: 3rem;" />
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
                    <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your password."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please confirm your password.</asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPasswordMatch" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        Operator="Equal" Type="String"
                        ErrorMessage="Passwords do not match."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Passwords do not match.</asp:CompareValidator>
                </div>

                <hr class="divider" />

                <p class="section-label">Security</p>

                <%-- Security Question --%>
                <div class="field-group">
                    <label for="ddlSecurityQuestion" class="form-label">Security Question</label>
                    <asp:DropDownList ID="ddlSecurityQuestion" runat="server" CssClass="form-select">
                        <asp:ListItem Text="-- Select a question --" Value="" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="What is your mother's maiden name?" Value="Q1"></asp:ListItem>
                        <asp:ListItem Text="What was the name of your first pet?" Value="Q2"></asp:ListItem>
                        <asp:ListItem Text="What city were you born in?" Value="Q3"></asp:ListItem>
                        <asp:ListItem Text="What is the name of your primary school?" Value="Q4"></asp:ListItem>
                        <asp:ListItem Text="What was your childhood nickname?" Value="Q5"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvSecurityQuestion" runat="server"
                        ControlToValidate="ddlSecurityQuestion"
                        InitialValue=""
                        ErrorMessage="Please select a security question."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please select a security question.</asp:RequiredFieldValidator>
                </div>

                <%-- Security Answer --%>
                <div class="field-group">
                    <label for="txtSecurityAnswer" class="form-label">Your Answer</label>
                    <asp:TextBox ID="txtSecurityAnswer" runat="server" CssClass="form-control"
                        placeholder="Enter your answer"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSecurityAnswer" runat="server"
                        ControlToValidate="txtSecurityAnswer"
                        ErrorMessage="Please provide an answer to your security question."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Please provide an answer to your security question.</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revSecurityAnswer" runat="server"
                        ControlToValidate="txtSecurityAnswer"
                        ValidationExpression="^.{2,100}$"
                        ErrorMessage="Answer must be between 2 and 100 characters."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Answer must be between 2 and 100 characters.</asp:RegularExpressionValidator>
                </div>

                <hr class="divider" />

                <%-- ===== SERVICE PROVIDER PROFILE ===== --%>
                <p class="section-label">Service Provider Profile</p>

                <%-- Business / Display Name --%>
                <div class="field-group">
                    <label for="txtProviderName" class="form-label">Business / Display Name</label>
                    <asp:TextBox ID="txtProviderName" runat="server" CssClass="form-control"
                        placeholder="Enter your business or display name" />
                    <asp:RequiredFieldValidator ID="rfvProviderName" runat="server"
                        ControlToValidate="txtProviderName"
                        ErrorMessage="Provider name is required."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Provider name is required.</asp:RequiredFieldValidator>
                </div>

                <div class="row">
                    <%-- Category --%>
                    <div class="col-sm-6">
                        <div class="field-group">
                            <label for="ddlCategory" class="form-label">Category</label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                                <asp:ListItem Text="-- Select Category --" Value="" Selected="True" />
                                <asp:ListItem Text="Tailoring" Value="Tailoring" />
                                <asp:ListItem Text="Plumbing" Value="Plumbing" />
                                <asp:ListItem Text="Painting" Value="Painting" />
                                <asp:ListItem Text="Hairdressing" Value="Hairdressing" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCategory" runat="server"
                                ControlToValidate="ddlCategory"
                                InitialValue=""
                                ErrorMessage="Please select a category."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Please select a category.</asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <%-- Specialty --%>
                    <div class="col-sm-6">
                        <div class="field-group">
                            <label for="txtSpecialty" class="form-label">Specialty</label>
                            <asp:TextBox ID="txtSpecialty" runat="server" CssClass="form-control"
                                placeholder="e.g. Wedding dresses" />
                            <asp:RequiredFieldValidator ID="rfvSpecialty" runat="server"
                                ControlToValidate="txtSpecialty"
                                ErrorMessage="Specialty is required."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Specialty is required.</asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>

                <%-- Description --%>
                <div class="field-group">
                    <label for="txtDescription" class="form-label">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control"
                        TextMode="MultiLine" Rows="4"
                        placeholder="Describe your services and experience" />
                    <asp:RequiredFieldValidator ID="rfvDescription" runat="server"
                        ControlToValidate="txtDescription"
                        ErrorMessage="Description is required."
                        Display="Dynamic" CssClass="field-error" ForeColor="">
                    Description is required.</asp:RequiredFieldValidator>
                </div>

                <div class="row">
                    <%-- Price --%>
                    <div class="col-sm-6">
                        <div class="field-group">
                            <label for="txtPrice" class="form-label">Price (R)</label>
                            <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"
                                placeholder="e.g. 250.00" />
                            <asp:RequiredFieldValidator ID="rfvPrice" runat="server"
                                ControlToValidate="txtPrice"
                                ErrorMessage="Price is required."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Price is required.</asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="revPrice" runat="server"
                                ControlToValidate="txtPrice"
                                ValidationExpression="^\d+(\.\d{1,2})?$"
                                ErrorMessage="Enter a valid price (e.g. 250.00)."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Enter a valid price (e.g. 250.00).</asp:RegularExpressionValidator>
                        </div>
                    </div>

                    <%-- Price Unit --%>
                    <div class="col-sm-6">
                        <div class="field-group">
                            <label for="ddlPriceUnit" class="form-label">Price Unit</label>
                            <asp:DropDownList ID="ddlPriceUnit" runat="server" CssClass="form-select">
                                <asp:ListItem Text="per hour" Value="per hour" />
                                <asp:ListItem Text="per session" Value="per session" />
                                <asp:ListItem Text="per day" Value="per day" />
                                <asp:ListItem Text="per month" Value="per month" />
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <%-- Location --%>
                    <div class="col-sm-6">
                        <div class="field-group">
                            <label for="txtLocation" class="form-label">Location</label>
                            <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control"
                                placeholder="e.g. East London" />
                            <asp:RequiredFieldValidator ID="rfvLocation" runat="server"
                                ControlToValidate="txtLocation"
                                ErrorMessage="Location is required."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Location is required.</asp:RequiredFieldValidator>
                        </div>
                    </div>

                    <%-- Years of Experience --%>
                    <div class="col-sm-6">
                        <div class="field-group">
                            <label for="txtYearsExperience" class="form-label">Years of Experience</label>
                            <asp:TextBox ID="txtYearsExperience" runat="server" CssClass="form-control"
                                placeholder="e.g. 5" />
                            <asp:RequiredFieldValidator ID="rfvYearsExperience" runat="server"
                                ControlToValidate="txtYearsExperience"
                                ErrorMessage="Years of experience is required."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Years of experience is required.</asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="rvYearsExperience" runat="server"
                                ControlToValidate="txtYearsExperience"
                                MinimumValue="0" MaximumValue="50" Type="Integer"
                                ErrorMessage="Enter a valid number of years (0–50)."
                                Display="Dynamic" CssClass="field-error" ForeColor="">
                            Enter a valid number of years (0–50).</asp:RangeValidator>
                        </div>
                    </div>
                </div>

                <hr class="divider" />

                <%-- Buttons --%>
                <div class="d-flex gap-2 mt-3">
                    <asp:Button ID="btnRegister" runat="server" Text="Create Account"
                        CssClass="btn btn-register"
                        OnClick="btnRegister_Click" />
                    <asp:Button ID="btnClear" runat="server" Text="Clear"
                        CssClass="btn btn-clear"
                        CausesValidation="False"
                        OnClick="btnClear_Click" />
                    <asp:Button ID="btnCancel" runat="server" Text="Cancel"
                        CssClass="btn btn-clear"
                        CausesValidation="False"
                        OnClick="btnCancel_Click" />
                </div>

                <div class="mt-3">
                    <asp:Label ID="lblMessage" runat="server" />
                </div>

                <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                    HeaderText="Please fix the following:"
                    ShowMessageBox="False"
                    ShowSummary="True"
                    ForeColor="Red"
                    CssClass="mt-3 alert alert-danger"
                    DisplayMode="BulletList" />

                <hr class="divider" />

                <p class="login-prompt">
                    Already have an account? <a href="Login.aspx">Sign in here</a>
                </p>

            </div>
        </div>
    </div>

    <script>
        function togglePassword(field, btn) {
            var input = field === 'pw'
                ? document.getElementById('<%= txtPassword.ClientID %>')
                : document.getElementById('<%= txtConfirmPassword.ClientID %>');

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
