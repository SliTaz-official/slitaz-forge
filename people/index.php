<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>SliTaz People</title>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="slitaz people" />
	<meta name="keywords" lang="en" content="slitaz network, slitaz developpers, slitaz contributors" />
	<meta name="robots" content="index, follow, all" />
    <meta name="modified" content="<?php echo (date( "Y-m-d H:i:s", getlastmod())); ?>" />
	<meta name="author" content="Christophe Lincoln"/>
	<link rel="shortcut icon" href="favicon.ico" />
	<link rel="stylesheet" type="text/css" href="slitaz.css" />
</head>
<body>

<!-- Header -->
<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">
			<img src="images/network.png" alt="network.png" /></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://labs.slitaz.org/issues">Bugs</a>
		<a href="http://hg.slitaz.org/">Hg</a>
	</div>
	<h1><a href="http://people.slitaz.org/">SliTaz People</a></h1>
</div>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="images/development.png" alt="development.png" />Developers Corner</h4>
		<ul>
			<li><a href="http://www.slitaz.org/en/devel/">Website devel</a></li>
			<li><a href="http://scn.slitaz.org/">Community</a></li>
			<li><a href="http://labs.slitaz.org/">Laboratories</a></li>
			<li><a href="http://hg.slitaz.org/">Mercurial Repos</a></li>
			<li><a href="http://bb.slitaz.org/">Build Bot</a></li>
			<li><a href="http://tank.slitaz.org/">Tank Server</a></li>
		</ul>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>People</h4>
		<p>
			Each contributor who has access to the project main server,
			code name <a href="http://tank.slitaz.org/">Tank</a>, can 
			have a public directory to put personal stuff related to SliTaz.
			This Public directory can be reached with URLs in the form of: 
			http://people.slitaz.org/~contributors/. More information on 
			<a href="http://www.slitaz.org/">SliTaz Website</a> and
			<a href="http://labs.slitaz.org/">SliTaz Labs</a>.
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

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

<div style="margin-top: 100px;"></div>

<!-- Footer -->
<div id="footer">
	Copyright &copy; <span class="year"></span>
	<a href="http://www.slitaz.org/">SliTaz</a> - Network:
	<a href="http://scn.slitaz.org/">Community</a>
	<a href="http://doc.slitaz.org/">Doc</a>
	<a href="http://forum.slitaz.org/">Forum</a>
	<a href="http://pkgs.slitaz.org/">Packages</a>
	<a href="http://labs.slitaz.org/issues">Bugs</a>
	<a href="http://hg.slitaz.org/">Hg</a>
	<p>
		SliTaz @
		<a href="http://twitter.com/slitaz">Twitter</a>
		<a href="http://www.facebook.com/slitaz">Facebook</a>
		<a href="http://distrowatch.com/slitaz">Distrowatch</a>
		<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a>
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</p>
</div>

</body>
</html>
