{strip}

{* is single? *}
{$is_single = !isset($single)}

{* Required css codes *}
{if $is_single}<style type="text/css">[content] > .container > .row { display: block; } [mainbar] { width: 100%; max-width: 100%; } [notifications], [sidebar], [widgets] { display: none; }</style>{/if}

<div class="news-header">
	<div class="row">
		<div class="col-sm-12">
			{if $is_single}
				<a href="{$url}news" class="nice_button" title="See all news">See all news</a>
			{else}
				<h3 class="header-text" title="NEWS">{str_replace('&', '<span>&</span>', NEWS)}</h3>
			{/if}
		</div>
	</div>
</div>

{foreach from=$articles key=key item=article}
	<article class="pagebody news-article {if $is_single}is-single{/if} {if $article.comments != -1}has-comments{/if} {if $article.tags}has-tags{/if} {if $item@first}first-item{/if} {if $item@last}last-item{/if}">
		<div glow><div glow-lines></div></div>

		<div class="row" style="margin: 0;">
			{* MODO LISTA SIMPLIFICADO Y AGRANDADO *}
			<div class="col-md-12" style="padding: 25px; background: rgba(0,0,0,0.15); border-radius: 8px; border-left: 4px solid var(--primary-color, #007bff);">
				<div class="article-head" style="margin-bottom: 15px;">
					<div class="article-title text-ellipsis" style="font-size: 1.8rem; font-weight: bold; line-height: 1.3;">
						<a href="{$url}news/view/{$article.id}" title="{$article.headline}" style="color: var(--primary-color, #007bff); text-decoration: none;">{$article.headline}</a>
					</div>
					<div class="article-metadata" style="font-size: 0.95rem; color: #888; margin-top: 8px;">
						<i class="fa fa-user"></i> {lang('posted_by', 'news')} <a href="{$url}profile/{$article.author_id}" data-tip="{lang('view_profile', 'news')}" style="font-weight:bold; color:#fff;">{$article.author}</a> 
						&nbsp; | &nbsp; <i class="fa fa-clock"></i> <time datetime="{$article.date}">{date('F j, Y', strtotime($article.date))}</time> 
						{if $is_single && $article.comments != -1} &nbsp; | &nbsp; <a {$article.link} {$article.comments_button_id} style="color:#007bff;"><i class="fa fa-comments"></i> {lang('comments', 'news')} {$article.comments}</a>{/if}
					</div>
				</div>

				{if $is_single}<div class="divider" style="border-top: 1px solid rgba(255,255,255,0.1); margin: 20px 0;"></div>{/if}

				<div class="article-body">
					<div class="article-content" style="font-size: 1.15rem; line-height: 1.6; color: rgba(255,255,255,0.85);">
						{if isset($article.summary) && !$is_single}
							{$article.summary}
						{else}
							{$article.content}
						{/if}
					</div>
				</div>

				{if isset($article.readMore) && $article.readMore && !$is_single}
					<div class="article-foot" style="margin-top: 20px;">
						<a href="{$url}news/view/{$article.id}" class="nice_button btn-readmore" title="{lang("read_more", "news")}">
							{lang("read_more", "news")} <i class="icon-readmore"></i>
						</a>
					</div>
				{/if}
			</div>
		</div>
	</article>

	{if $is_single && $article.comments != -1}<div class="news-comments" {$article.comments_id}></div>{/if}
{/foreach}

{if $pagination}{$pagination}{/if}

{/strip}

<script type="text/javascript">
	$('.news-carousel').owlCarousel({
		'items': 1,
		"dots": true,
		"loop": false,
		"margin": 10,
		"nav": false,
	})
</script>