<div class="container">
	<div class="row">
		{$link_active = "settings"}
		{include file="../../ucp/views/ucp_navigation.tpl"}
		
		<div class="col-lg-8 py-lg-5 pb-5 pb-lg-0">
			<div class="section-header">{lang("settings", "ucp")}</div>
			<div class="section-body">

				<form onSubmit="Settings.submitInfo(); return false" id="settings_info" class="page_form">

					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="nickname_field">{lang("nickname", "ucp")}</label>
						<div class="col-sm-9">
							<input class="form-control" type="text" id="nickname_field" name="nickname_field" placeholder="{lang("nickname", "ucp")}" value="{$nickname}">
						</div>
					</div>

					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="location_field">{lang("location", "ucp")}</label>
						<div class="col-sm-9">
							<input class="form-control" type="text" id="location_field" name="location_field" placeholder="{lang("location", "ucp")}" value="{$location}">
						</div>
					</div>

					{if $enable_profile_privacy}
					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="public_profile">{lang("public_profile", "ucp")}</label>
						<div class="col-sm-9">			
							<div class="form-check form-switch mt-2">
								<input class="form-check-input" type="checkbox" id="public_profile" name="public_profile" {if $public_profile == 1}checked{/if}>
								<label class="form-check-label" for="public_profile"><small>{lang("public_profile_desc", "ucp")}</small></label>
							</div>
							<div class="mt-2">
								<a href="{$url}profile/{$id}" target="_blank" class="btn border text-muted-500 hover:text-white dark:border-muted-600 border-muted-300 dark:hover:bg-muted-700 hover:bg-muted-100 hover:text-muted-700 w-full sm:w-auto mt-2">
									<i class="fa-duotone fa-user mr-1"></i> {lang("view_profile", "ucp")}
								</a>
								<small class="text-muted block mt-1"><em>*(Abre una ventana incógnito para testear cómo te ven los demás)</em></small>
							</div>
						</div>
					</div>
					{/if}
					
					{if $show_language_chooser}
						<div class="form-group row">
							<label class="col-sm-3 col-form-label" for="language_field">Website Language</label>
							<div class="col-sm-9">			
							
								<select class="form-select" aria-label="Website Language" name="language_field" id="language_field">
									{foreach from=$languages item=language}
										<option value="{$language}" {if $userLanguage == $language}selected="selected"{/if}>{ucfirst($language)}</option>
									{/foreach}
								</select>
								
							</div>
						</div>
					{/if}
					
					<input class="nice_button mt-3" type="submit" value="{lang("change_information", "ucp")}">

					<div id="settings_info_ajax" class=" text-center mt-3"></div>
				</form>
				
				<hr class="mb-4" />
				
				<form onSubmit="Settings.submit(); return false" id="settings" class="page_form">
				
					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="old_password">{lang("old_password", "ucp")}</label>
						<div class="col-sm-9">
							<input class="form-control" type="password" id="old_password" name="old_password" placeholder="{lang("old_password", "ucp")}" autocomplete="current-password">
						</div>
					</div>
				
					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="new_password">{lang("new_password", "ucp")}</label>
						<div class="col-sm-9">
							<input class="form-control" type="password" id="new_password" name="new_password" placeholder="{lang("new_password", "ucp")}" autocomplete="new-password">
						</div>
					</div>
				
					<div class="form-group row">
						<label class="col-sm-3 col-form-label" for="new_password_confirm">{lang("new_password_confirm", "ucp")}</label>
						<div class="col-sm-9">
							<input class="form-control" type="password" id="new_password_confirm" name="new_password_confirm" placeholder="{lang("new_password_confirm", "ucp")}" autocomplete="new-password">
						</div>
					</div>
					
					<input class="nice_button mt-3" type="submit" value="{lang("change_password", "ucp")}">
					
					<div id="settings_ajax" class="text-center py-3"></div>
				</form>

			</div>
		</div>
	</div>
</div>