<div class="row">
    <div class="col-lg-12">
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0 "><i class="fa-solid fa-money-bill"></i> Pending Offline Payments</h5>
            </div>
            <div class="card-body">
                <table class="table table-striped table-hover table-bordered mb-0">
                    <thead class="bg-dark text-white">
                        <tr>
                            <th width="3%">#ID</th>
                            <th>User</th>
                            <th>Amount</th>
                            <th>Points (DP)</th>
                            <th>Payment Method</th>
                            <th>Reference Code</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        {if $payments}
                            {foreach from=$payments item=pay}
                                <tr>
                                    <td>{$pay.id}</td>
                                    <td>
                                        <a href="{$url}profile/{$pay.user_id}" target="_blank" data-bs-toggle="tooltip" title="View Profile">
                                            {$pay.nickname}
                                        </a>
                                    </td>
                                    <td><span class="badge bg-primary px-2 py-1">{$pay.amount|number_format:2}</span></td>
                                    <td><span class="badge bg-success px-2 py-1 d-flex align-items-center" style="width:fit-content;"><img src="{$url}application/images/icons/coins.png" align="absmiddle" class="me-1"> {$pay.points} DP</span></td>
                                    <td><span class="text-uppercase fw-bold text-secondary">{$pay.method}</span></td>
                                    <td><code>{$pay.reference}</code></td>
                                    <td>{date("Y-m-d H:i:s", $pay.create_time)}</td>
                                    <td>
                                        {if $pay.status == 'pending'}
                                            <span class="badge bg-warning text-dark"><i class="fa-solid fa-clock"></i> Pending</span>
                                        {elseif $pay.status == 'completed'}
                                            <span class="badge bg-success"><i class="fa-solid fa-check"></i> Completed</span>
                                        {else}
                                            <span class="badge bg-danger"><i class="fa-solid fa-times"></i> Rejected</span>
                                        {/if}
                                    </td>
                                    <td>
                                        {if $pay.status == 'pending'}
                                            <div class="btn-group btn-group-sm">
                                                <a href="{$url}donate/admin/offline_approve/{$pay.id}" class="btn btn-success" onclick="return confirm('Are you sure you want to approve this payment and grant DP to the user?');"><i class="fa-solid fa-check"></i> Approve</a>
                                                <a href="{$url}donate/admin/offline_reject/{$pay.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to reject this payment?');"><i class="fa-solid fa-times"></i> Reject</a>
                                            </div>
                                        {else}
                                            <span class="text-muted"><i class="fa-solid fa-lock"></i> Locked</span>
                                        {/if}
                                    </td>
                                </tr>
                            {/foreach}
                        {else}
                            <tr>
                                <td colspan="9" class="text-center py-4 text-muted"><i class="fa-solid fa-inbox fa-2x mb-2"></i><br>No offline payments found.</td>
                            </tr>
                        {/if}
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
