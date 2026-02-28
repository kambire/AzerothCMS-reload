{strip}

{* Define: News *}
{$news = [
	1 => false,
	2 => false,
	3 => false
]}

{* Define: Iterator *}
{$iterator = 0}

{* Define: is single *}
{$is_single = !isset($single)}

{* Format articles *}
{foreach from=$articles key=key item=item}
	{*----------------------------------------------------------------------*}
	{*---------------------------- FORMAT.START ----------------------------*}
	{*----------------------------------------------------------------------*}

	{* Define: SEOurl *}
	{$item.SEOurl = urlencode(str_replace('/', '-', $item.headline))}

	{* Define: thumbnail *}
	{$item.thumbnail = ($item.type && $item.type == '1' && isset($item.type_content[0])) ? ($url|cat:'writable/uploads/news/'|cat:$item.type_content[0]) : false}

	{* Set default thumbnail *}
	{if !$item.thumbnail}{$item.thumbnail = ($iterator == 0) ? ($MY_image_path|cat:'thumbnails/thumbnail-01.jpg') : ($MY_image_path|cat:'thumbnails/thumbnail-02.jpg')}{/if}

	{*----------------------------------------------------------------------*}
	{*----------------------------- FORMAT.END -----------------------------*}
	{*----------------------------------------------------------------------*}

	{*......................................................................*}

	{*----------------------------------------------------------------------*}
	{*--------------- GATHER DATA.START (handles front page) ---------------*}
	{*----------------------------------------------------------------------*}

	{if !$is_single}
		{* Build: Article *}
		{capture append=item}
			<div class="item type-{$ci_module} -list-view" style="display: flex; flex-direction: column; padding: 25px; margin-bottom: 20px; background: rgba(0,0,0,0.4); border-radius: 8px; border-left: 4px solid var(--primary-color, #007bff);">
				<h2 hidden>{$item.headline}</h2>

				{* Article: Info *}
				<div class="item-info" style="width: 100%;">
					{* Info: Title *}
					<a href="{$url}news/view/{$item.id}/{$item.SEOurl}" class="info-title text-ellipsis" title="{$item.headline}" style="font-size: 1.8rem; font-weight: bold; padding-bottom: 10px; display: block; color: var(--primary-color, #007bff); text-decoration: none;">{$item.headline}</a>

					{* Info: Date *}
					<div style="font-size: 0.9rem; color: #aaa; margin-bottom: 15px;">
						<i class="fa fa-clock"></i> <time datetime="{$item.date}" class="info-date" title="{$item.date}">{$item.date}</time>
						&nbsp; | &nbsp; <i class="fa fa-user"></i> {$item.author}
					</div>

					{* Info: Summary *}
					<div class="info-summary" style="font-size: 1.1rem; line-height: 1.6; color: rgba(255,255,255, 0.82); margin-bottom: 20px;">{strip_tags($item.summary)}</div>

					{* Info: Buttons *}
					<div class="info-buttons">
						<a href="{$url}news/view/{$item.id}/{$item.SEOurl}" class="btn-blue" title="{lang('read_more', 'news')}">{lang('read_more', 'news')}</a>
					</div>
				</div>
			</div>
		{/capture}

		{* Gather: Article *}
		{$news[1] = $news[1]|cat:$item[0]}
	{/if}

	{*----------------------------------------------------------------------*}
	{*---------------- GATHER DATA.END (handles front page) ----------------*}
	{*----------------------------------------------------------------------*}

	{*......................................................................*}

	{*----------------------------------------------------------------------*}
	{*--------------- GATHER DATA.START (handles single page) --------------*}
	{*----------------------------------------------------------------------*}

	{if $is_single}
		{* Build: Article *}
		{capture append=item}
			<div class="item type-{$ci_module} -full" style="padding: 25px; background: rgba(0,0,0,0.4); border-radius: 8px;">
				<h2 hidden>{$item.headline}</h2>

				{* Article: Head *}
				<div class="item-head" style="margin-bottom: 25px; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 15px;">
					<a href="{$url}news/view/{$item.id}/{$item.SEOurl}" class="head-title text-ellipsis" title="{$item.headline}" style="font-size: 2.5rem; font-weight: bold; color: var(--primary-color, #007bff);">{$item.headline}</a>
					<div class="head-metadata" style="margin-top: 10px; font-size: 1rem; color: #aaa;">
						{lang('posted_by', 'news')} <a href="{$url}profile/{$item.author_id}" data-tip="{lang('view_profile', 'news')}" style="font-weight: bold; color: #fff;">{$item.author}</a> {lang('on', 'news')} {$item.date}
					</div>
				</div>

				{* Article: Body *}
				<div class="item-body">
					<div class="body-content" style="font-size: 1.15rem; line-height: 1.7;">{$item.content}</div>

					{if $item.tags && is_array($item.tags)}
						<div class="body-tags" style="margin-top: 30px;">
							{foreach from=$item.tags item=tag}
								<a href="{$url}/news/{$tag.name}" style="background: rgba(255,255,255,0.1); padding: 5px 15px; border-radius: 20px; font-size: 0.9rem; margin-right: 10px;">{$tag.name}</a>
							{/foreach}
						</div>
					{/if}

					{if $item.comments != -1}<div {$item.comments_id} class="body-comments" news-comments style="margin-top: 40px;"></div>{/if}
				</div>
			</div>
		{/capture}

		{* Gather: Article *}
		{$news = $item[0]}
	{/if}

	{*----------------------------------------------------------------------*}
	{*---------------- GATHER DATA.END (handles single page) ---------------*}
	{*----------------------------------------------------------------------*}

	{$iterator = $iterator + 1}
{/foreach}

<div class="page-{$ci_module}">
	{if !$is_single}<div class="page-head -type-home text-ellipsis" title="{lang('news_pageTitle', 'theme')}">{formatTitle title=lang('news_pageTitle', 'theme')}</div>{/if}

	<div class="page-body">
		<div class="{$ci_module}-items">
			{if $is_single}
				{$news}
			{else}
				<div class="news-list-container" style="display: flex; flex-direction: column; gap: 20px;">
					{$news[1]}
				</div>
			{/if}
		</div>

		{if $pagination}{str_replace('class="pagination', 'class="pagination '|cat:$ci_module|cat:'-pagination', $pagination)}{/if}
	</div>
</div>

{/strip}