<script type="text/javascript">
	$(document).ready(function()
	{
		function initializeTeleport()
		{
			if(typeof Teleport != "undefined")
			{
				Teleport.User.initialize({$vp}, {$dp});
			}
			else
			{
				setTimeout(initializeTeleport, 50);
			}
		}

		initializeTeleport();
	});
</script>

<div class="container">
	<div class="row">
		
		{$link_active = "teleport"}
		
		{* HORIZONTAL UCP NAVIGATION OVERRIDE *}
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
			<div class="section-header">{lang("teleport_hub", "teleport")}</div>
			<div class="section-body">
				<div class="row g-4">
					<div class="col-sm-12 col-lg-6">
						{if $total}
							{foreach from=$characters item=realm}
								<table class="table table-dark table-striped table-hover table-responsive character-select shadow-sm" style="border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; overflow: hidden;">
									<thead style="background: rgba(0,0,0,0.5);">
										<tr>
											<th scope="col" colspan="3" class="h4">{$realm.realmName}</th>
										</tr>
									</thead>
									<tbody>
										{if $realm.characters}
											{foreach from=$realm.characters item=character}
												<tr class="character-select">
													<td style="width:40px;"><img width="36" height="36" src="{$url}application/images/avatars/{$character.avatar}.gif" data-tip="<img src='{$url}application/images/stats/{$character.class}.gif' align='absbottom'/> {$character.name} (Lv{$character.level})"></td>
													<td>
														<div class="d-block" data-tip="<img src='{$url}application/images/stats/{$character.class}.gif' align='absbottom'/> {$character.name} (Lv{$character.level})">{$character.name}</div>
														<div class="user-points d-block">
															<span class="gold-points">
																<i class="fa-duotone fa-coins"></i>
																{floor($character.money / 10000)} {lang("gold", "teleport")}
															</span>
														</div>
													</td>
													<td class="align-middle text-end">
														<a href="javascript:void(0);" onClick="Teleport.selectCharacter(this, {$realm.realmId}, {$character.guid}, '{$character.name}', {$character.money / 10000}, '{$character.race}')">
															{lang("select", "teleport")}
														</a>
													</td>
												</tr>
											{/foreach}
										{else}
											<tr>
												<td colspan="3" class="text-center py-4">{lang("no_chars", "teleport")}</td>
											</tr>
										{/if}
									</tbody>
								</table>
							{/foreach}
						{/if}
					</div>
					<div class="col-sm-12 col-lg-6 location-col">
						<table class="table table-dark table-striped table-hover table-responsive location-select shadow-sm" style="border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; overflow: hidden;">
							<thead style="background: rgba(0,0,0,0.5);">
								<tr><th colspan="2" class="h5">{lang("teleport_hub", "teleport")} Locations</th></tr>
							</thead>
							<tbody>
								{if $locations}
									{foreach from=$locations item=location}
										<tr class="location-select location" data-realm="{$location.realm}" data-faction="{$location.required_faction}">
											<td class="w-100">
												<span class="d-block">{$location.name}</span>
												<span class="text-muted">{$location.description}</span>
											</td>
											<td class="align-middle">
												<a href="javascript:void(0)" onClick="Teleport.buy({$location.id}, this)">
													{if $location.vpCost}
														<img src="{$url}application/images/icons/lightning.png" align="absmiddle">
														{$location.vpCost} {lang("vp", "teleport")}
													{elseif $location.dpCost}
														<img src="{$url}application/images/icons/coins.png" align="absmiddle">
														{$location.dpCost} {lang("dp", "teleport")}
													{elseif $location.goldCost}
														<img src="{$url}application/images/icons/coins.png" align="absmiddle">
														{$location.goldCost} {lang("gold", "teleport")}
													{else}
														{lang("free", "teleport")}
													{/if}
												</a>
											</td>
										</tr>
									{/foreach}
								{else}
									<tr>
										<td colspan="2" class="text-center py-4">{lang("no_locations", "teleport")}</td>
									</tr>
								{/if}
							</tbody>
						</table>
					</div>
				</div>

			</div>
		</div>
	</div>
</div>