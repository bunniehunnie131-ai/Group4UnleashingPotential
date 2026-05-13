<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="Unleashing_Potential.WebForm9" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root {
        --sky:#0ea5e9; --sky-dark:#0369a1;
        --sky-deeper:#0c4a6e; --sky-light:#bae6fd;
        --sky-pale:#f0f9ff; --muted:#64748b;
    }
    .page-wrap { max-width:820px; margin:0 auto; }
    .checkout-wizard { background:#fff; border-radius:16px; box-shadow:0 4px 24px rgba(12,74,110,0.09); overflow:hidden; }
    /* Wizard header */
    .checkout-wizard .wizard-step-title {
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        color:#fff; font-family:'Lora',serif; font-size:1.1rem; padding:1rem 1.5rem;
    }
    /* Sidebar */
    table.wizard-sidebar td { background:var(--sky-pale)!important; }
    .form-group { margin-bottom:1.2rem; }
    .form-label { font-size:0.84rem; font-weight:600; color:#374151; display:block; margin-bottom:0.4rem; }
    .form-input {
        width:100%; border:1.5px solid #e2e8f0; border-radius:9px;
        padding:0.6rem 0.9rem; font-size:0.9rem;
        transition:border-color 0.2s; outline:none;
    }
    .form-input:focus { border-color:var(--sky); }
    .form-textarea {
        width:100%; border:1.5px solid #e2e8f0; border-radius:9px;
        padding:0.6rem 0.9rem; font-size:0.9rem; resize:vertical; min-height:90px;
    }
    .payment-option {
        border:2px solid #e2e8f0; border-radius:12px; padding:1rem 1.3rem;
        cursor:pointer; transition:all 0.2s; margin-bottom:0.8rem;
        display:flex; align-items:flex-start; gap:0.8rem;
    }
    .payment-option:hover { border-color:var(--sky); background:var(--sky-pale); }
    .payment-option.selected { border-color:var(--sky-dark); background:var(--sky-pale); }
    .pay-icon { font-size:1.6rem; }
    .pay-title { font-weight:600; color:var(--sky-deeper); font-size:0.92rem; }
    .pay-desc  { font-size:0.8rem; color:var(--muted); margin-top:0.2rem; }
    .amount-option {
        border:2px solid #e2e8f0; border-radius:10px; padding:0.9rem 1.2rem;
        cursor:pointer; transition:all 0.2s; margin-bottom:0.7rem;
    }
    .amount-option:hover { border-color:var(--sky); }
    .amount-selected { border-color:var(--sky-dark)!important; background:var(--sky-pale); }
    .order-summary-row { display:flex; justify-content:space-between; padding:0.5rem 0; font-size:0.88rem; color:#374151; border-bottom:1px solid #f1f5f9; }
    .order-summary-total { display:flex; justify-content:space-between; padding:0.8rem 0 0; font-size:1.05rem; font-weight:700; color:var(--sky-deeper); }
    .step-content { padding:1.5rem 2rem; }
    .err { color:#dc2626; font-size:0.8rem; margin-top:0.3rem; }
    .info-badge {
        background:var(--sky-pale); border:1px solid var(--sky-light);
        border-radius:8px; padding:0.7rem 1rem; font-size:0.84rem; color:var(--sky-darker,var(--sky-dark));
        margin:0.8rem 0;
    }
</style>
<script>
    function selectPayment(method) {
        document.querySelectorAll('.payment-option').forEach(function(el) {
            el.classList.remove('selected');
        });
        document.getElementById('pay_' + method).classList.add('selected');
        document.getElementById('ctl00_MainContent_rblPayment').querySelectorAll('input').forEach(function(r) {
            if (r.value === method) r.checked = true;
        });
        document.getElementById('eftPanel').style.display = method === 'EFT' ? 'block' : 'none';
    }

    function selectAmount(type) {
        document.querySelectorAll('.amount-option').forEach(function(el) {
            el.classList.remove('amount-selected');
        });
        document.getElementById('amt_' + type).classList.add('amount-selected');
        document.querySelectorAll('input[name*="rblAmount"]').forEach(function(r) {
            if (r.value === type) r.checked = true;
        });
    }
</script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrap">

    <asp:Wizard ID="wzCheckout" runat="server"
        DisplaySideBar="true"
        OnFinishButtonClick="wzCheckout_FinishButtonClick"
        OnNextButtonClick="wzCheckout_NextButtonClick"
        CssClass="checkout-wizard">

        <WizardSteps>

           
            <asp:WizardStep ID="step1" runat="server" Title="Your Details">
                <div class="step-content">
                    <h5 style="font-family:'Lora',serif;color:var(--sky-deeper);margin-bottom:1.2rem;">Contact & Booking Details</h5>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Full Name *</label>
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="Your full name" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtName"
                                    ErrorMessage="Full name is required." CssClass="err"
                                    ValidationGroup="Step1" Display="Dynamic" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label class="form-label">Phone Number *</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-input" placeholder="e.g. 071 234 5678" />
                                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtPhone"
                                    ErrorMessage="Phone number is required." CssClass="err"
                                    ValidationGroup="Step1" Display="Dynamic" />
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Service Address *</label>
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-input"
                            placeholder="Where should the provider come?" />
                        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtAddress"
                            ErrorMessage="Address is required." CssClass="err"
                            ValidationGroup="Step1" Display="Dynamic" />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Preferred Appointment Date *</label>
                        <asp:Calendar ID="calAppointment" runat="server"
                            SelectionMode="Day"
                            OnDayRender="calAppointment_DayRender">
                            <SelectedDayStyle BackColor="#0369a1" ForeColor="White" />
                            <TodayDayStyle BackColor="#bae6fd" ForeColor="#0c4a6e" />
                        </asp:Calendar>
                        <asp:Label ID="lblDateError" runat="server"
                            Text="Please select an appointment date." CssClass="err" Visible="false" />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Additional Notes</label>
                        <asp:TextBox ID="txtNotes" runat="server" CssClass="form-textarea"
                            TextMode="MultiLine" placeholder="Any special instructions or requirements..." />
                    </div>
                </div>
            </asp:WizardStep>

            <asp:WizardStep ID="step2" runat="server" Title="Payment Method">
                <div class="step-content">
                    <h5 style="font-family:'Lora',serif;color:var(--sky-deeper);margin-bottom:1.2rem;">Select Payment Method</h5>

                    
                    <asp:RadioButtonList ID="rblPayment" runat="server" style="display:none;">
                        <asp:ListItem Value="PayOnCompletion">Pay on Completion</asp:ListItem>
                        <asp:ListItem Value="EFT">EFT Proof Upload</asp:ListItem>
                    </asp:RadioButtonList>

                    <div id="pay_PayOnCompletion" class="payment-option selected" onclick="selectPayment('PayOnCompletion')">
                        <div class="pay-icon">💵</div>
                        <div>
                            <div class="pay-title">Pay on Completion</div>
                            <div class="pay-desc">Pay the service provider directly after the work is done. Full payment due upon completion.</div>
                        </div>
                    </div>

                    <div id="pay_EFT" class="payment-option" onclick="selectPayment('EFT')">
                        <div class="pay-icon">🏦</div>
                        <div>
                            <div class="pay-title">EFT Proof Upload</div>
                            <div class="pay-desc">Pay via Electronic Funds Transfer and upload your proof of payment to confirm the booking.</div>
                        </div>
                    </div>

                    <div id="eftPanel" style="display:none; margin-top:1rem;">
                        <div class="info-badge">
                            <strong>EFT Banking Details:</strong><br/>
                            Bank: FNB &nbsp;|&nbsp; Account: 62012345678 &nbsp;|&nbsp;
                            Branch: 250655 &nbsp;|&nbsp; Ref: Your Name
                        </div>
                        <div class="form-group" style="margin-top:0.8rem;">
                            <label class="form-label">Upload Proof of Payment</label>
                            <asp:FileUpload ID="fuEFT" runat="server" CssClass="form-input" />
                        </div>
                    </div>

                    <asp:Label ID="lblPaymentError" runat="server"
                        Text="Please select a payment method." CssClass="err" Visible="false" />

                    <div style="margin-top:1.5rem;">
                        <h5 style="font-family:'Lora',serif;color:var(--sky-deeper);margin-bottom:0.8rem;">Payment Amount</h5>

                        <asp:RadioButtonList ID="rblAmount" runat="server" style="display:none;">
                            <asp:ListItem Value="Deposit">50% Deposit</asp:ListItem>
                            <asp:ListItem Value="Full">Full Amount</asp:ListItem>
                        </asp:RadioButtonList>

                        <div id="amt_Deposit" class="amount-option amount-selected" onclick="selectAmount('Deposit')">
                            <div style="display:flex;justify-content:space-between;align-items:center;">
                                <div>
                                    <div style="font-weight:600;color:var(--sky-deeper);">Pay 50% Deposit</div>
                                    <div style="font-size:0.8rem;color:var(--muted);">Pay half now to confirm your booking. Balance due on the day.</div>
                                </div>
                                <div style="font-size:1.1rem;font-weight:700;color:var(--sky-dark);">
                                    R<asp:Label ID="lblDepositAmt" runat="server" />
                                </div>
                            </div>
                        </div>

                        <div id="amt_Full" class="amount-option" onclick="selectAmount('Full')">
                            <div style="display:flex;justify-content:space-between;align-items:center;">
                                <div>
                                    <div style="font-weight:600;color:var(--sky-deeper);">Pay Full Amount</div>
                                    <div style="font-size:0.8rem;color:var(--muted);">Pay the complete amount upfront and get priority booking.</div>
                                </div>
                                <div style="font-size:1.1rem;font-weight:700;color:var(--sky-dark);">
                                    R<asp:Label ID="lblFullAmt" runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </asp:WizardStep>

            
            <asp:WizardStep ID="step3" runat="server" Title="Confirm Booking" StepType="Finish">
                <div class="step-content">
                    <h5 style="font-family:'Lora',serif;color:var(--sky-deeper);margin-bottom:1.2rem;">Confirm Your Booking</h5>

                    <div style="background:var(--sky-pale);border-radius:12px;padding:1.2rem 1.5rem;margin-bottom:1.2rem;">
                        <div style="font-size:0.8rem;font-weight:700;color:var(--sky-dark);text-transform:uppercase;margin-bottom:0.6rem;">Booking Details</div>
                        <asp:Label ID="lblConfirmDetails" runat="server" />
                    </div>

                    <div style="background:#fff;border:1.5px solid var(--sky-light);border-radius:12px;padding:1.2rem 1.5rem;margin-bottom:1.2rem;">
                        <div style="font-size:0.8rem;font-weight:700;color:var(--sky-dark);text-transform:uppercase;margin-bottom:0.6rem;">Services Booked</div>
                        <asp:Repeater ID="rptConfirmItems" runat="server">
                            <ItemTemplate>
                                <div class="order-summary-row">
                                    <span><%# Eval("ProviderName") %> — <%# Eval("Service") %></span>
                                    <span>R<%# String.Format("{0:0.00}", Eval("LineTotal")) %></span>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <div class="order-summary-total">
                            <span>Total</span>
                            <span>R<asp:Label ID="lblConfirmTotal" runat="server" /></span>
                        </div>
                        <div style="display:flex;justify-content:space-between;padding:0.4rem 0;font-size:0.9rem;color:#166534;font-weight:600;">
                            <span>Amount to Pay Now</span>
                            <span>R<asp:Label ID="lblConfirmPayNow" runat="server" /></span>
                        </div>
                    </div>

                    <div class="info-badge">
                        ℹ️ By confirming, you agree to the service terms. Your booking status will be set to <strong>Pending</strong> until accepted by the provider.
                    </div>
                </div>
            </asp:WizardStep>

        </WizardSteps>

        <NavigationButtonStyle CssClass="btn-checkout" />

    </asp:Wizard>

</div>
</asp:Content>