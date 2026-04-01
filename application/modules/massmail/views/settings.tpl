<section class="card">
    <header class="card-header">
        <h2 class="card-title">Mass Mail Global Settings</h2>
    </header>
    <div class="card-body">
        <form action="{$url}massmail/admin/save_settings" method="post">
            <div class="row mb-4">
                <label class="col-sm-3 col-form-label">Default Emails per Hour</label>
                <div class="col-sm-9">
                    <input type="number" name="default_emails_per_hour" class="form-control bg-dark text-white border-secondary" value="{$default_emails_per_hour}" min="1">
                    <small class="text-muted">Set the default speed for new campaigns. Recommended: 50-100 to avoid SPAM filters.</small>
                </div>
            </div>

            <div class="row mb-4">
                <label class="col-sm-3 col-form-label">Default Sender Name</label>
                <div class="col-sm-9">
                    <input type="text" name="sender_name" class="form-control bg-dark text-white border-secondary" value="{$sender_name}">
                    <small class="text-muted">The name that will appear in the "From" field (e.g., WOWEspy Team).</small>
                </div>
            </div>

            <hr class="my-4 border-secondary">
            <h4 class="mb-4 text-primary"><i class="fa fa-server me-2"></i> Dedicated SMTP Configuration</h4>
            <p class="text-muted small mb-4">These settings will override the global CMS SMTP configuration for all massmail campaigns.</p>

            <div class="row mb-3">
                <label class="col-sm-3 col-form-label">SMTP Host</label>
                <div class="col-sm-9">
                    <input type="text" name="massmail_smtp_host" class="form-control bg-dark text-white border-secondary" value="{$massmail_smtp_host}" placeholder="mail.example.com">
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-form-label">SMTP User</label>
                <div class="col-sm-9">
                    <input type="text" name="massmail_smtp_user" class="form-control bg-dark text-white border-secondary" value="{$massmail_smtp_user}" placeholder="user@example.com">
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-form-label">SMTP Password</label>
                <div class="col-sm-9">
                    <input type="password" name="massmail_smtp_pass" class="form-control bg-dark text-white border-secondary" value="{$massmail_smtp_pass}">
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-3 col-form-label">SMTP Port</label>
                <div class="col-sm-9">
                    <input type="number" name="massmail_smtp_port" class="form-control bg-dark text-white border-secondary" value="{$massmail_smtp_port}" placeholder="465">
                </div>
            </div>

            <div class="row mb-4">
                <label class="col-sm-3 col-form-label">SMTP Encryption</label>
                <div class="col-sm-9">
                    <select name="massmail_smtp_crypto" class="form-control bg-dark text-white border-secondary">
                        <option value="ssl" {if $massmail_smtp_crypto == 'ssl'}selected{/if}>SSL (Port 465)</option>
                        <option value="tls" {if $massmail_smtp_crypto == 'tls'}selected{/if}>TLS (Port 587)</option>
                        <option value="" {if $massmail_smtp_crypto == ''}selected{/if}>None (Port 25)</option>
                    </select>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-9 offset-sm-3">
                    <button type="submit" class="btn btn-primary px-4"><i class="fa fa-save me-1"></i> Save Configuration</button>
                    <button type="button" id="test_smtp_btn" class="btn btn-success px-4" onclick="Massmail.testSmtp()"><i class="fa fa-plug me-1"></i> Test Connection</button>
                    <a href="{$url}massmail/admin" class="btn btn-default">Back to Campaigns</a>
                </div>
            </div>
        </form>
    </div>
</section>
