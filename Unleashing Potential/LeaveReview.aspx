<%@ Page Title="Leave a Review" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LeaveReview.aspx.cs" Inherits="Unleashing_Potential.WebForm12" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
<style>
    :root { --sky:#0ea5e9; --sky-dark:#0369a1; --sky-deeper:#0c4a6e; --sky-light:#bae6fd; --sky-pale:#f0f9ff; --muted:#64748b; }
    .page-wrap { max-width:640px; margin:0 auto; }
    .page-header {
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        border-radius:16px; padding:1.6rem 2rem; margin-bottom:1.5rem;
    }
    .page-header h2 { font-family:'Lora',serif; color:#f0f9ff; font-size:1.6rem; margin:0; }
    .review-card { background:#fff; border-radius:16px; box-shadow:0 4px 18px rgba(12,74,110,0.07); padding:2rem; }
    .provider-chip {
        background:var(--sky-pale); border:1px solid var(--sky-light);
        border-radius:10px; padding:0.8rem 1.2rem; margin-bottom:1.5rem;
        display:flex; align-items:center; gap:0.8rem;
    }
    .chip-avatar {
        width:44px; height:44px; border-radius:50%;
        background:linear-gradient(135deg,var(--sky-dark),var(--sky-deeper));
        display:flex; align-items:center; justify-content:center;
        font-size:1rem; font-weight:700; color:#fff; flex-shrink:0;
    }
    .chip-name    { font-weight:600; color:var(--sky-deeper); font-size:0.92rem; }
    .chip-service { font-size:0.8rem; color:var(--muted); }
    .form-group { margin-bottom:1.3rem; }
    .form-label { font-size:0.85rem; font-weight:600; color:#374151; display:block; margin-bottom:0.5rem; }
    .star-rating { display:flex; gap:0.5rem; margin-bottom:0.3rem; }
    .star-btn {
        appearance:none;
        -webkit-appearance:none;
        font-size:2rem; cursor:pointer; background:none; border:none;
        color:#e2e8f0; transition:color 0.15s, transform 0.1s; padding:0;
        line-height:1;
    }
    .star-btn:hover, .star-btn.active { color:#f59e0b; transform:scale(1.15); }
    .star-btn:focus { outline:none; }
    .star-btn:focus-visible {
        outline:2px solid var(--sky);
        outline-offset:3px;
        border-radius:6px;
    }
    .rating-label { font-size:0.8rem; color:var(--muted); margin-top:0.3rem; }
    .form-textarea {
        width:100%; border:1.5px solid #e2e8f0; border-radius:10px;
        padding:0.75rem 1rem; font-size:0.9rem; resize:vertical; min-height:110px;
        transition:border-color 0.2s; outline:none;
    }
    .form-textarea:focus { border-color:var(--sky); }
    .btn-submit {
        background:linear-gradient(135deg,var(--sky),var(--sky-dark));
        border:none; color:#fff; border-radius:10px;
        padding:0.85rem 2rem; font-size:0.95rem; font-weight:600;
        cursor:pointer; transition:opacity 0.2s; width:100%;
    }
    .btn-submit:hover { opacity:0.88; }
    .err { color:#dc2626; font-size:0.8rem; display:block; margin-top:0.3rem; }
    .success-box {
        background:#f0fdf4; border:1.5px solid #86efac; border-radius:12px;
        padding:2rem; text-align:center;
    }
</style>
<script type="text/javascript">
    (function () {
        var ratingFieldId = '<%= hdnRating.ClientID %>';
        var labels = ['', 'Poor', 'Fair', 'Good', 'Very Good', 'Excellent'];

        function getRatingField() {
            return document.getElementById(ratingFieldId);
        }

        function setStarState(val) {
            var stars = document.querySelectorAll('.star-btn');
            for (var i = 0; i < stars.length; i++) {
                var isActive = i < val;
                if (isActive) {
                    stars[i].classList.add('active');
                } else {
                    stars[i].classList.remove('active');
                }
                stars[i].setAttribute('aria-pressed', isActive ? 'true' : 'false');
            }

            var label = document.getElementById('ratingLabel');
            if (label) {
                label.innerText = labels[val] || 'Click a star to rate';
            }
        }

        window.setRating = function (val) {
            var field = getRatingField();
            if (field) {
                field.value = String(val);
            }
            setStarState(val);
        };

        document.addEventListener('DOMContentLoaded', function () {
            var field = getRatingField();
            var current = field ? parseInt(field.value || '0', 10) : 0;
            setStarState(isNaN(current) ? 0 : current);
        });
    })();
</script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
<div class="page-wrap">

    <div class="page-header">
        <h2>⭐ Leave a Review</h2>
    </div>

    <asp:Panel ID="pnlForm" runat="server">
        <div class="review-card">

            <asp:Repeater ID="rptProviderChips" runat="server">
                <ItemTemplate>
                    <div class="provider-chip">
                        <div class="chip-avatar"><%# GetInitials(Eval("ProviderName").ToString()) %></div>
                        <div>
                            <div class="chip-name"><%# Eval("ProviderName") %></div>
                            <div class="chip-service"><%# Eval("Service") %> · <%# Eval("Category") %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="form-group">
                <label class="form-label">Your Rating *</label>
                <div class="star-rating">
                    <button type="button" class="star-btn" aria-label="Rate 1 star" aria-pressed="false" onclick="setRating(1)">★</button>
                    <button type="button" class="star-btn" aria-label="Rate 2 stars" aria-pressed="false" onclick="setRating(2)">★</button>
                    <button type="button" class="star-btn" aria-label="Rate 3 stars" aria-pressed="false" onclick="setRating(3)">★</button>
                    <button type="button" class="star-btn" aria-label="Rate 4 stars" aria-pressed="false" onclick="setRating(4)">★</button>
                    <button type="button" class="star-btn" aria-label="Rate 5 stars" aria-pressed="false" onclick="setRating(5)">★</button>
                </div>
                <div class="rating-label" id="ratingLabel">Click a star to rate</div>
                <asp:HiddenField ID="hdnRating" runat="server" Value="0" />
                <asp:Label ID="lblRatingErr" runat="server" CssClass="err" Visible="false"
                    Text="Please select a rating." />
            </div>

            <div class="form-group">
                <label class="form-label">Your Review *</label>
                <asp:TextBox ID="txtComment" runat="server" CssClass="form-textarea"
                    TextMode="MultiLine"
                    placeholder="Share your experience with this service provider..." />
                <asp:RequiredFieldValidator runat="server" ControlToValidate="txtComment"
                    ErrorMessage="Please write a review." CssClass="err"
                    Display="Dynamic" ValidationGroup="ReviewGroup" />
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Submit Review"
                CssClass="btn-submit" ValidationGroup="ReviewGroup"
                OnClick="btnSubmit_Click" />

        </div>
    </asp:Panel>

    <asp:Panel ID="pnlSuccess" runat="server" Visible="false">
        <div class="review-card">
            <div class="success-box">
                <div style="font-size:3rem;margin-bottom:0.5rem;">🎉</div>
                <h4 style="font-family:'Lora',serif;color:#166534;">Thank You!</h4>
                <p style="color:#374151;margin:0.5rem 0 1.5rem;">Your review has been submitted successfully.</p>
                <a href="BookingStatus.aspx"
                    style="background:linear-gradient(135deg,var(--sky),var(--sky-dark));color:#fff;border-radius:10px;padding:0.7rem 1.5rem;font-size:0.9rem;font-weight:600;text-decoration:none;">
                    Back to My Bookings
                </a>
            </div>
        </div>
    </asp:Panel>

</div>
</asp:Content>
