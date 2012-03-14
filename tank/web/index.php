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
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">
			<img src="images/home.png" alt="[ Home ]" /></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://pro.slitaz.org/">Pro</a>
		<a href="http://slitaz.spreadshirt.net/">Shop</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/">Hg</a>
		<a href="http://cook.slitaz.org/">BB</a>
	</div>
	<h1><a href="http://tank.slitaz.org/">SliTaz Tank</a></h1>
</div>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="images/server.png" alt="[ Server ]" />Project servers</h4>
		<ul>
			<li><a href="http://chub.slitaz.org/">Chub server</a></li>
			<li><a href="http://mirror.slitaz.org/">Mirror server</a></li>
		</ul>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Codename: tank</h4>
		<p>
			This is the SliTaz GNU/Linux main server and build host. 
			The server runs naturally SliTaz and provides some services
			to all contributors such as: secure access, disk space, a 
			public directory or cron jobs.
		</p>
		<p>
			Tank CPU is a <?php system("sed -e '/^model name/!d;s/.*Intel(R) //;" .         
			"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //' </proc/cpuinfo |" .
			" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
			"if (n == 4) printf \"quad \"; print s }' ")?> -
			<?php system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
			"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
			"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")?>  - Located next to Lausanne,
			Switzerland. Tank is also monitored by RRDtool which provides 
			<a href="graphs.php">graphical stats</a>.
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

<h2><a href="graphs.php"><img 
	style="vertical-align: middle; padding: 0 4px 0 0;"
	title="Tank RRDtool graphs" alt="graphs"
    src="images/monitor.png" /></a>System stats</h2>

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
    src="images/network.png" /></a>Virtual hosts</h2>

<ul>
	<!-- <li><a href="http://www.slitaz.org/">www.slitaz.org</a> - SliTaz Website.
		(<a href="/stats/awstats.pl?config=www.slitaz.org">stats</a>)</li>
	<li><a href="http://doc.slitaz.org/">doc.slitaz.org</a> - Documentation platform.
		(<a href="/stats/awstats.pl?config=doc.slitaz.org">stats</a>)</li>
	<li><a href="http://pkgs.slitaz.org/">pkgs.slitaz.org</a> - Packages Web interface.
		(<a href="/stats/awstats.pl?config=pkgs.slitaz.org">stats</a>)</li> -->
	<li><a href="http://boot.slitaz.org/">boot.slitaz.org</a> - gPXE Web boot.
		(<a href="/stats/awstats.pl?config=boot.slitaz.org">stats</a>)</li>
	<!-- <li><a href="http://hg.slitaz.org/">hg.slitaz.org</a> - Mercurial repositories.
		(<a href="/stats/awstats.pl?config=hg.slitaz.org">stats</a>)</li> -->
	<li><a href="http://cook.slitaz.org/">cook.slitaz.org</a> - SliTaz Build Bot.
		(<a href="/stats/awstats.pl?config=cook.slitaz.org">stats</a>)</li>
	<li><a href="http://people.slitaz.org/">people.slitaz.org</a> - SliTaz People stuff.
		(<a href="/stats/awstats.pl?config=people.slitaz.org">stats</a>)</li>
	<li><a href="http://pro.slitaz.org/">pro.slitaz.org</a> - SliTaz Professional services.</li>
</ul>

<h2><img
	style="vertical-align: middle; padding: 0 4px 0 0;"
	title="Erjo Virtual hosts" alt="vhosts"
    src="images/network.png" />Other hosts</h2>

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
	src="images/network.png"
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
	Copyright &copy; <span class="year"></span>
	<a href="http://www.slitaz.org/">SliTaz</a> - Network:
	<a href="http://scn.slitaz.org/">Community</a>
	<a href="http://doc.slitaz.org/">Doc</a>
	<a href="http://forum.slitaz.org/">Forum</a>
	<a href="http://pkgs.slitaz.org/">Packages</a>
	<a href="http://bugs.slitaz.org">Bugs</a>
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
