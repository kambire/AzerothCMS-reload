<div class="container">
	<div class="row">

		{$link_active = "store"}
		
		{* HORIZONTAL UCP NAVIGATION OVERRIDE FOR STORE *}
		<div class="col-12 mt-4 mb-2">
			<div class="d-flex flex-wrap gap-2 justify-content-center p-3 rounded" style="background: rgba(0,0,0,0.3); border: 1px solid rgba(255,255,255,0.08);">
				<a href="{$url}ucp" class="btn btn-sm text-white" style="background: rgba(255,255,255,0.1);">
					<img src="{$CI->user->getAvatar()}" alt="avatar" class="rounded-circle me-2" width="20" height="20">
					UCP Home
				</a>
				{foreach $ucp_menus as $group => $menusGroup}
					{foreach $menusGroup as $menu}
						<a href="{$menu.link}" class="btn btn-sm {if $url|cat:$link_active == $menu.link}btn-primary text-white{else}text-light opacity-75{/if}" {if $url|cat:$link_active != $menu.link}style="background: rgba(255,255,255,0.05);"{/if}>
							{$menu.name}
						</a>
					{/foreach}
				{/foreach}
			</div>
		</div>
		
		<div class="col-lg-12 pb-5">
			<div id="store_wrapper">
				<script type="text/javascript">
					$(document).ready(function()
					{
						function checkIfLoaded()
						{
							if(typeof Store != "undefined")
							{
								Store.Customer.initialize({$vp}, {$dp});
							}
							else
							{
								setTimeout(checkIfLoaded, 50);
							}
						}

						checkIfLoaded();
					});
				</script>

				<div id="checkout"></div>

				
			<div id="store_wrapper">
				<div id="store">
					<form onSubmit="return false" class="mb-5">
						
						{* BOTONERA HORIZONTAL DE FILTROS CREADA NUEVA *}
						<div class="store-filters-panel p-3 mb-4 rounded" style="background: rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.05);">
							<div class="row g-3 align-items-center mb-3 border-bottom pb-3" style="border-color: rgba(255,255,255,0.05) !important;">
								<div class="col-md-9 d-flex flex-wrap gap-2">
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('ALL'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: rgba(255,255,255,0.2); opacity: 1;">
										<i class="fa fa-asterisk"></i> {lang("all_items", "store")}
									</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('0'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #9d9d9d; opacity: 0.5;">{lang("poor", "store")}</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('1'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #ffffff; color: #000 !important; opacity: 0.5;">{lang("common", "store")}</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('2'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #1eff00; text-shadow: 1px 1px 2px #000; opacity: 0.5;">{lang("uncommon", "store")}</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('3'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #0070dd; opacity: 0.5;">{lang("rare", "store")}</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('4'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #a335ee; opacity: 0.5;">{lang("epic", "store")}</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('5'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #ff8000; opacity: 0.5;">{lang("legendary", "store")}</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('6'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #e6cc80; opacity: 0.5;">{lang("artifact", "store")}</a>
									<a href="javascript:void(0)" onClick="Store.Filter.setQuality('7'); $(this).siblings().css('opacity', '0.5'); $(this).css('opacity', '1');" class="btn btn-sm text-white" style="background: #00ccff; opacity: 0.5;">{lang("heirloom", "store")}</a>
								</div>
								<div class="col-md-3 text-end">
									<a href="javascript:void(0)" onClick="Store.Filter.toggleVote(this)" class="nice_button nice_active me-2" style="padding: 5px 10px; border-radius: 5px; background: rgba(0,0,0,0.3);">
										<img src="{$url}application/images/icons/lightning.png" align="absmiddle" style="height:14px;"> {lang("vp", "store")}
									</a>
									<a href="javascript:void(0)" onClick="Store.Filter.toggleDonate(this)" class="nice_button nice_active" style="padding: 5px 10px; border-radius: 5px; background: rgba(0,0,0,0.3);">
										<img src="{$url}application/images/icons/coins.png" align="absmiddle" style="height:14px;"> {lang("dp", "store")}
									</a>
								</div>
							</div>
							
							<div class="row g-3 align-items-center">
								<div class="col-md-2 text-muted small text-uppercase">
									<i class="fa fa-sort"></i> {lang("sort_by", "store")}
								</div>
								<div class="col-md-4">
									<select id="sort_by" name="sort_by" class="form-select form-select-sm" onChange="Store.Filter.sort(this.value)" style="background-color: rgba(0,0,0,0.5); color: #fff; border: 1px solid rgba(255,255,255,0.1);">
										<option value="standard" selected>{lang("default", "store")}</option>
										<option value="name">{lang("name", "store")}</option>
										<option value="priceVp">{lang("price", "store")} ({lang("vp", "store")})</option>
										<option value="priceDp">{lang("price", "store")} ({lang("dp", "store")})</option>
										<option value="quality">{lang("item_quality", "store")}</option>
									</select>
								</div>
								<div class="col-md-6">
									<div class="input-group input-group-sm">
										<span class="input-group-text" style="background-color: rgba(0,0,0,0.5); color: #fff; border: 1px solid rgba(255,255,255,0.1);"><i class="fa fa-search"></i></span>
										<input class="form-control form-control-sm" type="text" id="filter_name" placeholder="{lang("filter", "store")}..." onKeyUp="Store.Filter.setName(this.value)" style="background-color: rgba(0,0,0,0.5); color: #fff; border: 1px solid rgba(255,255,255,0.1);">
									</div>
								</div>
							</div>
						</div>
					</form>

					<div id="store_content">
						<div id="store_realms">
							{foreach from=$data item=realm key=realmId}
							<div class="realm-store-section mb-5" id="realm_parent_{$realmId}">
								<h2 class="text-primary mb-4" id="realm_{$realmId}" style="border-bottom: 2px solid var(--primary-color, #007bff); padding-bottom: 10px;">
									<i class="fa fa-server"></i> {$realm.name}
								</h2>

								<div id="realm_indicator_{$realmId}">
									{if isset($realm.items.groups)}
										{foreach from=$realm.items.groups item=group}
											<div class="store-group-section mb-5" id="group_parent_{$group.id}_{$realmId}">
												<h4 class="mb-4 d-flex align-items-center" id="group_{$group.id}" style="font-weight: 600; color: #ccc;">
													<span style="flex-grow: 1; border-top: 1px dashed rgba(255,255,255,0.2); margin-right: 15px;"></span>
													{if $group.icon}<i class="{$group.icon} me-2 text-primary"></i>{/if}
													{$group.title}
												</h4>

												<div class="row g-4" id="group_{$group.id}_realm_{$realmId}">
													{foreach from=$group.items item=item}
													<div class="col-md-6 col-lg-4">
														<div class="store_item card h-100 bg-dark text-white" id="item_{$item.id}" style="border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.5); transition: transform 0.2s;">
															
															<div class="card-body text-center p-4">
																<div class="item-icon-wrapper mb-3" style="position: relative; display: inline-block;">
																	<img class="item_icon rounded shadow-lg" src="{$CI->config->item('api_item_icons')}/large/{$item.icon}.jpg" alt="{$item.name}" style="width: 68px; height: 68px; border: 2px solid #444;" {if $item.tooltip}data-realm="{$item.realm}" rel="item={$item.itemid}"{/if}>
																	{if $item.itemcount > 1 && !preg_match("/,/", $item.itemcount)}
																		<span class="badge bg-primary position-absolute bottom-0 end-0 translate-middle-x rounded-pill" style="font-size: 0.8rem;">x{$item.itemcount}</span>
																	{/if}
																</div>

																<h5 class="card-title text-truncate mb-2" style="font-weight: bold; font-size: 1.1rem;">
																	<a {if $item.tooltip}href="{$url}item/{$item.realm}/{$item.itemid}" data-realm="{$item.realm}" rel="item={$item.itemid}"{/if} class="item_name q{$item.quality} text-decoration-none" style="text-shadow: 1px 1px 2px rgba(0,0,0,0.8);">
																		{character_limiter($item.name, 35)}
																	</a>
																</h5>
																
																<p class="card-text small" style="color: rgba(255,255,255,0.75); min-height: 42px; line-height: 1.4;">
																	{character_limiter($item.description, 60)}
																</p>
															</div>
															
															<div class="card-footer bg-transparent border-top border-secondary p-3">
																<div class="store_buttons d-flex flex-column gap-2">
																	{if $item.vp_price}
																	<button type="button" onClick="Store.Cart.add({$item.id}, '{$item.itemid}', '{addslashes($item.name)}', {$item.vp_price}, 'vp', '{addslashes($realm.name)}', {$realmId}, {$item.quality}, {$item.tooltip})" class="btn btn-outline-warning w-100 d-flex justify-content-between align-items-center vp_button" style="border-radius: 8px;">
																		<span><img src="{$url}application/images/icons/lightning.png" align="absmiddle" style="height:16px;"> {lang("vp", "store")}</span>
																		<strong><span class="vp_price_value">{$item.vp_price}</span></strong>
																	</button>
																	{/if}
						
																	{if $item.dp_price}
																	<button type="button" onClick="Store.Cart.add({$item.id}, '{$item.itemid}', '{addslashes($item.name)}', {$item.dp_price}, 'dp', '{addslashes($realm.name)}', {$realmId}, {$item.quality}, {$item.tooltip})" class="btn btn-outline-info w-100 d-flex justify-content-between align-items-center dp_button" style="border-radius: 8px;">
																		<span><img src="{$url}application/images/icons/coins.png" align="absmiddle" style="height:16px;"> {lang("dp", "store")}</span>
																		<strong><span class="dp_price_value">{$item.dp_price}</span></strong>
																	</button>
																	{/if}
																</div>
															</div>

														</div>
													</div>
													{/foreach}
												</div>
											</div>
										{/foreach}
									{/if}

									{if isset($realm.items.items)}
										<div class="row g-4 mt-4">
											{foreach from=$realm.items.items item=item}
											<div class="col-md-6 col-lg-4">
												<div class="store_item card h-100 bg-dark text-white" id="item_{$item.id}" style="border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.5);">
													<div class="card-body text-center p-4">
														<div class="item-icon-wrapper mb-3">
															<img class="item_icon rounded shadow-lg" src="{$CI->config->item('api_item_icons')}/large/{$item.icon}.jpg" alt="{$item.name}" style="width: 68px; height: 68px; border: 2px solid #444;" {if $item.tooltip}data-realm="{$item.realm}" rel="item={$item.itemid}"{/if}>
														</div>
														<h5 class="card-title text-truncate mb-2" style="font-weight: bold; font-size: 1.1rem;">
															<a {if $item.tooltip}href="{$url}item/{$item.realm}/{$item.itemid}" data-realm="{$item.realm}" rel="item={$item.itemid}"{/if} class="item_name q{$item.quality} text-decoration-none" style="text-shadow: 1px 1px 2px rgba(0,0,0,0.8);">
																{character_limiter($item.name, 35)}
															</a>
														</h5>
														<p class="card-text small" style="color: rgba(255,255,255,0.75); min-height: 42px; line-height: 1.4;">
															{character_limiter($item.description, 60)}
														</p>
													</div>
													<div class="card-footer bg-transparent border-top border-secondary p-3">
														<div class="store_buttons d-flex flex-column gap-2">
															{if $item.vp_price}
															<button type="button" onClick="Store.Cart.add({$item.id}, '{$item.itemid}', '{addslashes(preg_replace('/"/', "'", $item.name))}', {$item.vp_price}, 'vp', '{addslashes($realm.name)}', {$realmId}, {$item.quality}, {$item.tooltip})" class="btn btn-outline-warning w-100 d-flex justify-content-between align-items-center vp_button" style="border-radius: 8px;">
																<span><img src="{$url}application/images/icons/lightning.png" align="absmiddle" style="height:16px;"> {lang("vp", "store")}</span>
																<strong><span class="vp_price_value">{$item.vp_price}</span></strong>
															</button>
															{/if}
															{if $item.dp_price}
															<button type="button" onClick="Store.Cart.add({$item.id}, '{$item.itemid}', '{addslashes(preg_replace('/"/', "'", $item.name))}', {$item.dp_price}, 'dp', '{addslashes($realm.name)}', {$realmId}, {$item.quality}, {$item.tooltip})" class="btn btn-outline-info w-100 d-flex justify-content-between align-items-center dp_button" style="border-radius: 8px;">
																<span><img src="{$url}application/images/icons/coins.png" align="absmiddle" style="height:16px;"> {lang("dp", "store")}</span>
																<strong><span class="dp_price_value">{$item.dp_price}</span></strong>
															</button>
															{/if}
														</div>
													</div>
												</div>
											</div>
											{/foreach}
										</div>
									{/if}
								</div>
							</div>
						{/foreach}	
						</div>
						
						<div class="card">
							<div id="cart">
								<div class="card-header"><span class="fa-duotone fa-shopping-cart"></span> {lang("cart", "store")} (<span id="cart_item_count">0</span> {lang("items", "store")})</div>
								<div class="card-body">
									<div id="empty_cart">{lang("empty_cart", "store")}</div>
									<div id="cart_items"></div>
								</div>
								<div class="card-footer">
									<div id="cart_price" class="d-flex">
										<div id="vp_price_full" class="p-2">
											<img src="{$url}application/images/icons/lightning.png"> <span id="vp_price">0</span> {lang("vp", "store")}
										</div>
				
										<div id="dp_price_full" class="p-2">
											<img src="{$url}application/images/icons/coins.png"> <span id="dp_price">0</span> {lang("dp", "store")}
										</div>

										<div class="ms-auto p-1">
											<a href="javascript:void(0)" onClick="Store.Cart.checkout(this)" class="nice_button">{lang("checkout", "store")}</a>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			</div>
		</div>
	</div>
</div>