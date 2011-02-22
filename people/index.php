<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>SliTaz People</title>
    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
    <meta name="description" content="SliTaz contributors stuff" />
    <meta name="robots" content="index, nofollow" />
    <meta name="expires" content="never" />
    <meta name="modified" content="<?php echo (date( "Y-m-d H:i:s", getlastmod())); ?>" />
    <meta name="publisher" content="www.slitaz.org" />
    <link rel="shortcut icon" href="favicon.ico" />
    <link rel="stylesheet" type="text/css" href="slitaz.css" />
    <link rel="Content" href="#content" />
</head>
<body>

<!-- Header -->
<div id="header">
	<!-- Access -->
	<div id="access"></div>
    <!-- Logo -->
	<a href="http://people.slitaz.org/"><img id="logo"
		src="pics/website/logo.png" 
		title="people.slitaz.org" alt="people.slitaz.org" /></a>
	<p id="titre">#!/People</p>
</div>

<!-- Content -->
<div id="content-full">

<!-- Block begin -->
<div class="block">
	<!-- Nav block begin -->
	<div id="block_nav" style="min-height: 200px;">
		<h3><img src="pics/website/development.png" alt="png" />Devel corner</h3>
		<ul>
			<li><a href="http://www.slitaz.org/en/devel/">Website/devel</a></li>
			<li><a href="http://labs.slitaz.org/">Laboratories</a></li>
			<li><a href="http://hg.slitaz.org/">Mercurial Repos</a></li>
			<li><a href="http://bb.slitaz.org/">Build Bot</a></li>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://pkgs.slitaz.org/">Packages</a></li>
			<li><a href="http://tank.slitaz.org/">Tank Server</a></li>
		</ul>	
	<!-- Nav block end -->
	</div>
	<!-- Top block begin -->
	<div id="block_top" style="min-height: 200px;">
		<h1>people.slitaz.org</h1>
		<p>
			Each contributor who has access to the project main server,
			code name <a href="http://tank.slitaz.org/">Tank</a>, can 
			have a public directory to put personal stuff related to SliTaz.
			This Public directory can be reached with URLs in the form of: 
			http://people.slitaz.org/~contributors/. More information on 
			<a href="http://www.slitaz.org/">SliTaz Website</a> and
			<a href="http://labs.slitaz.org/">SliTaz Labs</a>.
		</p>
	<!-- Top block end -->
	</div>
<!-- Block end -->
</div>

<h2>SliTaz people</h2>

<ul>
<?php
if ($handle = opendir('/home')) {
	while (false !== ($dir = readdir($handle))) {
		if ($dir != "." && $dir != "..") {
			$pub = "/home/$dir/Public";
			$user = "$dir";
			if (file_exists($pub)) {
			echo "	<li><a href=\"/~$user/\">$user</a></li>\n";
			}
		}
	}
	closedir($handle);
}
?>
</ul>

<!-- End of content -->
</div>

<!-- Footer -->
<div id="footer">
	<div class="right_box">
	<h4>SliTaz Network</h4>
		<ul>
			<li><a href="http://www.slitaz.org/">Main Website</a></li>
			<li><a href="http://doc.slitaz.org/">Documentation</a></li>
			<li><a href="http://forum.slitaz.org/">Support Forum</a></li>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://labs.slitaz.org/">Laboratories</a></li>
			<li><a href="http://twitter.com/slitaz">SliTaz on Twitter</a></li>
			<li><a href="http://distrowatch.com/slitaz">SliTaz on DistroWatch</a></li>
		</ul>
	</div>
	<h4>Informations</h4>
	<ul>
		<li>Copyright &copy; <span class="year"></span>
			<a href="http://www.slitaz.org/">SliTaz</a></li>
		<li><a href="http://www.slitaz.org/en/about/">About the project</a></li>
		<li><a href="http://www.slitaz.org/netmap.php">Network Map</a></li>
		<li>Page modified the <?php echo (date( "d M Y", getlastmod())); ?></li>
		<li><a href="http://validator.w3.org/check?uri=referer"><img
		src="pics/website/xhtml10.png" alt="Valid XHTML 1.0"
		title="Code validé XHTML 1.0"
		style="width: 80px; height: 15px; vertical-align: middle;" /></a></li>
	</ul>
</div>

</body>
</html>
