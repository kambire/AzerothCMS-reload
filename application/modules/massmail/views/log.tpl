<section class="card border-0 shadow-sm bg-dark text-white mb-4" style="border-radius: 15px; overflow: hidden;">
    <header class="card-header border-0 p-4 d-flex justify-content-between align-items-center" style="background: linear-gradient(90deg, #c62828 0%, #d32f2f 100%);">
        <h2 class="card-title text-white mb-0" style="font-size: 1.5rem;"><i class="fa fa-bug me-2"></i> Mail Server Debugger</h2>
        <div>
            <a href="{$url}massmail/admin/clear_log" class="btn btn-outline-light btn-sm px-3" onclick="return confirm('Clear all error logs?')"><i class="fa fa-broom me-1"></i> Clear Log</a>
            <a href="{$url}massmail/admin" class="btn btn-light btn-sm fw-bold px-3 text-danger ms-2">Back to Dashboard</a>
        </div>
    </header>
    <div class="card-body p-0">
        <div class="table-responsive">
            <table class="table table-hover mb-0" style="color: #e0e0e0; vertical-align: middle;">
                <thead style="background: #121212;">
                    <tr class="text-uppercase small fw-bold text-muted">
                        <th class="ps-4 py-3">Campaign ID</th>
                        <th class="py-3">Recipient</th>
                        <th class="py-3">Error Description</th>
                        <th class="pe-4 py-3 text-end">Time</th>
                    </tr>
                </thead>
                <tbody>
                    {foreach from=$errors item=error}
                    <tr class="border-secondary">
                        <td class="ps-4">#{$error.campaign_id}</td>
                        <td class="fw-bold">{$error.email}</td>
                        <td class="small">
                            <div class="bg-black p-2 rounded text-danger overflow-auto" style="max-height: 150px; font-family: monospace; font-size: 11px;">
                                {$error.error_message|nl2br}
                            </div>
                        </td>
                        <td class="pe-4 text-end small text-muted">{date("M d, Y • H:i:s", $error.timestamp)}</td>
                    </tr>
                    {/foreach}
                    {if !count($errors)}
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">
                            <i class="fa fa-check-circle d-block mb-3" style="font-size: 3rem; opacity: 0.2; color: #43a047;"></i>
                            No SMTP errors detected. All systems seem operational!
                        </td>
                    </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </div>
</section>
