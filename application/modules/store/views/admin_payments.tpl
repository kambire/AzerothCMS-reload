<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h5 class="mb-0 text-muted">Configure and activate the payment gateways available on your server.</h5>
    </div>
    <a href="{$url}store/admin_orders" class="btn btn-secondary btn-sm"><i class="fa-solid fa-arrow-left"></i> Back to Orders</a>
</div>

{if isset($success_msg) && $success_msg}
<div class="alert alert-success alert-dismissible fade show mb-4">
    <i class="fa-solid fa-circle-check me-2"></i> {$success_msg}
    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
</div>
{/if}

<div class="row g-4">
    {foreach from=$gateways item=gw}

    {* Parse config for this gateway *}
    {assign var="cfg" value=$gw.config_parsed}

    <div class="col-md-6">
        <div class="card h-100 shadow-sm" style="border-radius:14px; border: 2px solid {if $gw.is_active}#20c997{else}#495057{/if}; background:#1a1d27;">
            {* Card header with icon + name + badge *}
            <div class="card-header d-flex align-items-center gap-3" style="background:{if $gw.is_active}linear-gradient(90deg,#0d6e55,#20c997){else}#2a2d3a{/if};border-radius:12px 12px 0 0;border:none;padding:16px 20px;">
                <div class="rounded-circle d-flex align-items-center justify-content-center" style="width:42px;height:42px;background:rgba(255,255,255,0.15);">
                    {if $gw.name == 'offline'}<i class="fa-solid fa-building-columns fa-lg text-white"></i>
                    {elseif $gw.name == 'paypal'}<i class="fa-brands fa-paypal fa-lg text-white"></i>
                    {elseif $gw.name == 'pagopar'}<i class="fa-solid fa-money-bill-wave fa-lg text-white"></i>
                    {elseif $gw.name == 'skrill'}<i class="fa-solid fa-s fa-lg text-white"></i>
                    {else}<i class="fa-solid fa-credit-card fa-lg text-white"></i>{/if}
                </div>
                <div class="flex-grow-1">
                    <h6 class="mb-0 text-white fw-bold">{$gw.display_name}</h6>
                    <small class="text-white-50">
                        {if $gw.name == 'offline'}Manual bank / wire transfer{/if}
                        {if $gw.name == 'paypal'}PayPal REST API (Sandbox & Live){/if}
                        {if $gw.name == 'pagopar'}Pagopar · Paraguay{/if}
                        {if $gw.name == 'skrill'}Skrill / Moneybookers{/if}
                    </small>
                </div>
                <span class="badge {if $gw.is_active}bg-light text-success{else}bg-secondary{/if} ms-auto">
                    {if $gw.is_active}<i class="fa-solid fa-circle-check me-1"></i>Active{else}<i class="fa-solid fa-circle-xmark me-1"></i>Inactive{/if}
                </span>
            </div>

            <div class="card-body p-4">
                <form action="{$url}store/admin_payments" method="POST">
                    <input type="hidden" name="id" value="{$gw.id}">
                    <input type="hidden" name="gateway_name" value="{$gw.name}">

                    {* Enable / Disable toggle *}
                    <div class="d-flex align-items-center justify-content-between p-3 mb-4 rounded" style="background:rgba(255,255,255,0.05);">
                        <div>
                            <span class="text-white fw-semibold">Enable this gateway</span>
                            <div class="text-muted" style="font-size:12px;">Players will see this payment option at checkout</div>
                        </div>
                        <div class="form-check form-switch m-0">
                            <input class="form-check-input" type="checkbox" id="toggle_{$gw.id}" name="is_active" value="1" style="width:46px;height:24px;" {if $gw.is_active}checked{/if}>
                        </div>
                    </div>

                    {* ============================================ *}
                    {* OFFLINE PAYMENT — intuitive bank detail form *}
                    {* ============================================ *}
                    {if $gw.name == 'offline'}
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Account Holder / Beneficiary</label>
                        <input type="text" name="beneficiary" class="form-control bg-dark text-white border-secondary"
                               value="{if isset($cfg.beneficiary)}{$cfg.beneficiary}{/if}" placeholder="e.g. Juan García">
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-7">
                            <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Bank Name</label>
                            <input type="text" name="bank_name" class="form-control bg-dark text-white border-secondary"
                                   value="{if isset($cfg.bank_name)}{$cfg.bank_name}{/if}" placeholder="e.g. Banco Itaú">
                        </div>
                        <div class="col-md-5">
                            <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Currency</label>
                            <input type="text" name="currency" class="form-control bg-dark text-white border-secondary"
                                   value="{if isset($cfg.currency)}{$cfg.currency}{/if}" placeholder="USD, PYG, BRL…">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-7">
                            <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Account Number / CBU / CLABE</label>
                            <input type="text" name="account_number" class="form-control bg-dark text-white border-secondary"
                                   value="{if isset($cfg.account_number)}{$cfg.account_number}{/if}" placeholder="0000-0000-0000-0000">
                        </div>
                        <div class="col-md-5">
                            <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Account Type</label>
                            <select name="account_type" class="form-select bg-dark text-white border-secondary">
                                <option value="">Not specified</option>
                                <option value="Savings" {if isset($cfg.account_type) && $cfg.account_type=='Savings'}selected{/if}>Savings</option>
                                <option value="Checking" {if isset($cfg.account_type) && $cfg.account_type=='Checking'}selected{/if}>Checking</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">PIX Key <span class="text-secondary">(optional – Brazil)</span></label>
                        <input type="text" name="pix_key" class="form-control bg-dark text-white border-secondary"
                               value="{if isset($cfg.pix_key)}{$cfg.pix_key}{/if}" placeholder="CPF, CNPJ, Phone, Email or Random">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Instructions for the player</label>
                        <textarea name="instructions" rows="3" class="form-control bg-dark text-white border-secondary"
                                  placeholder="e.g. Send payment with your username in the reference field, then submit the form below.">{if isset($cfg.instructions)}{$cfg.instructions}{/if}</textarea>
                    </div>
                    {/if}

                    {* ============================================ *}
                    {* PAYPAL — labeled inputs instead of JSON      *}
                    {* ============================================ *}
                    {if $gw.name == 'paypal'}
                    <div class="alert alert-info mb-3 py-2" style="font-size:13px;">
                        <i class="fa-brands fa-paypal me-1"></i>
                        Get your credentials at <a href="https://developer.paypal.com/dashboard/" target="_blank" class="alert-link">developer.paypal.com</a> → My Apps &amp; Credentials.
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Environment</label>
                        <div class="d-flex gap-3">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="mode" id="sandbox_{$gw.id}" value="sandbox"
                                       {if !isset($cfg.mode) || $cfg.mode=='sandbox'}checked{/if}>
                                <label class="form-check-label text-warning" for="sandbox_{$gw.id}">🔶 Sandbox (Testing)</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="mode" id="live_{$gw.id}" value="live"
                                       {if isset($cfg.mode) && $cfg.mode=='live'}checked{/if}>
                                <label class="form-check-label text-success" for="live_{$gw.id}">🟢 Live (Production)</label>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Client ID</label>
                        <input type="text" name="client_id" class="form-control bg-dark text-white border-secondary font-monospace"
                               value="{if isset($cfg.client_id)}{$cfg.client_id}{/if}" placeholder="AaBbCc... (from PayPal dashboard)">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Client Secret</label>
                        <input type="password" name="secret" class="form-control bg-dark text-white border-secondary font-monospace"
                               value="{if isset($cfg.secret)}{$cfg.secret}{/if}" placeholder="••••••••••••••••">
                        <div class="form-text text-muted">This is never shown to players.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Currency</label>
                        <input type="text" name="currency" class="form-control bg-dark text-white border-secondary"
                               value="{if isset($cfg.currency)}{$cfg.currency}{else}USD{/if}" placeholder="USD, EUR, BRL…" style="max-width:120px">
                    </div>
                    {/if}

                    {* ============================================ *}
                    {* PAGOPAR                                      *}
                    {* ============================================ *}
                    {if $gw.name == 'pagopar'}
                    <div class="alert alert-info mb-3 py-2" style="font-size:13px;">
                        <i class="fa-solid fa-circle-info me-1"></i>
                        Get your keys at <a href="https://pagopar.com" target="_blank" class="alert-link">pagopar.com</a> → Configuraciones → API.
                        Currency is always Guaraníes (PYG).
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Public Key</label>
                        <input type="text" name="public_key" class="form-control bg-dark text-white border-secondary font-monospace"
                               value="{if isset($cfg.public_key)}{$cfg.public_key}{/if}" placeholder="tu_clave_publica_de_pagopar">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Private Key (Token)</label>
                        <input type="password" name="private_key" class="form-control bg-dark text-white border-secondary font-monospace"
                               value="{if isset($cfg.private_key)}{$cfg.private_key}{/if}" placeholder="••••••••••••••••">
                    </div>
                    {/if}

                    {* ============================================ *}
                    {* SKRILL                                       *}
                    {* ============================================ *}
                    {if $gw.name == 'skrill'}
                    <div class="alert alert-info mb-3 py-2" style="font-size:13px;">
                        <i class="fa-solid fa-circle-info me-1"></i>
                        Get your Merchant ID &amp; Secret Word from <a href="https://www.skrill.com" target="_blank" class="alert-link">Skrill Dashboard</a> → Account → Developers.
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Merchant Email (Skrill account email)</label>
                        <input type="email" name="merchant_email" class="form-control bg-dark text-white border-secondary"
                               value="{if isset($cfg.merchant_email)}{$cfg.merchant_email}{/if}" placeholder="payments@yourdomain.com">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Secret Word</label>
                        <input type="password" name="secret_word" class="form-control bg-dark text-white border-secondary font-monospace"
                               value="{if isset($cfg.secret_word)}{$cfg.secret_word}{/if}" placeholder="••••••••••••••••">
                    </div>
                    <div class="mb-3">
                        <label class="form-label text-white-50 text-uppercase" style="font-size:11px;letter-spacing:1px;">Currency</label>
                        <input type="text" name="currency" class="form-control bg-dark text-white border-secondary"
                               value="{if isset($cfg.currency)}{$cfg.currency}{else}USD{/if}" style="max-width:120px">
                    </div>
                    {/if}

                    <button type="submit" class="btn btn-primary w-100 mt-2"><i class="fa-solid fa-floppy-disk me-2"></i>Save Settings</button>
                </form>
            </div>
        </div>
    </div>
    {/foreach}
</div>
