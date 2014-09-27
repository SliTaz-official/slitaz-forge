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

<?php include("lib/html/header.html"); ?>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="images/development.png" alt="development.png" />Developers Corner</h4>
		<div class="right_box">
			<ul>
				<li><a href="http://tank.slitaz.org/">Tank Server</a></li>
				<li><a href="http://mirror1.slitaz.org/">Main Mirror</a></li>
			</ul>
		</div>
		<div class="left_box">
			<ul>
				<li><a href="http://www.slitaz.org/en/devel/">Devel Doc</a></li>
				<li><a href="http://people.slitaz.org/">SliTaz People</a></li>
				<li><a href="http://cook.slitaz.org/">Cooker</a></li>
				<li><a href="http://pizza.slitaz.me/">Pizza Builder</a></li>
			</ul>
		</div>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Codename: tank</h4>
		<p>
			This is the SliTaz GNU/Linux main server and build host. 
			The server runs naturally SliTaz and provides some services
			to all contributors.
		</p>
		<p>
			Tank CPU is a <?php system("sed -e '/^model name/!d;s/.*Intel(R) //;" .         
			"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //' </proc/cpuinfo |" .
			" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
			"if (n == 4) printf \"quad \"; print s }' ")?> -
			<?php system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
			"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
			"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")?>  - Located in Gravelines,
			France. Tank is also monitored by RRDtool which provides 
			<a href="graphs.php">graphical stats</a>.
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

<h2><a href="graphs.php"><img 
	style="vertical-align: middle; padding: 0 4px 4px 0;"
	title="Tank RRDtool graphs" alt="graphs"
    src="images/monitor.png" /></a>System stats</h2>

<h4>Uptime</h4>

<pre>
<?php
system("uptime | sed 's/^\s*//'");
?>
</pre>

<h4>Disk usage</h4>
<pre>
<?php
system("df -h | sed '/^rootfs/d' | grep  '\(^/dev\|Filesystem\)'");
?>
</pre>

<h4>Network</h4>
<pre>
<?php
system("ifconfig eth0 | awk '{ if (/X packet/ || /X byte/) print }' | sed 's/^\s*//'");
?>
</pre>

<h2><a href="/stats/awstats.pl?config=www.slitaz.org"><img
	style="padding: 0 4px 4px 0;" title="Tank Virtual hosts" alt="vhosts"
    src="images/network.png" /></a>Virtual hosts</h2>

<ul>
	<!-- <li><a href="http://pkgs.slitaz.org/">pkgs.slitaz.org</a> - Packages Web interface.
		(<a href="/stats/awstats.pl?config=pkgs.slitaz.org">stats</a>)</li> -->
	<li><a href="http://boot.slitaz.org/">boot.slitaz.org</a> - SliTaz Web boot.
		(<a href="/stats/awstats.pl?config=boot.slitaz.org">stats</a>)</li>
	<!-- <li><a href="http://hg.slitaz.org/?sort=lastchange">hg.slitaz.org</a> - Mercurial repositories.
		(<a href="/stats/awstats.pl?config=hg.slitaz.org">stats</a>)</li> -->
	<li><a href="http://cook.slitaz.org/">cook.slitaz.org</a> - SliTaz Build Bot.
		(<a href="/stats/awstats.pl?config=cook.slitaz.org">stats</a>)</li>
	<li><a href="http://people.slitaz.org/">people.slitaz.org</a> - SliTaz People stuff.
		(<a href="/stats/awstats.pl?config=people.slitaz.org">stats</a>)</li>
		<li><a href="http://roadmap.slitaz.org/">roadmap.slitaz.org</a> - 
		SliTaz Roadmap.
	(<a href="/stats/awstats.pl?config=roadmap.slitaz.org">stats</a>)</li>
	<li><a href="http://bugs.slitaz.org/">bugs.slitaz.org</a> - 
		SliTaz Bug Tracker.</li>
	<li><a href="http://irc.slitaz.org/">irc.slitaz.org</a> - 
		SliTaz IRC logs and webchat.</li>
	<li><a href="http://try.slitaz.org/">try.slitaz.org</a> - 
		To try some CGI scripts and other web services.</li>
</ul>

<ul>
	<li><a href="http://slitaz.pro">slitaz.pro</a> - SliTaz Professional services.
	(<a href="/stats/awstats.pl?config=slitaz.pro">stats</a>)</li>
	<li><a href="http://slitaz.me">slitaz.me</a> - 
		Domain used for users services such as Pizza.</li>
<h2>Tank Log</h2>

<pre>
<?php
system("tac /var/log/tank.log | head -50");
?>
</pre>

<!-- End of content -->
</div>

<?php include("lib/html/footer.html"); ?>

</body>
</html>
