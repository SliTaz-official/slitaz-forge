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
	<?php html_msgarea()?>
<!-- Access -->
<div id="access">
<?php
$translation = &plugin_load('helper','translation');
echo $translation->showTranslations();
?>
</div>
    <a href="http://doc.slitaz.org/"><img id="logo"
		src="<?php echo DOKU_TPL?>images/logo.png"
		title="doc.slitaz.org" alt="doc.slitaz.org" /></a>
    <p id="titre">#!/Doc/<?php tpl_link(wl($ID,'do=backlink'),tpl_pagetitle($ID,true),'title="'.$lang['btn_backlink'].'"')?>
    </p>
</div>

<!-- Content -->
<div id="content">

<!-- Block begin -->
<div class="block">
	<!-- Nav block begin -->
	<div id="block_nav">
		<h3><img src="<?php echo DOKU_TPL?>images/tools.png" alt=".png" />Wiki Tools</h3>
		<div><?php tpl_button('recent')?></div>
		<div><?php tpl_button('subscription')?></div>
		<div><?php tpl_button('admin')?></div>
		<div><?php tpl_button('profile')?></div>
		<div><?php tpl_button('login')?></div>
	<!-- Nav block end -->
	</div>
	<!-- Top block begin -->
	<div id="block_top">
		<p>
			The central place for all SliTaz documentation.
		</p>
		<div><?php tpl_searchform()?>
		</div>
		<h3><img src="<?php echo DOKU_TPL?>images/tools.png" alt=".png" />Page Tools</h3>
		<div><?php tpl_button('edit')?></div>
		<div><?php tpl_button('history')?></div>
		<div><?php tpl_button('index')?></div>
	<!-- Top block end -->
	</div>
<!-- Block end -->
</div>

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

<!-- End of content -->
</div>

<!-- End of: class="dokuwiki" -->
</div>

<!-- Footer -->
<div id="footer">
	<div class="right_box">
	<h4>SliTaz Network</h4>
		<ul>
			<li><a href="http://www.slitaz.org/">Main Website</a></li>
			<li><a href="http://forum.slitaz.org/">Support Forum</a></li>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://labs.slitaz.org/">Laboratories</a></li>
			<li><a href="http://pkgs.slitaz.org/">Packages</a></li>
			<li><a href="http://boot.slitaz.org/">Web Boot</a></li>
		</ul>
	</div>
	<h4>SliTaz Website</h4>
	<ul>
		<li><a href="#header">Top of the page</a></li>
		<li>Copyright &copy; <?php echo date('Y'); ?></span>
			<a href="http://www.slitaz.org/">SliTaz</a> -
			<a href="http://www.gnu.org/copyleft/fdl.html">GNU FDL</a></li>
		<li><a href="http://www.slitaz.org/en/about/">About the project</a></li>
		<li><a href="http://www.slitaz.org/netmap.php">Network Map</a></li>
		<li>Page modified the <?php echo (date( "d M Y", getlastmod())); ?></li>
		<li>
			<a <?php echo $tgt?> href="http://validator.w3.org/check/referer" title="Valid XHTML 1.0">
			<img src="<?php echo DOKU_TPL; ?>images/button-xhtml.png" width="80" height="15" alt="Valid XHTML 1.0" /></a>
			<a <?php echo $tgt?> href="http://wiki.splitbrain.org/wiki:dokuwiki" title="Driven by DokuWiki">
			<img src="<?php echo DOKU_TPL; ?>images/button-dw.png" width="80" height="15" alt="Driven by DokuWiki" /></a>
		</li>
	</ul>
</div>

<div class="no">
	<?php /* provide DokuWiki housekeeping, required in all templates */
	tpl_indexerWebBug() ?>
</div>

</body>
</html>
