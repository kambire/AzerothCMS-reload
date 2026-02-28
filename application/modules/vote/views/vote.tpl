<div class="container">
	<div class="row">
		
		{$link_active = "vote"}
		
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
			<div class="section-header">Voting <span>Panel</span></div>
			<div class="section-body">
			<div class="alert alert-info firefox text-center" style="display:none;" role="alert">
			  Please allow pop-up windows from this website to be able to vote.
			</div>
			
				<div class="row row-cols-1 row-cols-sm-2 row-cols-md-4">
					{if $vote_sites}
						{foreach from=$vote_sites item=vote_site}
							<div class="col mb-3">
								<div class="card h-100 cursor-pointer card-hover bg-dark text-white {if !$vote_site.canVote}card-disabled{/if}" style="border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.5); transition: transform 0.2s;" {if $vote_site.canVote}onClick="Vote.open({$vote_site.id}, {$vote_site.hour_interval});"{/if}>
									<div class="card-header text-center border-bottom border-secondary" style="background: rgba(0,0,0,0.4);">
										{if $vote_site.vote_image}
											<img src="{$vote_site.vote_image}" alt="{$vote_site.vote_sitename}" width="100%" class="rounded">
										{else}
											<h5 class="mb-0 text-uppercase fw-bold text-light">{$vote_site.vote_sitename}</h5>
										{/if}
									</div>
									<div class="card-body text-center d-flex flex-column align-items-center justify-content-center">
										<div class="card-text h-100 py-3 d-flex justify-content-center align-items-center" id="vote_field_{$vote_site.id}">
											{if $vote_site.canVote}
												{form_open("vote/site/", $formAttributes)}
													<div class="h4">
														{lang('vote_now', 'vote')}
													</div>
													<div class="fst-italic">
													{$vote_site.points_per_vote}
													{if $vote_site.points_per_vote > 1}
														{lang("voting_points", "vote")}
													{else}
														{lang("voting_point", "vote")}
													{/if}
													</div>
													
													<input type="hidden" name="id" value="{$vote_site.id}" />
												</form>
											{else}
												<div class="h4">
													{$vote_site.nextVote} {lang('remaining', 'vote')}
												</div>
											{/if}
										</div>
									</div>
								</div>
							</div>
						{/foreach}
					{/if}
				</div>
			</div>
			
		</div>
	</div>
</div>
