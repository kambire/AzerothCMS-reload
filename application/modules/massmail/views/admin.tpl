<section class="card">
    <header class="card-header">
        <div class="card-actions">
            <a href="{$url}massmail/admin/create" class="btn btn-primary btn-sm"><i class="fa fa-plus"></i> New Campaign</a>
        </div>
        <h2 class="card-title">Mail Campaigns</h2>
    </header>
    <div class="card-body">
        <table class="table table-responsive-md table-hover mb-0">
            <thead>
                <tr>
                    <th>Subject</th>
                    <th>Status</th>
                    <th>Progress</th>
                    <th>Rate</th>
                    <th>Created</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$campaigns item=campaign}
                <tr>
                    <td>{$campaign.subject}</td>
                    <td>
                        {if $campaign.status == 'pending'}
                            <span class="badge bg-secondary">Pending</span>
                        {elseif $campaign.status == 'sending'}
                            <span class="badge bg-primary">Sending</span>
                        {elseif $campaign.status == 'completed'}
                            <span class="badge bg-success">Completed</span>
                        {elseif $campaign.status == 'paused'}
                            <span class="badge bg-warning">Paused</span>
                        {/if}
                    </td>
                    <td>
                        {$campaign.sent_users} / {$campaign.total_users}
                        <div class="progress progress-xs h-1 mt-1">
                            {assign var="percent" value=0}
                            {if $campaign.total_users > 0}
                                {assign var="percent" value=round(($campaign.sent_users / $campaign.total_users) * 100)}
                            {/if}
                            <div class="progress-bar bg-primary" role="progressbar" style="width: {$percent}%"></div>
                        </div>
                    </td>
                    <td>{$campaign.emails_per_hour}/hr</td>
                    <td>{date("Y-m-d H:i", $campaign.created_at)}</td>
                    <td>
                        {if $campaign.status == 'pending' || $campaign.status == 'paused'}
                            <a href="{$url}massmail/admin/start/{$campaign.id}" class="btn btn-success btn-xs" title="Start"><i class="fa fa-play"></i></a>
                        {elseif $campaign.status == 'sending'}
                            <a href="{$url}massmail/admin/pause/{$campaign.id}" class="btn btn-warning btn-xs" title="Pause"><i class="fa fa-pause"></i></a>
                        {/if}
                        <a href="{$url}massmail/admin/delete/{$campaign.id}" class="btn btn-danger btn-xs" title="Delete" onclick="return confirm('Are you sure?')"><i class="fa fa-trash"></i></a>
                    </td>
                </tr>
                {/foreach}
                {if !count($campaigns)}
                <tr>
                    <td colspan="6" class="text-center">No campaigns found.</td>
                </tr>
                {/if}
            </tbody>
        </table>
    </div>
</section>

<div class="alert alert-info mt-4">
    <strong>Note:</strong> To process the queue automatically, you should add a cron job to your server:<br>
    <code>*/10 * * * * php {$index_path} massmail admin process_queue</code>
</div>
