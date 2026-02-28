<div class="row mb-3">
    <div class="col-12 text-end">
        <a href="{$url}store/admin_orders" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Back to Orders</a>
    </div>
</div>

{if isset($success_msg) && $success_msg}
<div class="alert alert-success">
    <i class="fa-solid fa-check-circle"></i> {$success_msg}
</div>
{/if}

<div class="row">
    {foreach from=$gateways item=gateway}
    <div class="col-md-6 mb-4">
        <div class="card shadow-sm {if $gateway.is_active}border-success{else}border-secondary{/if}">
            <div class="card-header {if $gateway.is_active}bg-success text-white{else}bg-light text-dark{/if}">
                <strong><i class="fa-solid fa-money-check-dollar"></i> {$gateway.display_name}</strong>
                <span class="badge {if $gateway.is_active}bg-light text-success{else}bg-secondary text-light{/if} float-end">
                    {if $gateway.is_active}ACTIVE{else}DISABLED{/if}
                </span>
            </div>
            <div class="card-body">
                <form action="{$url}store/admin_payments" method="POST">
                    <input type="hidden" name="id" value="{$gateway.id}">
                    
                    <div class="form-check form-switch mb-3">
                        <input class="form-check-input" type="checkbox" id="flexSwitchCheck_{$gateway.id}" name="is_active" value="1" {if $gateway.is_active}checked{/if}>
                        <label class="form-check-label" for="flexSwitchCheck_{$gateway.id}">Enable gateway in Store</label>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Configuration Keys (JSON)</label>
                        <textarea name="config" rows="4" class="form-control bg-dark text-white font-monospace" required>{$gateway.config}</textarea>
                        <div class="form-text">Paste your API keys as JSON. E.g <code>{literal}{ "public_key": "xxx", "secret_key": "yyy" }{/literal}</code></div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-save"></i> Save Settings</button>
                </form>
            </div>
        </div>
    </div>
    {/foreach}
</div>
