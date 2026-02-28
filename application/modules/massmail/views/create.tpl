<section class="card">
    <header class="card-header">
        <h2 class="card-title">New Campaign</h2>
    </header>
    <div class="card-body">
        <form action="{$url}massmail/admin/submit" method="post" id="create_campaign_form">
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label">Target Audience</label>
                <div class="col-sm-10">
                    <select name="target_type" id="target_type" class="form-control bg-dark text-white border-secondary" onChange="toggleTargetEmails()">
                        <option value="all">Every Registered Player (All Users)</option>
                        <option value="test">Specific Test Emails (Separate by comma)</option>
                    </select>
                </div>
            </div>

            <div class="row mb-3" id="test_emails_row" style="display:none;">
                <label class="col-sm-2 col-form-label">Test Emails</label>
                <div class="col-sm-10">
                    <input type="text" name="test_emails" class="form-control bg-dark text-white border-secondary" placeholder="admin@example.com, owner@example.com">
                    <small class="text-muted">Comma separated emails to receive the test. Useful to verify formatting before mass sending.</small>
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-2 col-form-label">Subject</label>
                <div class="col-sm-10">
                    <input type="text" name="subject" class="form-control bg-dark text-white border-secondary" required placeholder="Mass Mail Subject">
                </div>
            </div>
            
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label">Emails per hour</label>
                <div class="col-sm-4">
                    <input type="number" name="emails_per_hour" class="form-control bg-dark text-white border-secondary" value="50">
                    <small class="text-muted">Rate limiting to stay under SMTP provider limits.</small>
                </div>
            </div>

            <div class="row mb-3">
                <label class="col-sm-2 col-form-label">Message (HTML)</label>
                <div class="col-sm-10">
                    <textarea id="mail_body" name="body" class="form-control tinymce" rows="15" placeholder="Your HTML message here..."></textarea>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-10 offset-sm-2">
                    <button type="submit" class="btn btn-primary" onclick="return saveWysiwyg();"><i class="fa fa-save"></i> Create & Queue</button>
                    <a href="{$url}massmail/admin" class="btn btn-default">Cancel</a>
                </div>
            </div>
        </form>
    </div>
</section>

<script src="{$url}application/js/tiny_mce/tinymce.min.js"></script>
<script type="text/javascript">
    function toggleTargetEmails() {
        var type = document.getElementById('target_type').value;
        if (type === 'test') {
            document.getElementById('test_emails_row').style.display = 'flex';
        } else {
            document.getElementById('test_emails_row').style.display = 'none';
        }
    }

    tinymce.init({
        selector: 'textarea.tinymce',
        menubar: true,
        plugins: 'advlist autolink lists link image charmap preview anchor pagebreak searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking save table directionality template',
        toolbar: 'undo redo | blocks fontfamily fontsize | bold italic underline strikethrough | link image media table | align lineheight | numlist bullist indent outdent | emoticons charmap | removeformat | code',
        skin: 'oxide-dark',
        content_css: 'dark'
    });

    function saveWysiwyg() {
        if (typeof tinyMCE !== 'undefined') {
            tinyMCE.triggerSave();
        }
        return true;
    }
</script>
