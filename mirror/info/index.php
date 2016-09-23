<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>SliTaz Mirror</title>
	<meta name="description" content="slitaz mirror server">
	<meta name="robots" content="index, nofollow">
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
	<h1><a href="http://<?php
		echo $_SERVER["HTTP_HOST"];
	?>">SliTaz <?php
		$host = preg_replace('/(\w+).*/i','$1',$_SERVER["HTTP_HOST"]);
		echo $host;
	?></a></h1>
	<div class="network">
		<a href="http://www.slitaz.org/" class="home"></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://pro.slitaz.org/">Pro</a>
		<a href="http://slitaz.spreadshirt.net/">Shop</a>
		<a href="http://bugs.slitaz.org/">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
		<a href="http://cook.slitaz.org/">Cook</a>
	</div>
</header>


<!-- Block begin -->
<div class="block"><div>

	<!-- Top block begin -->
	<div class="block_info">
		<header>Codename: <?php echo $host; ?></header>
		<p>This is the SliTaz GNU/Linux main mirror.
			The server runs naturally SliTaz (stable) in an UML virtual
			machine provided by
			<a href="http://www.ads-lu.com/">Allied Data Sys. (ADS)</a>.</p>
		<p>Mirror CPU is a <?php
system("( sed '/cpuinfo=/!d;" .
	"s/.*cpuinfo=\\([^ ]*\).*/: \\1/;s/_/ /g' /proc/cmdline ; grep '^model name' /proc/cpuinfo) | sed -e 's/.*Intel(R) //;" .
	"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //;q' |" .
	" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
	"if (n == 4) printf \"quad \"; print s }' ")
		?> - <?php
system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
	"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
	"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")
		?> -
		Located in France next to Roubaix.
		This page has real time statistics provided by PHP <code>system()</code>.
		Mirror is also monitored by RRDtool which provides <a href="graphs.php">graphical stats</a>.</p>
	<!-- Top block end -->
	</div>

	<!-- Nav block begin -->
	<nav>
		<header>Project servers</header>
		<ul>
			<li><a href="http://tank.slitaz.org/">Tank server</a></li>
			<li><a href="http://pangolin.slitaz.org/">Pangolin server</a></li>
		</ul>
	<!-- Nav block end -->
	</nav>

<!-- Block end -->
</div></div>


<!-- Content -->
<main>


<h2>System stats</h2>


<h3>Uptime</h3>

<pre class="hard"><?php
system("uptime | sed 's/^\s*//'");
?></pre>


<h3>Disk usage</h3>

<pre class="hard"><?php
system("df -h | sed '/^rootfs/d' | grep  '\(^/dev\|Filesystem\)'");
?></pre>


<h3>Network</h3>

<pre class="hard"><?php
system("ifconfig eth0 | awk '{ if (/X packet/ || /X byte/) print }' | sed 's/^\s*//'");
?></pre>




<?php if (isset($_GET["all"])) { ?>

<h3>Logins</h3>

<pre class="hard scroll"><?php
system("last");
?></pre>

<h3>Processes</h3>

<pre class="hard scroll"><?php
system("top -n1 -b");
?></pre>

<?php } ?>




<h2 id="vhosts">Virtual hosts</h2>

<!-- p><a href="http://mirror1.slitaz.org/awstats.pl?config=info.mirror.slitaz.org" target="_blank">stats</a></p -->

<table class="list">
	<thead>
		<tr>
			<th>Host name</th>
			<th>Description</th>
			<th>Stats</th>
		</tr>
	</thead>
	<tr>
		<td class="server"><a href="http://mirror.slitaz.org/">mirror.slitaz.org</a></td>
		<td>SliTaz Mirror</td>
		<td><a href="http://mirror1.slitaz.org/stats" target="_blank">stats</a></td>
	</tr>
	<tr>
		<td class="server"><a href="http://scn.slitaz.org/">scn.slitaz.org</a></td>
		<td>SliTaz Community Network</td>
		<td><a href="http://mirror1.slitaz.org/awstats.pl?config=scn.slitaz.org" target="_blank">stats</a></td>
	</tr>
	<tr>
		<td class="server"><a href="http://pizza.slitaz.org/">pizza.slitaz.org</a></td>
		<td>SliTaz Flavor builder</td>
		<td><a href="http://mirror1.slitaz.org/awstats.pl?config=pizza.mirror.slitaz.org" target="_blank">stats</a></td>
	</tr>
	<tr>
		<td class="server"><a href="https://ajaxterm.slitaz.org/">ajaxterm.slitaz.org</a></td>
		<td>SliTaz Web Console</td>
		<td><a href="http://mirror1.slitaz.org/awstats.pl?config=ajaxterm.slitaz.org" target="_blank">stats</a></td>
	</tr>
</table>


<h2 id="replicas">Tank replicas</h2>

<!-- p><a href="http://mirror1.slitaz.org/awstats.pl?config=replicas.mirror.slitaz.org" target="_blank">stats</a></p -->

<table class="list">
	<thead>
		<tr>
			<th>Host name</th>
			<th>Description</th>
			<th>Original</th>
		</tr>
	</thead>
	<tr>
		<td class="server"><a href="http://mirror1.slitaz.org/www/">www.slitaz.org</a></td>
		<td>SliTaz Website</td>
		<td><a href="http://www.slitaz.org/" target="_blank">main</a></td>
	</tr>
	<tr>
		<td class="server"><a href="http://mirror1.slitaz.org/doc/">doc.slitaz.org</a></td>
		<td>Documentation</td>
		<td><a href="http://doc.slitaz.org/" target="_blank">main</a></td>
	</tr>
	<tr>
		<td class="server"><a href="http://mirror1.slitaz.org/pkgs/">pkgs.slitaz.org</a></td>
		<td>Packages Web interface</td>
		<td><a href="http://pkgs.slitaz.org/" target="_blank">main</a></td>
	</tr>
	<tr>
		<td class="server"><a href="http://mirror1.slitaz.org/hg/">hg.slitaz.org</a></td>
		<td>Mercurial repositories (read only)</td>
		<td><a href="http://hg.slitaz.org/" target="_blank">main</a>,
			<a href="http://hg.tuxfamily.org/mercurialroot/slitaz/" target="_blank">tuxfamily</a>
		</td>
	</tr>
	<tr>
		<td class="server"><a href="http://mirror1.slitaz.org/webboot/">boot.slitaz.org</a></td>
		<td>gPXE Web boot</td>
		<td><a href="http://boot.slitaz.org/" target="_blank">main</a></td>
	</tr>
</table>


<h2 id="mirrors">Mirrors</h2>

<p>Most mirrors are updated using the URL:
	<code>rsync://mirror.slitaz.org/slitaz/</code>
	(<a href="http://mirror1.slitaz.org/awstats.pl?config=rsync">stats</a>)</p>

<table class="list">
	<thead>
		<tr>
			<th>Mirror name</th>
			<th>Access URLs</th>
			<th>Location</th>
		</tr>
	</thead>
	<tr>
		<td class="fr">slitaz.org mirror</td>
		<td>
			<a href="http://mirror.slitaz.org/">http</a>
		</td>
		<td><a href="http://en.utrace.de/?query=mirror.slitaz.org">map</a></td>
	</tr>
	<tr>
		<td class="ch">Swiss academia mirror</td>
		<td>
			<a href="http://mirror.switch.ch/ftp/mirror/slitaz/">http</a> ·
			<a href="ftp://mirror.switch.ch/mirror/slitaz/">ftp</a>
		</td>
		<td><a href="http://en.utrace.de/?query=mirror.switch.ch">map</a></td>
	</tr>
	<tr>
		<td class="us">Georgia Tech Software Library (GTlib) mirror</td>
		<td>
			<a href="http://www.gtlib.gatech.edu/pub/slitaz/">http</a> ·
			<a href="ftp://ftp.gtlib.gatech.edu/pub/slitaz/">ftp</a> ·
			<a href="rsync://www.gtlib.gatech.edu/slitaz/">rsync</a>
		</td>
		<td><a href="http://en.utrace.de/?query=www.gtlib.gatech.edu">map</a></td>
	</tr>
	<tr>
		<td class="fr">TuxFamily mirror</td>
		<td>
			<a href="http://download.tuxfamily.org/slitaz/">http</a> ·
			<a href="ftp://download.tuxfamily.org/slitaz/">ftp</a> ·
			<a href="rsync://download.tuxfamily.org/pub/slitaz/">rsync</a>
		</td>
		<td><a href="http://en.utrace.de/?query=download.tuxfamily.org">map</a></td>
	</tr>
	<tr>
		<td class="br">Federal University of Paraná (UFPR) mirror</td>
		<td>
			<a href="http://slitaz.c3sl.ufpr.br/">http</a> ·
			<a href="ftp://slitaz.c3sl.ufpr.br/slitaz/">ftp</a> ·
			<a href="ftp://opensuse.c3sl.ufpr.br/slitaz/">ftp</a> ·
			<a href="ftp://ftp.br.debian.org/slitaz/">ftp</a> ·
			<a href="rsync://slitaz.c3sl.ufpr.br/slitaz/">rsync</a>
		</td>
		<td><a href="http://en.utrace.de/?query=slitaz.c3sl.ufpr.br">map</a></td>
	</tr>
	<tr>
		<td class="it">Italian Research &amp; Education Network (NREN) mirror</td>
		<td>
			<a href="http://slitaz.mirror.garr.it/mirrors/slitaz/">http</a> ·
			<a href="ftp://slitaz.mirror.garr.it/mirrors/slitaz/">ftp</a> ·
			<a href="rsync://slitaz.mirror.garr.it/mirrors/slitaz/">rsync</a>
		</td>
		<td><a href="http://en.utrace.de/?query=slitaz.mirror.garr.it">map</a></td>
	</tr>
	<tr>
		<td class="us">University of North Carolina mirror</td>
		<td>
			<a href="http://distro.ibiblio.org/slitaz/">http</a> ·
			<a href="ftp://distro.ibiblio.org/slitaz/">ftp</a>
		</td>
		<td><a href="http://en.utrace.de/?query=distro.ibiblio.org">map</a></td>
	</tr>
	<tr>
		<td class="us">Clarkson University mirror</td>
		<td>
			<a href="http://mirror.clarkson.edu/slitaz/">http</a>
		</td>
		<td><a href="http://en.utrace.de/?query=mirror.clarkson.edu">map</a></td>
	</tr>
	<tr>
		<td class="fr">TuxFamily mirror</td>
		<td>
			<a href="http://malibu.tuxfamily.net/slitaz/">http</a> ·
			<a href="ftp://malibu.tuxfamily.net/slitaz/">ftp</a>
		</td>
		<td><a href="http://en.utrace.de/?query=malibu.tuxfamily.net">map</a></td>
	</tr>
	<tr>
		<td class="de">University of Stuttgart mirror</td>
		<td>
			<a href="http://ftp.uni-stuttgart.de/slitaz/">http</a> ·
			<a href="ftp://ftp.uni-stuttgart.de/slitaz/">ftp</a>
		</td>
		<td><a href="http://en.utrace.de/?query=ftp.uni-stuttgart.de">map</a></td>
	</tr>
	<tr>
		<td class="de">Technische Universität Darmstadt mirror</td>
		<td>
			<a href="ftp://fb04272.mathematik.tu-darmstadt.de/pub/linux/distributions/slitaz/">ftp</a> ·
			<a href="ftp://linux.mathematik.tu-darmstadt.de/pub/linux/distributions/misc/slitaz/">ftp</a>
		</td>
		<td><a href="http://en.utrace.de/?query=linux.mathematik.tu-darmstadt.de">map</a></td>
	</tr>
	<tr>
		<td class="de">Kiel University mirror</td>
		<td>
			<a href="ftp://ftp.rz.uni-kiel.de/pub2/linux/slitaz/">ftp</a>
		</td>
		<td><a href="http://en.utrace.de/?query=ftp.rz.uni-kiel.de">map</a></td>
	</tr>
	<tr>
		<td class="pl">University of Warsaw mirror</td>
		<td>
			<a href="ftp://ftp.icm.edu.pl/vol/rzm5/linux-ibiblio/distributions/slitaz/">ftp</a>
		</td>
		<td><a href="http://en.utrace.de/?query=ftp.icm.edu.pl">map</a></td>
	</tr>
</table>
<!--
Old mirrors:
	http://www.linuxembarque.com/slitaz/mirror/ (fr)
	http://mirror.lupaworld.com/slitaz/ (cn)
	http://mirror.drustvo-dns.si/slitaz/ (si)
	ftp://ftp.pina.si/slitaz/ (si)
	http://ftp.nedit.org/ftp/ftp/pub/os/Linux/distr/slitaz/ (nl)
	http://ftp.ch.xemacs.org/ftp/pool/2/mirror/slitaz/ (ch)
	ftp://ftp.ch.xemacs.org/pool/2/mirror/slitaz/ (ch)

Outdated mirror:
	http://ftp.vim.org/ftp/os/Linux/distr/slitaz/ (2012)
-->


<h2 id="builds">Weekly builds</h2>

<?php
function display_log($file,$anchor,$url)
{
echo "<p><a name=\"$anchor\" href=\"$url\">";
system("stat -c '%y %n' ".$file." | sed -e 's/.000000000//' -e 's|/var/log/\(.*\).log|\\1.iso|'");
echo "</a></p>";
echo "<pre class=\"hard\">";
system("cat ".$file." | sed -e 's/.\[[0-9][^mG]*.//g' | awk '".
'{ if (/\[/) { n=index($0,"["); printf("%s%s%s\n",substr($0,1,n-1),'.
'substr("\t\t\t\t\t\t\t",1,9-(n/8)),substr($0,n)); } else print }'."'");
echo "</pre>";
}

display_log("/var/log/packages-stable.log", "buildstable", "/iso/stable/packages-4.0.iso");
display_log("/var/log/packages-cooking.log","buildcooking","/iso/cooking/packages-cooking.iso");
?>

	<p>Last update : <?php echo date('r'); ?></p>
<!-- End of content -->
</main>

<script>
	function QRCodePNG(str, obj) {
		try {
			obj.height = obj.width += 300;
			return QRCode.generatePNG(str, {ecclevel: 'H'});
		}
		catch (any) {
			var element = document.createElement("script");
			element.src = "/static/qrcode.min.js";
			element.type = "text/javascript";
			element.onload = function() {
				obj.src = QRCode.generatePNG(str, {ecclevel: 'H'});
			};
			document.body.appendChild(element);
		}
	}
</script>

<footer>
	<div>
		Copyright © <?php echo date('Y'); ?>
		<a href="http://www.slitaz.org/">SliTaz</a>
	</div>
	<div>
		Network:
		<a href="http://scn.slitaz.org/">Community</a> ·
		<a href="http://doc.slitaz.org/">Doc</a> ·
		<a href="http://forum.slitaz.org/">Forum</a> ·
		<a href="http://pkgs.slitaz.org/">Packages</a> ·
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
