<section class="card border-0 shadow-sm bg-dark text-white mb-4" style="border-radius: 15px; overflow: hidden;">
    <header class="card-header border-0 p-4" style="background: linear-gradient(90deg, #1a237e 0%, #3949ab 100%);">
        <h2 class="card-title text-white mb-0" style="font-size: 1.5rem;"><i class="fa fa-plus-circle me-2"></i> Launch New Campaign</h2>
    </header>
    <div class="card-body p-4">
        <form action="{$url}massmail/admin/submit" method="post" id="create_campaign_form">
            
            <div class="row mb-4">
                <div class="col-md-6">
                    <label class="form-label fw-bold text-primary small text-uppercase">Target Audience</label>
                    <div class="input-group">
                        <span class="input-group-text bg-darker border-secondary text-muted"><i class="fa fa-users"></i></span>
                        <select name="target_type" id="target_type" class="form-select bg-dark text-white border-secondary" onChange="toggleTargetEmails()">
                            <option value="all">Every Registered Player (All Users)</option>
                            <option value="test">Specific Test Emails (Separate by comma)</option>
                        </select>
                    </div>
                    <small class="text-muted mt-1 d-block">Who will receive this message?</small>
                </div>
                
                <div class="col-md-6">
                    <label class="form-label fw-bold text-primary small text-uppercase">Emails per Hour</label>
                    <div class="input-group">
                        <span class="input-group-text bg-darker border-secondary text-muted"><i class="fa fa-bolt"></i></span>
                        <input type="number" name="emails_per_hour" class="form-control bg-dark text-white border-secondary" value="{$default_emails_per_hour}" min="1">
                    </div>
                    <small class="text-muted mt-1 d-block">Maximum server speed for this campaign.</small>
                </div>
            </div>

            <div class="mb-4" id="test_emails_row" style="display:none;">
                <label class="form-label fw-bold text-warning small text-uppercase">Test Recipients</label>
                <div class="input-group">
                    <span class="input-group-text bg-darker border-secondary text-muted"><i class="fa fa-vial"></i></span>
                    <input type="text" name="test_emails" class="form-control bg-dark text-white border-secondary" placeholder="admin@example.com, owner@example.net">
                </div>
                <small class="text-muted mt-1 d-block">The mass campaign will only be sent to these addresses.</small>
            </div>

            <hr class="border-secondary mb-4">

            <div class="mb-4">
                <label class="form-label fw-bold text-primary small text-uppercase">Subject Line</label>
                <div class="input-group">
                    <span class="input-group-text bg-darker border-secondary text-muted"><i class="fa fa-heading"></i></span>
                    <input type="text" name="subject" class="form-control bg-dark text-white border-secondary" required placeholder="Type your subject here...">
                </div>
            </div>
            
            <div class="mb-4">
                <label class="form-label fw-bold text-primary small text-uppercase">Message & Branding</label>
                <textarea id="mail_body" name="body" class="form-control tinymce" rows="15"></textarea>
            </div>

            <div class="d-flex justify-content-between align-items-center mt-5 pt-3 border-top border-secondary">
                <a href="{$url}massmail/admin" class="btn btn-outline-secondary px-4"><i class="fa fa-times me-1"></i> Discard</a>
                <button type="submit" class="btn btn-primary px-5 fw-bold shadow" style="background: linear-gradient(135deg, #3949ab, #1a237e); border: none;" onclick="return saveWysiwyg();">
                    <i class="fa fa-paper-plane me-2"></i> Create & Prepare Queue
                </button>
            </div>
        </form>
    </div>
</section>

<style>
    .bg-darker {
        background-color: #121212 !important;
    }
    .form-label {
        letter-spacing: 0.5px;
    }
    .input-group-text {
        border-right: none;
    }
    .form-control, .form-select {
        border-left: none;
    }
    .form-control:focus, .form-select:focus {
        background-color: #1a1a1a !important;
        box-shadow: none;
        border-color: #3949ab;
    }
</style>

<script src="{$url}application/js/tiny_mce/tinymce.min.js"></script>
<script type="text/javascript">
    function toggleTargetEmails() {
        var type = document.getElementById('target_type').value;
        if (type === 'test') {
            document.getElementById('test_emails_row').style.display = 'block';
        } else {
            document.getElementById('test_emails_row').style.display = 'none';
        }
    }

    tinymce.init({
        selector: 'textarea.tinymce',
        menubar: true,
        height: 500,
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
