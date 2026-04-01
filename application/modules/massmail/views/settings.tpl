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

            <div class="row">
                <div class="col-sm-9 offset-sm-3">
                    <button type="submit" class="btn btn-primary px-4"><i class="fa fa-save me-1"></i> Save Configuration</button>
                    <a href="{$url}massmail/admin" class="btn btn-default">Back to Campaigns</a>
                </div>
            </div>
        </form>
    </div>
</section>
