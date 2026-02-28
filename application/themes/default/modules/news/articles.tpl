{strip}

{* Module name *}
{$module = 'news'}

{* is single? *}
{$is_single = !isset($single)}

{* Layout *}
{$layout.type = "lg"}
{$layout.file = "{$theme_path}views{$DS}layouts{$DS}box.tpl"}

{foreach from=$articles key=key item=item}
	{* Classes *}
	{$classes = [$module|cat:'-'|cat:$item.id]}

	{if $is_single}
		{$classes[] = 'is-single'}
	{/if}

	{if $item.comments != -1}
		{$classes[] = 'has-comments'}
	{/if}

	{if $item.tags && is_array($item.tags)}
		{$classes[] = 'has-tags'}
	{/if}

	{if $item@first}
		{$classes[] = 'first-item'}
	{/if}

	{if $item@last}
		{$classes[] = 'last-item'}
	{/if}

	{* SEO url *}
	{$item.SEOurl = urlencode(str_replace('/', '-', $item.headline))}

	{* Default thumbnail (only for first item) *}
	{if !$item.type && !$is_single && $item@first}
		{* Set type *}
		{$item.type = 1}

		{* Set thumbnail *}
		{$item.type_content = [{$MY_image_path}|cat:'thumbnails/thumbnail-01.jpg']}
	{/if}

	{* Build head y contenido limpios sin thumbnail *}
	{capture assign=body}
		<div style="padding: 25px; background: rgba(0,0,0,0.15); border-radius: 8px; border-left: 4px solid var(--primary-color, #007bff); width: 100%;">
			<div class="{$module}-head" style="margin-bottom: 15px;">
				<div style="font-size: 1.8rem; font-weight: bold; line-height: 1.3;">
					<a href="{$url}news/view/{$item.id}/{$item.SEOurl}" title="{$item.headline}" style="color: var(--primary-color, #007bff); text-decoration: none;">{$item.headline}</a>
				</div>
				<div style="font-size: 0.95rem; color: #888; margin-top: 8px;">
					<i class="fa fa-user"></i> {lang('posted_by', 'news')} <a href="{$url}profile/{$item.author_id}" data-tip="{lang('view_profile', 'news')}" style="font-weight:bold; color:#fff;">{$item.author}</a> 
					&nbsp; | &nbsp; <i class="fa fa-clock"></i> {$item.date} 
					{if $item.comments != -1} &nbsp; | &nbsp; <a {$item.comments_button_id} href="{$url}news/view/{$item.id}/{$item.SEOurl}" style="color:#007bff;"><i class="fa fa-comments"></i> {lang('comments', 'news')} {$item.comments}</a>{/if}
				</div>
			</div>

			{if $is_single}<div class="divider" style="border-top: 1px solid rgba(255,255,255,0.1); margin: 20px 0;"></div>{/if}

			<div class="{$module}-content" style="font-size: 1.15rem; line-height: 1.6; color: rgba(255,255,255,0.85); margin-bottom: 20px;">
				{if $is_single}{$item.content}{else}{$item.summary}{/if}
			</div>

			{if !$is_single && isset($item.readMore) && $item.readMore}
				<div class="{$module}-buttons" style="margin-top: 20px;">
					<a href="{$url}news/view/{$item.id}/{$item.SEOurl}" class="nice_button" title="{lang('read_more', 'news')}">{lang('read_more', 'news')} <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-right-short" viewBox="0 0 16 16"><path fill-rule="evenodd" d="M4 8a.5.5 0 0 1 .5-.5h5.793L8.146 5.354a.5.5 0 1 1 .708-.708l3 3a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708-.708L10.293 8.5H4.5A.5.5 0 0 1 4 8z"/></svg></a>
				</div>
			{/if}

			{if $item.tags && is_array($item.tags)}
				<div class="{$module}-tags" style="margin-top: 20px;">
					{foreach from=$item.tags item=tag}
						<a href="{$url}/news/{$tag.name}" style="background: rgba(255,255,255,0.1); padding: 5px 15px; border-radius: 20px; font-size: 0.9rem; margin-right: 10px;">{$tag.name}</a>
					{/foreach}
				</div>
			{/if}
		</div>
	{/capture}

	{* RENDER NEWS *}
	{include file=$layout.file _type=$layout.type _module=$module _head=$head _body=$body _classes=$classes}

	{* RENDER COMMENTS *}
	{if $is_single && $item.comments != -1}<div {$item.comments_id} class="{$module}-comments"></div>{/if}
{/foreach}

{if $pagination}{str_replace('class="pagination', 'class="pagination '|cat:$module|cat:'-pagination', $pagination)}{/if}

{/strip}