<div class="row justify-content-center mt-4">
    <div class="col-lg-7">
        <div class="card border-0 shadow" style="background:#1a1d27; border-radius:18px; overflow:hidden;">

            {* Header *}
            <div class="card-header border-0 d-flex align-items-center gap-3 p-4"
                 style="background:linear-gradient(90deg,#001a6e,#0038a8);">
                <img src="https://www.bancard.com.py/wp-content/uploads/2022/03/logo-bancard.svg"
                     alt="Bancard" height="28" onerror="this.style.display='none'">
                <div>
                    <h6 class="text-white mb-0 fw-bold">Secure Payment — Bancard vPOS</h6>
                    <small class="text-white-50">Complete your payment in the secure form below</small>
                </div>
            </div>

            {* Iframe container *}
            <div class="card-body p-0">
                <div id="bancard-loading" class="text-center py-5">
                    <div class="spinner-border text-primary mb-3" role="status"></div>
                    <p class="text-muted">Loading payment form…</p>
                </div>
                <iframe id="bancard-iframe"
                        src="{$iframe_url}"
                        style="width:100%; min-height:550px; border:none; display:none;"
                        onload="document.getElementById('bancard-loading').style.display='none';this.style.display='block';"
                        allow="payment"
                        sandbox="allow-forms allow-popups allow-scripts allow-same-origin allow-top-navigation">
                </iframe>
            </div>

            <div class="card-footer border-0 text-center py-3" style="background:#111320;">
                <small class="text-muted">
                    <i class="fa-solid fa-lock me-1 text-success"></i>
                    Your payment is secured by <strong class="text-white">Bancard</strong> — Paraguay's leading card network.
                    &nbsp;|&nbsp; <a href="{$url}donate" class="text-secondary">Cancel and go back</a>
                </small>
            </div>
        </div>
    </div>
</div>
