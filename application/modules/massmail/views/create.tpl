<section class="card">
    <header class="card-header">
        <h2 class="card-title">New Campaign</h2>
    </header>
    <div class="card-body">
        <form action="{$url}massmail/admin/submit" method="post" id="create_campaign_form">
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label">Subject</label>
                <div class="col-sm-10">
                    <input type="text" name="subject" class="form-control" required placeholder="Mass Mail Subject">
                </div>
            </div>
            
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label">Emails per hour</label>
                <div class="col-sm-4">
                    <input type="number" name="emails_per_hour" class="form-control" value="50">
                    <small class="text-muted">Rate limiting to stay under SMTP limits.</small>
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-2 col-form-label">Message (HTML)</label>
                <div class="col-sm-10">
                    <textarea id="mail_body" name="body" class="form-control" rows="15" placeholder="Your HTML message here..."></textarea>
                    <small class="text-muted">You can use basic HTML tags.</small>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-10 offset-sm-2">
                    <button type="submit" class="btn btn-primary"><i class="fa fa-save"></i> Create & Queue</button>
                    <a href="{$url}massmail/admin" class="btn btn-default">Cancel</a>
                </div>
            </div>
        </form>
    </div>
</section>

<script type="text/javascript">
    // Initialize CodeMirror or some rich editor if available in FusionCMS
    // Admin uses CodeMirror by default for templates
</script>
