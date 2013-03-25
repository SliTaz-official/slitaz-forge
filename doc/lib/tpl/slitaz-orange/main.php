<?php
/**
 * DokuWiki SliTaz Template - With code from the default theme by
 * Andreas Gohr <andi@splitbrain.org>
 * 
 */

// must be run from within DokuWiki
if (!defined('DOKU_INC')) die();

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<?php echo $conf['lang']?>"
 lang="<?php echo $conf['lang']?>" dir="<?php echo $lang['direction']?>">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>
    <?php tpl_pagetitle()?>
    [<?php echo strip_tags($conf['title'])?>]
  </title>
  <?php tpl_metaheaders()?>
  <link rel="shortcut icon" href="<?php echo DOKU_TPL?>images/favicon.ico" />
</head>
<body>

<div class="dokuwiki">

<!-- Header -->
<div id="header">
	<div id="logo"></div>
	<!-- SliTaz Network -->
	<div id="network">
		<a href="http://www.slitaz.org/">
			<img src="<?php echo DOKU_TPL?>images/home.png" alt="[ Home ]" /></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://slitaz.pro/">Pro</a>
		<a href="http://slitaz.spreadshirt.net/">Shop</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	</div>
	<h1><a href="./">SliTaz Doc</a></h1>
	<!-- <?php tpl_link(wl($ID,'do=backlink'),tpl_pagetitle($ID,true),'title="'.$lang['btn_backlink'].'"')?> -->
</div>

<!-- SliTaz Block -->
<div id="block">
	<?php html_msgarea()?>
	<!-- Languages -->
	<div id="lang">
	<?php
		$translation = &plugin_load('helper','translation');
		echo $translation->showTranslations();
	?>
	</div>
	<div style="text-align: justify; width: 60%; padding: 0 10px 0 0;">
		SliTaz GNU/Linux official and community documentation wiki.
	</div>
	<div class="tools">
		<img src="<?php echo DOKU_TPL?>images/tools.png" alt=".png" />
		
		<div style="float: right; text-align: right;">
			<?php tpl_button('edit')?>
			<?php tpl_searchform()?>
		</div>
		<?php tpl_button('recent')?>
		<?php tpl_button('subscription')?>
		<?php tpl_button('admin')?>
		<?php tpl_button('profile')?>
		<?php tpl_button('login')?>
	</div>
</div>

<!-- Content -->
<div id="content">

<?php flush()?>

<!-- wikipage start -->
<?php tpl_content()?>
<!-- wikipage stop -->

<div class="clearer">&nbsp;</div>
<?php flush()?>

<div class="meta">
  <div class="user">
	<?php tpl_userinfo()?>
  </div>
  <div class="doc">
	<?php tpl_pageinfo()?>
  </div>
</div>

<div style="border-top: 1px solid #eaeaea;">
	<div style="float: right; text-align: right;">
		<?php tpl_button('edit')?>
		<?php tpl_button('history')?>
	</div>
	<?php tpl_button('recent')?>
	<?php tpl_button('index')?>
</div>

<!-- End of content -->
</div>

<!-- End of: class="dokuwiki" -->
</div>

<!-- Footer -->

<script type="text/javascript" src="<?php echo DOKU_TPL?>qrcode.js"></script>

<div id="footer">
	Copyright &copy; <span class="year"></span>
	<a href="http://www.slitaz.org/">SliTaz</a> - Network:
	<a href="http://scn.slitaz.org/">Community</a>
	<a href="http://doc.slitaz.org/">Doc</a>
	<a href="http://forum.slitaz.org/">Forum</a>
	<a href="http://pkgs.slitaz.org/">Packages</a>
	<a href="http://bugs.slitaz.org">Bugs</a>
	<a href="http://hg.slitaz.org/">Hg</a>
	<p>
		<img src="#" alt="SliTaz @" onmouseover="this.title = location.href"
		 onclick="this.src = QRCode.generatePNG(location.href, {ecclevel: 'H'})" />
		<a href="http://twitter.com/slitaz">Twitter</a>
		<a href="http://www.facebook.com/slitaz">Facebook</a>
		<a href="http://distrowatch.com/slitaz">Distrowatch</a>
		<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a>
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</p>
</div>

<div class="no">
	<?php /* provide DokuWiki housekeeping, required in all templates */
	tpl_indexerWebBug() ?>
</div>

</body>
</html>
