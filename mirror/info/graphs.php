<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Mirror RRD stats</title>
	<meta name="description" content="slitaz mirror rrdtool graphs">
	<meta name="robots" content="noindex">
	<meta name="author" content="SliTaz Contributors">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="/static/favicon.ico">
	<link rel="stylesheet" type="text/css" href="/static/slitaz.min.css">
</head>
<body>

<script>
	document.documentElement.className += (("ontouchstart" in document.documentElement) ? ' touch' : ' no-touch');
</script>

<header>
	<h1><a href="http://<?php echo $_SERVER["HTTP_HOST"]; ?>/">SliTaz <?php
	$host=preg_replace('/(\w+).*/i','$1',$_SERVER["HTTP_HOST"]); echo $host; ?></a></h1>
	<div class="network">
		<a href="http://www.slitaz.org/" class="home"></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://slitaz.pro/">Pro</a>
		<a href="http://slitaz.spreadshirt.net/">Shop</a>
		<a href="http://bugs.slitaz.org/">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
		<a href="http://cook.slitaz.org/">Cook</a>
	</div>
</header>

<!-- Block -->
<div class="block"><div>

	<!-- Information/image -->
	<div class="block_info">
		<header>Codename: <?php echo $host; ?></header>
		<p>
			This is the SliTaz GNU/Linux main mirror. The server runs naturally SliTaz 
			(stable) in an UML virtual machine provided by 
			<a href="http://www.ads-lu.com/">Allied Data Sys. (ADS)</a>.
		</p>
		<p>
			Mirror CPU is a <?php
system("( sed '/cpuinfo=/!d;" .
	"s/.*cpuinfo=\\([^ ]*\).*/: \\1/;s/_/ /g' /proc/cmdline ; grep '^model name' /proc/cpuinfo) | sed -e 's/.*Intel(R) //;" .
	"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //;q' |" .
	" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
	"if (n == 4) printf \"quad \"; print s }' ")
			?> - <?php
system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
	"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
	"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")
			?> - Located in France next to 
			Roubaix. This page has real time statistics provided by PHP 
			<code>system()</code>.
			Mirror is monitored by RRDtool which provides graphical stats.
		</p>
	</div>

	<!-- Navigation -->
	<nav>
		<header>Project servers</header>
		<ul>
			<li><a href="http://tank.slitaz.org/">Tank server</a></li>
			<li><a href="http://pangolin.slitaz.org/">Pangolin server</a></li>
		</ul>
	</nav>
</div></div>

<!-- Content -->
<main>

<p style="text-align:center">Server date: <?php echo date("r"); ?> </p>
<?php

$myurl="http://".$_SERVER['SERVER_NAME'].$_SERVER['SCRIPT_NAME'];

function one_graphic($img,$name)
{
	echo '<img src="pics/rrd/' . $img . '" title="' .
		$name . '" alt="' . $name . '"/>';
}

function graphic($res, $img='')
{
	global $myurl;
	if (!$img) $img=$res;
	echo "<div class=\"large\"><a name=\"" . $res . "\" href=\"" . $myurl . "?stats=" . $res . "#" . $res . "\">\n";
	one_graphic($img."-day.png",$res." daily");
	echo "</a></div>\n";
	if (isset($_GET['stats']) && $_GET['stats'] == $res) {
		echo "<div class=\"large\">";
		one_graphic($img."-week.png",$res." weekly");
		echo "</div>\n<div class=\"large\">";
		one_graphic($img."-month.png",$res." monthly");
		echo "</div>\n<div class=\"large\">";
		one_graphic($img."-year.png",$res." yearly");
		echo "</div>\n";
	}
}

echo "\n\n<h2>CPU</h2>\n";
graphic("cpu");
echo "\n\n<h2>Memory</h2>\n";
graphic("memory");
echo "\n\n<h2>Disk</h2>\n";
graphic("disk");
echo "\n\n<h2>Network</h2>\n";
$eth = array();
exec("/sbin/route -n | awk '{ if (/^0.0.0.0/) print $8 }'", $eth);
graphic("net",$eth[0]);

?>

<!-- End of content -->
</main>

<!-- Footer -->

<script type="text/javascript">
	function QRCodePNG(str, obj) {
		try {
			obj.height = obj.width += 300;
			return QRCode.generatePNG(str, {ecclevel: 'H'});
		}
		catch (any) {
			var element = document.createElement("script");
			element.src = "/static/qrcode.min.js";
			element.type ="text/javascript";
			element.onload = function() {
				obj.src = QRCode.generatePNG(str, {ecclevel: 'H'});
			};
			document.body.appendChild(element);
		}
	}
</script>

<footer>
	<div>
		Copyright © <span class="year"></span>
		<a href="http://www.slitaz.org/">SliTaz</a>
	</div>
	<div>
		Network:
		<a href="http://scn.slitaz.org/">Community</a> ·
		<a href="http://doc.slitaz.org/">Doc</a> ·
		<a href="http://forum.slitaz.org/">Forum</a> ·
		<a href="http://pkgs.slitaz.org/">Packages</a> ·
		<a href="http://boot.slitaz.org/">Boot</a> ·
		<a href="http://bugs.slitaz.org">Bugs</a> ·
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	</div>
	<div>
		SliTaz @
		<a href="http://twitter.com/slitaz">Twitter</a> ·
		<a href="http://www.facebook.com/slitaz">Facebook</a> ·
		<a href="http://distrowatch.com/slitaz">Distrowatch</a> ·
		<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a> ·
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</div>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

</body>
</html>
