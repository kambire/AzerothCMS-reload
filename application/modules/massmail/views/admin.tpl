<div class="row">
    <div class="col-lg-12">
        <section class="card border-0 shadow-sm bg-dark text-white overflow-hidden mb-4" style="border-radius: 15px;">
            <header class="card-header border-0 p-4" style="background: linear-gradient(90deg, #1a237e 0%, #3949ab 100%);">
                <div class="card-actions d-flex gap-2">
                    <a href="{$url}massmail/admin/settings" class="btn btn-outline-light btn-sm border-0" style="background: rgba(255,255,255,0.1);"><i class="fa fa-cog"></i> Global Settings</a>
                    <a href="{$url}massmail/admin/create" class="btn btn-light btn-sm fw-bold px-3 text-primary"><i class="fa fa-plus me-1"></i> New Campaign</a>
                </div>
                <h2 class="card-title text-white mb-0" style="font-size: 1.5rem;"><i class="fa fa-envelope-open-text me-2"></i> Mail Campaigns</h2>
            </header>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0" style="color: #e0e0e0; vertical-align: middle;">
                        <thead class="bg-darker" style="background: #121212;">
                            <tr class="text-uppercase small fw-bold text-muted">
                                <th class="ps-4 py-3">Campaign Subject</th>
                                <th class="py-3">Status</th>
                                <th class="py-3">Progress</th>
                                <th class="py-3">Speed</th>
                                <th class="py-3">Date Created</th>
                                <th class="pe-4 py-3 text-end">Management</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$campaigns item=campaign}
                            <tr class="border-secondary">
                                <td class="ps-4 fw-bold" style="color: #fff;">{$campaign.subject}</td>
                                <td>
                                    {if $campaign.status == 'pending'}
                                        <span class="badge rounded-pill px-3 py-2" style="background: #424242; color: #bdbdbd;"><i class="fa fa-clock me-1"></i> Pending</span>
                                    {elseif $campaign.status == 'sending'}
                                        <span class="badge rounded-pill px-3 py-2 animate-pulse" style="background: #1e88e5; color: #fff;"><i class="fa fa-paper-plane me-1"></i> Sending</span>
                                    {elseif $campaign.status == 'completed'}
                                        <span class="badge rounded-pill px-3 py-2" style="background: #43a047; color: #fff;"><i class="fa fa-check-circle me-1"></i> Completed</span>
                                    {elseif $campaign.status == 'paused'}
                                        <span class="badge rounded-pill px-3 py-2" style="background: #fb8c00; color: #fff;"><i class="fa fa-pause-circle me-1"></i> Paused</span>
                                    {/if}
                                </td>
                                <td>
                                    <div class="d-flex justify-content-between align-items-center mb-1 small">
                                        <span>Sent: {$campaign.sent_users} / {$campaign.total_users}</span>
                                        {assign var="percent" value=0}
                                        {if $campaign.total_users > 0}
                                            {assign var="percent" value=round(($campaign.sent_users / $campaign.total_users) * 100)}
                                        {/if}
                                        <span class="fw-bold">{$percent}%</span>
                                    </div>
                                    <div class="progress" style="height: 6px; background: #333; border-radius: 3px;">
                                        <div class="progress-bar" role="progressbar" style="width: {$percent}%; background: linear-gradient(90deg, #1e88e5, #4fc3f7); border-radius: 3px;"></div>
                                    </div>
                                </td>
                                <td class="small"><i class="fa fa-bolt text-warning me-1"></i> {$campaign.emails_per_hour}/hr</td>
                                <td class="small text-muted">{date("M d, Y • H:i", $campaign.created_at)}</td>
                                <td class="pe-4 text-end">
                                    <div class="btn-group">
                                        {if $campaign.status == 'pending' || $campaign.status == 'paused'}
                                            <a href="{$url}massmail/admin/start/{$campaign.id}" class="btn btn-success btn-sm border-0 shadow-sm px-3" style="background: #2e7d32;" title="Start Sending">
                                                <i class="fa fa-play"></i>
                                            </a>
                                        {elseif $campaign.status == 'sending'}
                                            <a href="{$url}massmail/admin/pause/{$campaign.id}" class="btn btn-warning btn-sm border-0 shadow-sm px-3" style="background: #ef6c00;" title="Pause Queue">
                                                <i class="fa fa-pause"></i>
                                            </a>
                                        {/if}
                                        <a href="{$url}massmail/admin/delete/{$campaign.id}" class="btn btn-danger btn-sm border-0 shadow-sm px-3" style="background: #c62828;" title="Delete Campaign" onclick="return confirm('Destructive Action: Are you sure you want to delete this campaign?')">
                                            <i class="fa fa-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            {/foreach}
                            {if !count($campaigns)}
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="fa fa-inbox d-block mb-3" style="font-size: 3rem; opacity: 0.2;"></i>
                                    You haven't launched any mail campaigns yet.
                                </td>
                            </tr>
                            {/if}
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <div class="card border-0 shadow-sm bg-dark p-4" style="border-radius: 15px; border-left: 5px solid #1e88e5 !important;">
            <h5 class="text-primary fw-bold mb-2"><i class="fa fa-info-circle me-1"></i> Cron Process Automation</h5>
            <p class="text-muted small mb-3">To ensure your message queue is processed reliably without keeping this window open, please register the following task in your server crontab (e.g., via <code>crontab -e</code>):</p>
            <div class="bg-black p-3 rounded d-flex justify-content-between align-items-center mb-0">
                <code class="text-success fw-bold" id="cron_command">*/10 * * * * php {$index_path} massmail admin process_queue</code>
                <button class="btn btn-xs btn-outline-secondary border-0" onclick="copyToClipboard()"><i class="fa fa-copy"></i> Copy</button>
            </div>
        </div>
    </div>
</div>

<style>
    .animate-pulse {
        animation: pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite;
    }
    @keyframes pulse {
        0%, 100% { opacity: 1; }
        50% { opacity: .7; }
    }
    .table-hover tbody tr:hover {
        background-color: rgba(255, 255, 255, 0.03);
    }
    .bg-darker {
        background-color: #121212 !important;
    }
</style>

<script>
    function copyToClipboard() {
        var range = document.createRange();
        range.selectNode(document.getElementById("cron_command"));
        window.getSelection().removeAllRanges();
        window.getSelection().addRange(range);
        document.execCommand("copy");
        window.getSelection().removeAllRanges();
        alert("Command copied to clipboard!");
    }
</script>
