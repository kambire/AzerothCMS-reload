<div class="row justify-content-center">
    <div class="col-lg-8 text-center">
        <h2>Offline Payment Request</h2>
        <p class="text-muted">Use this form to notify administrators about a manual payment (e.g., Western Union, Bank Transfer, PIX). Your DP will be credited once verified.</p>
    </div>
</div>

<div class="row justify-content-center mt-4">
    <div class="col-lg-6">
        <div class="card bg-dark text-white border-secondary shadow">
            <div class="card-body p-4">
                <form action="{$url}donate/offline" method="POST">
                    
                    <div class="mb-3">
                        <label for="method" class="form-label text-light">Payment Method</label>
                        <select name="method" id="method" class="form-select bg-dark text-white" required>
                            <option value="">-- Select a method --</option>
                            <option value="Western Union">Western Union</option>
                            <option value="Bank Transfer">Bank Transfer</option>
                            <option value="Crypto">Crypto</option>
                            <option value="PIX">PIX</option>
                            <option value="MercadoPago">MercadoPago (Manual)</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="amount" class="form-label text-light">Amount Sent (USD)</label>
                            <input type="number" step="0.01" min="1" class="form-control bg-dark text-white" name="amount" id="amount" placeholder="e.g 15.00" required>
                        </div>
                        <div class="col-md-6">
                            <label for="points" class="form-label text-light">DP Expected</label>
                            <input type="number" min="1" class="form-control bg-dark text-white" name="points" id="points" placeholder="e.g 150" required>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="reference" class="form-label text-light">Reference Code / Transaction ID</label>
                        <input type="text" class="form-control bg-dark text-white" name="reference" id="reference" placeholder="Enter the receipt/transaction code" required>
                    </div>

                    <button type="submit" class="nice_button w-100">Submit Request</button>
                </form>
            </div>
        </div>
    </div>
</div>
