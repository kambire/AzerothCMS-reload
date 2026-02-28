<div class="row justify-content-center mt-4">
    <div class="col-lg-8">

        {* === BANK DETAILS CARD (from admin config) === *}
        {if isset($config) && count($config) > 0}
        <div class="card mb-4 border-0 shadow" style="background: linear-gradient(135deg,#0f3460,#16213e); border-radius:16px;">
            <div class="card-body p-4">
                <div class="d-flex align-items-center gap-3 mb-4">
                    <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:52px;height:52px;background:rgba(32,201,151,0.2);">
                        <i class="fa-solid fa-building-columns fa-xl" style="color:#20c997;"></i>
                    </div>
                    <div>
                        <h5 class="text-white mb-0 fw-bold">Payment Details</h5>
                        <small class="text-muted">Transfer the exact amount to the details below, then fill the form.</small>
                    </div>
                </div>

                <div class="row g-3">
                    {if isset($config.beneficiary) && $config.beneficiary}
                    <div class="col-sm-6">
                        <div class="p-3 rounded" style="background:rgba(255,255,255,0.06);">
                            <div class="text-muted mb-1" style="font-size:11px;text-transform:uppercase;letter-spacing:1px;">Account Holder</div>
                            <div class="text-white fw-semibold">{$config.beneficiary}</div>
                        </div>
                    </div>
                    {/if}
                    {if isset($config.bank_name) && $config.bank_name}
                    <div class="col-sm-6">
                        <div class="p-3 rounded" style="background:rgba(255,255,255,0.06);">
                            <div class="text-muted mb-1" style="font-size:11px;text-transform:uppercase;letter-spacing:1px;">Bank</div>
                            <div class="text-white fw-semibold">{$config.bank_name}</div>
                        </div>
                    </div>
                    {/if}
                    {if isset($config.account_number) && $config.account_number}
                    <div class="col-sm-8">
                        <div class="p-3 rounded d-flex justify-content-between align-items-center" style="background:rgba(255,255,255,0.06);">
                            <div>
                                <div class="text-muted mb-1" style="font-size:11px;text-transform:uppercase;letter-spacing:1px;">Account Number / CBU</div>
                                <div class="text-white fw-semibold font-monospace" id="accountNum">{$config.account_number}</div>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-secondary ms-3" onclick="navigator.clipboard.writeText('{$config.account_number}');this.innerHTML='<i class=\'fa-solid fa-check\'></i>';setTimeout(()=>this.innerHTML='<i class=\'fa-regular fa-copy\'></i>',1500);">
                                <i class="fa-regular fa-copy"></i>
                            </button>
                        </div>
                    </div>
                    {/if}
                    {if isset($config.account_type) && $config.account_type}
                    <div class="col-sm-4">
                        <div class="p-3 rounded" style="background:rgba(255,255,255,0.06);">
                            <div class="text-muted mb-1" style="font-size:11px;text-transform:uppercase;letter-spacing:1px;">Type</div>
                            <div class="text-white fw-semibold">{$config.account_type}</div>
                        </div>
                    </div>
                    {/if}
                    {if isset($config.pix_key) && $config.pix_key}
                    <div class="col-sm-8">
                        <div class="p-3 rounded d-flex justify-content-between align-items-center" style="background:rgba(32,201,151,0.1);border:1px solid rgba(32,201,151,0.3);">
                            <div>
                                <div class="mb-1" style="font-size:11px;text-transform:uppercase;letter-spacing:1px;color:#20c997;">PIX Key</div>
                                <div class="text-white fw-semibold font-monospace">{$config.pix_key}</div>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-success ms-3" onclick="navigator.clipboard.writeText('{$config.pix_key}');this.innerHTML='<i class=\'fa-solid fa-check\'></i>';setTimeout(()=>this.innerHTML='<i class=\'fa-regular fa-copy\'></i>',1500);">
                                <i class="fa-regular fa-copy"></i>
                            </button>
                        </div>
                    </div>
                    {/if}
                    {if isset($config.currency) && $config.currency}
                    <div class="col-sm-4">
                        <div class="p-3 rounded" style="background:rgba(255,255,255,0.06);">
                            <div class="text-muted mb-1" style="font-size:11px;text-transform:uppercase;letter-spacing:1px;">Currency</div>
                            <div class="text-white fw-semibold">{$config.currency}</div>
                        </div>
                    </div>
                    {/if}
                </div>

                {if isset($config.instructions) && $config.instructions}
                <div class="mt-3 p-3 rounded" style="background:rgba(255,193,7,0.1);border-left:4px solid #ffc107;">
                    <i class="fa-solid fa-circle-info text-warning me-2"></i>
                    <span class="text-warning-emphasis">{$config.instructions}</span>
                </div>
                {/if}
            </div>
        </div>
        {else}
        <div class="alert alert-warning mb-4">
            <i class="fa-solid fa-triangle-exclamation me-2"></i>
            Bank transfer details are not configured yet. Please contact an administrator.
        </div>
        {/if}

        {* === SUBMISSION FORM === *}
        <div class="card border-0 shadow" style="background:#1a1d27;border-radius:16px;">
            <div class="card-body p-4">
                <h6 class="text-white fw-bold mb-1"><i class="fa-solid fa-paper-plane me-2 text-primary"></i>Notify the Admin</h6>
                <p class="text-muted mb-4" style="font-size:13px;">After sending your payment, fill in the details below so we can verify and credit your account.</p>

                <form action="{$url}donate/offline" method="POST">

                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Payment Method Used</label>
                        <select name="method" class="form-select bg-dark text-white border-secondary" required>
                            <option value="">-- Select the method you used --</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                            <option value="PIX">PIX</option>
                            <option value="Western Union">Western Union</option>
                            <option value="MercadoPago">MercadoPago (Manual)</option>
                            <option value="Crypto">Crypto</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Amount Sent</label>
                            <div class="input-group">
                                <span class="input-group-text bg-dark text-muted border-secondary">{if isset($config.currency)}{$config.currency}{else}${/if}</span>
                                <input type="number" step="0.01" min="1" class="form-control bg-dark text-white border-secondary" name="amount" placeholder="0.00" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">DP Points Expected</label>
                            <div class="input-group">
                                <span class="input-group-text bg-dark text-muted border-secondary"><i class="fa-solid fa-gem"></i></span>
                                <input type="number" min="1" class="form-control bg-dark text-white border-secondary" name="points" placeholder="e.g. 150" required>
                            </div>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Transaction / Reference ID</label>
                        <input type="text" class="form-control bg-dark text-white border-secondary font-monospace" name="reference" placeholder="Paste the transaction ID or receipt code here" required>
                        <div class="form-text text-muted">This is provided by your bank or transfer app after the payment is sent.</div>
                    </div>

                    <button type="submit" class="nice_button w-100" style="border-radius:10px;">
                        <i class="fa-solid fa-check-circle me-2"></i>Submit Request
                    </button>
                </form>
            </div>
        </div>

    </div>
</div>
