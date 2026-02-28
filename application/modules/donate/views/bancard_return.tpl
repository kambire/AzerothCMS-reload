<div class="row justify-content-center mt-5">
    <div class="col-lg-6 text-center">
        <div class="card border-0 shadow" style="background:linear-gradient(135deg,#001a6e,#0038a8);border-radius:20px;">
            <div class="card-body p-5">
                <div class="mb-4">
                    <div class="spinner-border text-light mb-3" role="status" id="checking-spinner"></div>
                    <i class="fa-solid fa-circle-check fa-4x text-success" id="check-icon" style="display:none;"></i>
                </div>
                <h3 class="text-white fw-bold mb-2">Processing Payment…</h3>
                <p class="text-white-50 mb-4" id="status-msg">
                    Please wait while we confirm your payment with Bancard.<br>
                    This usually takes a few seconds.
                </p>
                <div class="d-flex gap-3 justify-content-center">
                    <a href="{$url}ucp" class="btn btn-outline-light">
                        <i class="fa-solid fa-user me-2"></i>Go to Account
                    </a>
                    <a href="{$url}donate" class="btn btn-secondary">
                        <i class="fa-solid fa-arrow-left me-2"></i>Back to Donate
                    </a>
                </div>
                <p class="text-white-50 mt-4" style="font-size:12px;">
                    If your payment was successful, your Donation Points will appear in your account within a few minutes.
                    If you don't receive them, please contact support with your payment reference.
                </p>
            </div>
        </div>
    </div>
</div>

<script>
// Simulate a status check — in production you could poll an endpoint
setTimeout(function () {
    document.getElementById('checking-spinner').style.display = 'none';
    document.getElementById('check-icon').style.display = 'inline-block';
    document.getElementById('status-msg').textContent = 'Thank you! Your payment has been received and will be credited shortly.';
}, 3000);
</script>
