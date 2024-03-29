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
				<li><a href="http://pangolin.slitaz.org/">Pangolin Server</a></li>
				<li><a href="http://mirror1.slitaz.org/">Main Mirror</a></li>
				<li><a href="http://tank.slitaz.org/console/">Console</a></li>
			</ul>
		</div>
		<div class="left_box">
			<ul>
				<li><a href="http://www.slitaz.org/en/devel/">Devel Doc</a></li>
				<li><a href="http://people.slitaz.org/">SliTaz People</a></li>
				<li><a href="http://cook.slitaz.org/">Cooker</a></li>
				<li><a href="http://mypizza.slitaz.org/">Pizza Builder</a></li>
			</ul>
		</div>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Codename: tank</h4>
		<p>
			This is the SliTaz GNU/Linux main server and build host. 
			The server runs naturally SliTaz and provides some services
			to all contributors. The virtual machine is gracefully hosted by 
			<a href="https://www.linkedin.com/company/balinor-technologies/">balinor-technologies</a>.
		</p>
		<p>
			Tank CPU is a <?php system("sed -e '/^model name/!d;s/.*Intel(R) //;" .         
			"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //' </etc/cpuinfo |" .
			" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
			"if (n == 4) printf \"quad \"; if (n == 8) printf \"octo \"; print s }' ")?> -
			<?php system("free -g | awk '/Mem:/ { print $2 \"GB RAM\" }'")?> -
			Located in Paris, France. Tank is also monitored by RRDtool which provides 
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
system("[ -d /sys/block ] && [ -x /usr/sbin/smartctl ] && { cd /sys/block ; for i in [hs]d? ; do echo -n \$i ; /usr/sbin/smartctl -a /dev/\$i 2> /dev/null | sed '/Power_On_Hours/{s/.*Pow/: Pow/;s/ours.*-/ours/;p};/offline/!d;q'; echo; done; }");
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
		SliTaz Bug Tracker.
		(<a href="/stats/awstats.pl?config=bugs.slitaz.org">stats</a>)</li>
	<li><a href="http://irc.slitaz.org/">irc.slitaz.org</a> - 
		SliTaz IRC logs and webchat.
		(<a href="/stats/awstats.pl?config=irc.slitaz.org">stats</a>)</li>
	<li><a href="http://try.slitaz.org/">try.slitaz.org</a> - 
		To try some CGI scripts and other web services.
		(<a href="/stats/awstats.pl?config=try.slitaz.org">stats</a>)</li>
</ul>

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
