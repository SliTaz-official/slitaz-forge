<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>SliTaz Chub</title>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="slitaz chub server at COSI" />
	<meta name="robots" content="index, follow, all" />
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
		<h4><img src="images/server.png" alt="[ Server ]" />Project servers</h4>
		<ul>
			<li><a href="http://tank.slitaz.org/">Tank server</a></li>
			<li><a href="http://mirror.slitaz.org/">Mirror server</a></li>
		</ul>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Codename: chub</h4>
		<p>
			This is the SliTaz GNU/Linux Community HUB server. This
			virtual machine is gracefully hosted by COSI at Clarkson
			University <a href="http://cosi.clarkson.edu/">cosi.clarkson.edu</a>
		</p>
		<p>
			<!-- Chub CPU is a <?php //system("sed -e '/^model name/!d;s/.*Intel(R) //;" .         
			//"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //' </proc/cpuinfo |" .
			//" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
			//"if (n == 4) printf \"quad \"; print s }' ")?> -
			<?php //system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
			//"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
			//"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")?> -->
			Chub CPU is a quad Xeon E5410 2.33GHz - 4GB RAM -
			<a href="graphs.php">Graphical stats</a>
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

<h2><a href="graphs.php"><img style="padding: 0 4px 0 0;"
	title="Chub RRDtool graphs" alt="graphs"
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
system("ifconfig eth1 | awk '{ if (/X packet/ || /X byte/) print }' | sed 's/^\s*//'");
?>
</pre>

<h2><img src="images/network.png" alt="[ Vhosts ]" />Virtual hosts</h2>

<!-- End of content -->
</div>

<?php include("lib/html/footer.html"); ?>

</body>
</html>
