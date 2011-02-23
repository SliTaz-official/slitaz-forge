<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>SliTaz Tank</title>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="slitaz tank server" />
	<meta name="robots" content="index, nofollow" />
	<meta name="author" content="SliTaz Contributors" />
	<link rel="shortcut icon" href="favicon.ico" />
	<link rel="stylesheet" type="text/css" href="slitaz.css" />
</head>
<body>

<!-- Header -->
<div id="header">
    <a href="http://tank.slitaz.org/"><img id="logo"
		src="pics/website/logo.png" 
		title="tank.slitaz.org" alt="tank.slitaz.org" /></a>
    <p id="titre">#!/Tank</p>
</div>

<!-- Content -->
<div id="content-full">

<!-- Block begin -->
<div class="block">
	<!-- Nav block begin -->
	<div id="block_nav">
		<h3><img src="pics/website/development.png" alt="png" />Devel corner</h3>
		<ul>
			<li><a href="http://www.slitaz.org/en/devel/">Website/devel</a></li>
			<li><a href="http://labs.slitaz.org/">Laboratories</a></li>
			<li><a href="http://hg.slitaz.org/">Mercurial Repos</a></li>
			<li><a href="http://bb.slitaz.org/">Build Bot</a></li>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://people.slitaz.org/">SliTaz People</a></li>
		</ul>
	<!-- Nav block end -->
	</div>
	<!-- Top block begin -->
	<div id="block_top">
		<h1>Codename: tank</h1>
		<p>
			This is the SliTaz GNU/Linux main server and build host. The server runs
			naturally SliTaz (stable) and provides some services to all contributors
			such as: secure access, disk space, a public directory, cron jobs and the
			<a href="http://bb.slitaz.org/">Build Bot</a>.
		</p>
		<p>
			Tank CPU is a AMD Dual Core 2 GHz - 2GB RAM - Located next to Lausanne,
			Switzerland and offered by Thomas Hinterberger and hosted by Christophe
			Lincoln. Tank is also monitored by RRDtool which provides 
			<a href="graphs.php">graphical stats</a>.
		</p>
	<!-- Top block end -->
	</div>
<!-- Block end -->
</div>

<h2><a href="graphs.php"><img 
	style="vertical-align: middle; padding: 0 4px 0 0;"
	title="Tank RRDtool graphs" alt="graphs"
    src="pics/website/monitor.png" /></a>System stats</h2>

<h4>Uptime</h4>

<pre class="package">
<?php
system("uptime | sed 's/^\s*//'");
?>
</pre>

<h4>Disk usage</h4>
<pre class="package">
<?php
system("df -h | sed '/^rootfs/d' | grep  '\(^/dev\|Filesystem\)'");
?>
</pre>

<h4>Network</h4>
<pre class="package">
<?php
system("ifconfig eth0 | awk '{ if (/X packet/ || /X byte/) print }' | sed 's/^\s*//'");
?>
</pre>

<h2><a href="/stats/awstats.pl?config=www.slitaz.org"><img
	style="vertical-align: middle; padding: 0 4px 0 0;"
	title="Tank Virtual hosts" alt="vhosts"
    src="pics/website/vhosts.png" /></a>Virtual hosts</h2>

<ul>
	<li><a href="http://www.slitaz.org/">www.slitaz.org</a> - SliTaz Website.
	(<a href="/stats/awstats.pl?config=www.slitaz.org">stats</a>)</li>
	<li><a href="http://doc.slitaz.org/">doc.slitaz.org</a> - Documentation platform.</li>
	<li><a href="http://pkgs.slitaz.org/">pkgs.slitaz.org</a> - Packages Web interface.</li>
	<li><a href="http://boot.slitaz.org/">boot.slitaz.org</a> - gPXE Web boot.</li>
	<li><a href="http://hg.slitaz.org/">hg.slitaz.org</a> - Mercurial repositories.</li>
	<li><a href="http://bb.slitaz.org/">bb.slitaz.org</a> - SliTaz Build Bot.</li>
	<li><a href="http://people.slitaz.org/">people.slitaz.org</a> - SliTaz People stuff.</li>
	<li><a href="http://pro.slitaz.org/">pro.slitaz.org</a> - SliTaz Professional services.</li>
</ul>

<h2><img
	style="vertical-align: middle; padding: 0 4px 0 0;"
	title="Erjo Virtual hosts" alt="vhosts"
    src="pics/website/vhosts.png" />Other hosts</h2>

<p>
	These services are hosted by some individual sponsors who gracefully offer
	resources to the SliTaz project.
</p>
<ul>
	<li><a href="http://forum.slitaz.org/">forum.slitaz.org</a> - SliTaz support forum.</li>
	<li><a href="http://labs.slitaz.org/">labs.slitaz.org</a> - SliTaz Laboratories.</li>
	<li><a href="http://mirror.slitaz.org/">mirror.slitaz.org</a> - SliTaz main mirror and replicas.
		(<a href="http://mirror.slitaz.org/info/">more...</a>)</li>
	<li><a href="http://scn.slitaz.org/">scn.slitaz.org</a> - Community platform.</li>
	<li><a href="http://pizza.slitaz.org/">pizza.slitaz.org</a> - SliTaz flavor builder.</li>
</ul>
    
<h2><a href="http://mirror.slitaz.org/info/"> <img
	style="vertical-align: middle; padding: 0 4px 0 0;"
	src="pics/website/vhosts.png"
	title="Secondary mirrors" alt="mirrors" /></a>Mirrors</h2>
<p>
	These mirrors are updated using the url <b>rsync://mirror.slitaz.org/slitaz/</b>
	(<a href="http://mirror.slitaz.org/awstats.pl?config=rsync">stats</a>)
</p>
<ul>
	<li><a href="http://mirror.switch.ch/ftp/mirror/slitaz/">
		http://mirror.switch.ch/ftp/mirror/slitaz/</a> or
		<a href="ftp://mirror.switch.ch/mirror/slitaz/">
		ftp://mirror.switch.ch/mirror/slitaz/</a></li>
	<li><a href="http://download.tuxfamily.org/slitaz/">
		http://download.tuxfamily.org/slitaz/</a></li>
	<li><a href="http://www.linuxembarque.com/slitaz/mirror/">
		http://www.linuxembarque.com/slitaz/mirror/</a></li>
	<li><a href="http://mirror.lupaworld.com/slitaz/">
		http://mirror.lupaworld.com/slitaz/</a></li>
	<li><a href="http://slitaz.c3sl.ufpr.br/">
		http://slitaz.c3sl.ufpr.br/</a> or
		<a href="ftp://slitaz.c3sl.ufpr.br/slitaz/">
		ftp://slitaz.c3sl.ufpr.br/slitaz/</a></li>
	<li><a href="http://slitaz.mirror.garr.it/mirrors/slitaz/">
		http://slitaz.mirror.garr.it/mirrors/slitaz/</a></li>
	<li><a href="http://www.gtlib.gatech.edu/pub/slitaz/">
		http://www.gtlib.gatech.edu/pub/slitaz/</a> or
		<a href="ftp://ftp.gtlib.gatech.edu/pub/slitaz/">
		ftp://ftp.gtlib.gatech.edu/pub/slitaz/</a></li>
		<li><a href="ftp://ftp.pina.si/slitaz/">
		ftp://ftp.pina.si/slitaz/</a></li>
</ul>

<!-- End of content -->
</div>

<!-- Footer -->
<div id="footer">
	<div class="right_box">
	<h4>SliTaz Network</h4>
		<ul>
			<li><a href="http://doc.slitaz.org/">Documentation</a></li>
			<li><a href="http://forum.slitaz.org/">Support Forum</a></li>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://labs.slitaz.org/">Laboratories</a></li>
			<li><a href="http://twitter.com/slitaz">SliTaz on Twitter</a></li>
			<li><a href="http://distrowatch.com/slitaz">SliTaz on DistroWatch</a></li>
		</ul>
	</div>
	<h4>SliTaz Website</h4>
	<ul>
		<li><a href="#header">Top of the page</a></li>
		<li>Copyright &copy; <?php echo date('Y'); ?>
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
