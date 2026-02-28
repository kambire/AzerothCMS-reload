<div class="container">
	<div class="row">

		{$link_active = "store"}
		{include file="../../ucp/views/ucp_navigation.tpl"}
		
		<div class="col-lg-8 py-lg-5 pb-5 pb-lg-0">
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
					<form onSubmit="return false">
					<div class="row align-self-center mb-3">
							<label class="col-sm-1 align-self-center sort" for="sort_by">{lang("sort_by", "store")}</label>
							<div class="col-sm-2">
							<select id="sort_by" name="sort_by" onChange="Store.Filter.sort(this.value)">
								<option value="standard" selected>{lang("default", "store")}</option>
								<option value="name">{lang("name", "store")}</option>
								<option value="priceVp">{lang("price", "store")} ({lang("vp", "store")})</option>
								<option value="priceDp">{lang("price", "store")} ({lang("dp", "store")})</option>
								<option value="quality">{lang("item_quality", "store")}</option>
							</select>
							</div>
						
						<div class="col-sm-3">
							<select id="item_quality" name="item_quality" onChange="Store.Filter.setQuality(this.value)">
								<option value="ALL" selected>{lang("all_items", "store")}</option>
								<option value="0" class="q0">{lang("poor", "store")}</option>
								<option value="1" class="q1">{lang("common", "store")}</option>
								<option value="2" class="q2">{lang("uncommon", "store")}</option>
								<option value="3" class="q3">{lang("rare", "store")}</option>
								<option value="4" class="q4">{lang("epic", "store")}</option>
								<option value="5" class="q5">{lang("legendary", "store")}</option>
								<option value="6" class="q6">{lang("artifact", "store")}</option>
								<option value="7" class="q7">{lang("heirloom", "store")}</option>
							</select>
						</div>
						<div class="col-sm-3">
							<input class="form-control" type="text" id="filter_name" placeholder="{lang("filter", "store")}" onKeyUp="Store.Filter.setName(this.value)">
						</div>
						<div class="col-sm-3">
							<a href="javascript:void(0)" onClick="Store.Filter.toggleVote(this)" class="nice_button nice_active">
								<img src="{$url}application/images/icons/lightning.png" align="absmiddle"> {lang("vp", "store")}
							</a>

							<a href="javascript:void(0)" onClick="Store.Filter.toggleDonate(this)" class="nice_button nice_active">
								<img src="{$url}application/images/icons/coins.png" align="absmiddle"> {lang("dp", "store")}
							</a>
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
																	<a {if $item.tooltip}href="{$url}item/{$item.realm}/{$item.itemid}" data-realm="{$item.realm}" rel="item={$item.itemid}"{/if} class="item_name q{$item.quality} text-decoration-none">
																		{character_limiter($item.name, 35)}
																	</a>
																</h5>
																
																<p class="card-text text-muted small" style="min-height: 40px; line-height: 1.4;">
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
														<h5 class="card-title text-truncate mb-2">
															<a {if $item.tooltip}href="{$url}item/{$item.realm}/{$item.itemid}" data-realm="{$item.realm}" rel="item={$item.itemid}"{/if} class="item_name q{$item.quality} text-decoration-none">
																{character_limiter($item.name, 35)}
															</a>
														</h5>
														<p class="card-text text-muted small" style="min-height: 40px; line-height: 1.4;">
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