<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>SliTaz Mirror</title>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="slitaz mirror server" />
	<meta name="robots" content="index, nofollow" />
	<meta name="author" content="SliTaz Contributors" />
	<link rel="shortcut icon" href="/static/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="/static/slitaz.css" />
	<style type="text/css">
		h2 img { padding-right: 4px; }
	</style>
</head>
<body>

<!-- Header -->
<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">
			<img src="/static/home.png" alt=" [ Home ] " /></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://slitaz.pro/">Pro</a>
		<a href="http://slitaz.spreadshirt.net/">Shop</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
		<a href="http://cook.slitaz.org/">Cook</a>
	</div>
	<h1><a href="http://<?php echo $_SERVER["HTTP_HOST"]; ?>/">SliTaz 
	<?php $host=preg_replace('/(\w+).*/i','$1',$_SERVER["HTTP_HOST"]); echo $host; ?></a></h1>
</div>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="images/server.png" alt="[ Server ]" />Project servers</h4>
		<ul>
			<li><a href="http://tank.slitaz.org/">Tank server</a></li>
			<li><a href="http://pangolin.slitaz.org/">Pangolin server</a></li>
			<li><a href="http://chub.slitaz.org/">Chub server</a></li>
		</ul>
	</div>
	<!-- Information/image -->
	<div id="block_info">
	<h4>Codename: <?php echo $host; ?></h4>
		<p>
			This is the SliTaz GNU/Linux main mirror. The server runs naturally SliTaz 
			(stable) in an UML virtual machine provided by 
			<a href="http://www.ads-lu.com/">Allied Data Sys. (ADS)</a>.
		</p>
		<p>
			Mirror CPU is a <?php system("( sed '/cpuinfo=/!d;" .
			"s/.*cpuinfo=\\([^ ]*\).*/: \\1/;s/_/ /g' /proc/cmdline ; grep '^model name' /proc/cpuinfo) | sed -e 's/.*Intel(R) //;" .
			"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //;q' |" .
			" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
			"if (n == 4) printf \"quad \"; print s }' ")?> -
			<?php system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
			"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
			"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")?> - Located in France next to 
			Roubaix. This page has real time statistics provided by PHP 
			<code>system()</code> Mirror is also monitored by RRDtool which provides 
			<a href="graphs.php">graphical stats</a>.
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

<h2><a href="graphs.php"><img 
	title="Mirror RRDtool graphs" alt="graphs"
    src="images/monitor.png" /></a>System stats</h2>

<h4>Uptime</h4>

<pre class="box">
<?php
system("uptime | sed 's/^\s*//'");
?>
</pre>

<h4>Disk usage</h4>

<pre class="box">
<?php
system("df -h | sed '/^rootfs/d' | grep  '\(^/dev\|Filesystem\)'");
?>
</pre>

<h4>Network</h4>
<pre class="box">
<?php
system("ifconfig eth0 | awk '{ if (/X packet/ || /X byte/) print }' | sed 's/^\s*//'");
?>
</pre>


<?php if (isset($_GET["all"])) { ?>
<h4>Logins</h4>
<pre class="box">
<?php
system("last");
?>
</pre>

<h4>Processes</h4>
<pre class="box">
<?php
system("top -n1 -b");
?>
</pre>
<?php } ?>

<a name="vhosts"></a>
<h2><img title="Mirror Virtual hosts" alt="vhosts"
    src="/static/network.png" />Virtual hosts</h2>

<ul>
	<li><a href="http://mirror1.slitaz.org/">mirror1.slitaz.org</a> - SliTaz Mirror.
	(<a href="http://mirror1.slitaz.org/stats">stats</a>)</li>
	<li><a href="http://scn.slitaz.org/">scn.slitaz.org</a> - SliTaz Community Network.
	(<a href="http://mirror1.slitaz.org/awstats.pl?config=scn.slitaz.org">stats</a>)</li>
	<li><a href="http://pizza.slitaz.org/">pizza.slitaz.org</a> - SliTaz Flavor builder.
	(<a href="http://mirror1.slitaz.org/awstats.pl?config=pizza.mirror1.slitaz.org">stats</a>)</li>
	<li><a href="http://tiny.slitaz.org/">tiny.slitaz.org</a> - Tiny SliTaz builder.
	(<a href="http://mirror1.slitaz.org/awstats.pl?config=tiny.slitaz.org">stats</a>)</li>
	<li><a href="https://ajaxterm.slitaz.org/">ajaxterm.slitaz.org</a> - Slitaz Web Console.
	(<a href="http://mirror1.slitaz.org/awstats.pl?config=ajaxterm.slitaz.org">stats</a>)</li>
</ul>

<a name="replicas"></a>
<h2><a href="http://mirror1.slitaz.org/awstats.pl?config=replicas.mirror1.slitaz.org">
		<img title="Tank replicas" alt="replicas"
    src="/static/network.png" /></a>Tank replicas</h2>

<ul>
	<li><a href="http://mirror1.slitaz.org/www/">www.slitaz.org</a> - SliTaz Website.
	(<a href="http://www.slitaz.org/">main</a>)</li>
	<li><a href="http://mirror1.slitaz.org/doc/">doc.slitaz.org</a> - Documentation.
	(<a href="http://doc.slitaz.org/">main</a>)</li>
	<li><a href="http://mirror1.slitaz.org/pkgs/">pkgs.slitaz.org</a> - Packages Web interface.
	(<a href="http://pkgs.slitaz.org/">main</a>)</li>
	<li><a href="http://mirror1.slitaz.org/hg/?sort=lastchange">hg.slitaz.org</a> - Mercurial repositories (read only).
	(<a href="http://hg.slitaz.org/?sort=lastchange">main</a>
	<a href="http://hg.tuxfamily.org/mercurialroot/slitaz/">tuxfamily</a>)</li>
	<li><a href="http://mirror1.slitaz.org/webboot/">boot.slitaz.org</a> - gPXE Web boot.
	(<a href="http://boot.slitaz.org/">main</a>)</li>
</ul>

<a name="boot"></a>
<h2><a href="http://doc.slitaz.org/en:guides:pxe#web-booting">
	<img title="Web boot" src="/static/network.png" 
	 alt="web boot" /></a>Web boot services</h2>
	 The SliTaz mirror provides a <b>tftp</b> access and a 
	 <a href="/pxe">pxe</a> tree. Simply add to your DHCP server configuration file:
	 <ul>
	 <li>for <b>udhcpd</b><!-- siaddr? sname? tftp? -->
	 <pre>
siaddr mirror.slitaz.org
boot_file gpxe.pxe</pre>
	 </li>
	 <li>for <b>dhcpd</b>
	 <pre>
next-server "mirror.slitaz.org"
filemane "gpxe.pxe"</pre>
	 </li>
	 <li>for <b>dnsmasq</b>
	 <pre>
dhcp-boot=gpxe.pxe,mirror.slitaz.org</pre>
	 </li>
	 </ul>

<a name="mirrors"></a>
<h2><a href="http://mirror1.slitaz.org/awstats.pl?config=rsync">
	<img title="Secondary mirrors" src="/static/network.png" 
	 alt="mirrors" /></a>Mirrors</h2>
	Most mirrors are updated using the url: <b>rsync://mirror1.slitaz.org/slitaz/</b>
	(<a href="http://mirror1.slitaz.org/awstats.pl?config=rsync">stats</a>)
	<pre>
rsync -azH --delete rsync://mirror1.slitaz.org/slitaz/ /local/slitaz/mirror/ </pre>
	New mirrors should be announced on the 
	<a href="http://www.slitaz.org/en/mailing-list.html">mailing list</a>.
<ul>
<?php
$output_url_file="";
$output_url_handler;
$mirrors_url_file="/tmp/mirrors";

function test_url($link, $proto)
{
	global $output_url_file;
	global $mirrors_url_file;
	global $output_url_handler;
	
	if ($output_url_file != "") {
		switch($proto) {
		case "http" :
		case "ftp" :
			$cmd = "busybox wget -s $link/README" ;
			break;
		case "rsync" :
			$cmd = "rsync $link > /dev/null 2>&1" ;
			break;
		default :
			return FALSE;
		}
		if (shell_exec("$cmd && echo -n OK") == "OK") {
			fwrite($output_url_handler,$link."\n");
			return TRUE;
		} 
		return FALSE;
	}
	return shell_exec("grep -qs ^$link$ $mirrors_url_file && echo -n OK") == "OK"; 
}

if (! file_exists($mirrors_url_file)) {
	$output_url_file = tempnam('/tmp','mkmirrors');
	$output_url_handler = fopen($output_url_file, "w");
	fwrite($output_url_handler,"http://mirror1.slitaz.org/\n");
	fwrite($output_url_handler,"rsync://mirror1.slitaz.org/\n");
}

# Flags icons from http://www.famfamfam.com/lab/icons/flags/famfamfam_flag_icons.zip
foreach (array(
	array(	"flag"  => "ch",
		"http"  => "http://mirror.switch.ch/ftp/mirror/slitaz/",
		"ftp"   => "ftp://mirror.switch.ch/mirror/slitaz/"),
	array(	"flag"  => "us",
		"http"  => "http://www.gtlib.gatech.edu/pub/slitaz/",
		"ftp"   => "ftp://ftp.gtlib.gatech.edu/pub/slitaz/",
		"rsync" => "rsync://www.gtlib.gatech.edu/slitaz/"),
	array(	"flag"  => "fr",
		"http"  => "http://download.tuxfamily.org/slitaz/",
		"ftp"   => "ftp://download.tuxfamily.org/slitaz/",
		"rsync" => "rsync://download.tuxfamily.org/pub/slitaz/"),
	array(	"flag"  => "fr",
		"http"  => "http://www.linuxembarque.com/slitaz/mirror/"),
//	array(	"flag"  => "cn",
//		"http"  => "http://mirror.lupaworld.com/slitaz/"),
	array(	"flag"  => "cn",
		"http"  => "http://ks.lupaworld.com/slitaz/"),
	array(	"flag"  => "br",
		"http"  => "http://slitaz.c3sl.ufpr.br/",
		"ftp"   => "ftp://slitaz.c3sl.ufpr.br/slitaz/",
		"rsync" => "rsync://slitaz.c3sl.ufpr.br/slitaz/"),
	array(	"flag"  => "it",
		"http"  => "http://slitaz.mirror.garr.it/mirrors/slitaz/",
		"ftp"   => "ftp://slitaz.mirror.garr.it/mirrors/slitaz/",
		"rsync" => "rsync://slitaz.mirror.garr.it/mirrors/slitaz/"),
	array(	"flag"  => "si",
		"http"  => "http://mirror.drustvo-dns.si/slitaz/"),
//	array(	"flag"  => "si",
//		"ftp"   => "ftp://ftp.pina.si/slitaz/"),
	array(	"flag"  => "us",
		"http"  => "http://distro.ibiblio.org/pub/linux/distributions/slitaz/",
		"ftp"   => "ftp://distro.ibiblio.org/pub/linux/distributions/slitaz/"),
	array(	"flag"  => "nl",
		"http"  => "http://ftp.vim.org/ftp/os/Linux/distr/slitaz/",
		"ftp"   => "ftp://ftp.vim.org/mirror/os/Linux/distr/slitaz/"),
	array(	"flag"  => "nl",
		"http"  => "http://ftp.nedit.org/ftp/ftp/pub/os/Linux/distr/slitaz/",
		"ftp"   => "ftp://ftp.nedit.org/ftp/ftp/pub/os/Linux/distr/slitaz/"),
	array(	"flag"  => "ch",
		"http"  => "http://ftp.ch.xemacs.org/ftp/pool/2/mirror/slitaz/",
		"ftp"   => "ftp://ftp.ch.xemacs.org//pool/2/mirror/slitaz/"),
	array(	"flag"  => "de",
		"http"  => "http://ftp.uni-stuttgart.de/slitaz/",
		"ftp"   => "ftp://ftp.uni-stuttgart.de/slitaz/"),
	array(	"flag"  => "au",
		"http"  => "http://mirror.iprimus.com/slitaz/"),
	array(	"flag"  => "au",
		"http"  => "http://mirror01.ipgn.com.au/slitaz/"),
	array(	"flag"  => "us",
		"http"  => "http://mirror.clarkson.edu/slitaz/",
		"rsync" => "rsync://mirror.clarkson.edu/slitaz/")) as $mirror) {
	$flag = "images/flags/".$mirror["flag"].".png";
	$head = TRUE;
	foreach(array("http", "ftp", "rsync") as $proto) {
		if (!isset($mirror[$proto])) continue;
		$link = $mirror[$proto];
		if (!test_url($link, $proto)) continue;
		$serveur = parse_url($link, PHP_URL_HOST);
		if ($head) echo <<<EOT
	<li><a href="http://en.utrace.de/?query=$serveur">
		<img title="map" src="$flag" alt="map" /></a>
		<a href="$link">$link</a>
EOT;
		else echo <<<EOT
		or <a href="$link">$proto</a>
EOT;
		$head = FALSE;
	}
	if ($head) continue;
	echo "	</li>\n";
}

if ($output_url_file != "") {
	fclose($output_url_handler);
	rename($output_url_file, $mirrors_url_file);
	chmod($mirrors_url_file, 0644);
}

?>
</ul>

<a name="builds"></a>
<h3><img title="Daily builds" src="images/iso.png" alt="builds" 
     width="25" height="25" />
    Daily builds</h3>

<?php
function display_log($file,$anchor,$url)
{
echo '<a name="'.$anchor.'"></a>';
echo "<h4><a href=\"$url\">";
system("stat -c '%y %n' ".$file." | sed 's/.000000000//;s|/var/log/\(.*\).log|\\1.iso|'");
echo "</a></h4>";
echo "<pre>";
$sed_script="s/.\[[0-9][^mG]*.//g";
$sed_script.=";:a;s/^\(.\{1,68\}\)\(\[ [A-Za-z]* \]\)/\\1 \\2/;ta";
$sed_script.=";s#\[ OK \]#[ <span style=\"color:green\">OK</span> ]#";
$sed_script.=";s#\[ Failed \]#[ <span style=\"color:red\">Failed</span> ]#";
system("sed '".$sed_script."' < $file");
echo "</pre>";
}

display_log("/var/log/packages-stable.log", "buildstable", "/iso/stable/packages-4.0.iso");
display_log("/var/log/packages-cooking.log","buildcooking","/iso/cooking/packages-cooking.iso");
?>

<!-- End of content -->
</div>

<!-- Footer -->

<script type="text/javascript">
	function QRCodePNG(str, obj) {
		try {
			obj.height = obj.width += 300;
			return QRCode.generatePNG(str, {ecclevel: 'H'});
		}
		catch (any) {
			var element = document.createElement("script");
			element.src = "/static/qrcode.js";
			element.type ="text/javascript"; 
			element.onload = function() {
				obj.src = QRCode.generatePNG(str, {ecclevel: 'H'});
			};
			document.body.appendChild(element);
		}
	}
</script>

<div id="footer">
	Copyright &copy; <span class="year"></span>
	<a href="http://www.slitaz.org/">SliTaz</a> - Network:
	<a href="http://scn.slitaz.org/">Community</a>
	<a href="http://doc.slitaz.org/">Doc</a>
	<a href="http://forum.slitaz.org/">Forum</a>
	<a href="http://pkgs.slitaz.org/">Packages</a>
	<a href="http://boot.slitaz.org/">Boot</a>
	<a href="http://bugs.slitaz.org">Bugs</a>
	<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	<p>
		<img src="/static/qr.png" alt="SliTaz @" onmouseover="this.title = location.href"
		 onclick="this.src = QRCodePNG(location.href, this)" />
		<a href="http://twitter.com/slitaz">Twitter</a>
		<a href="http://www.facebook.com/slitaz">Facebook</a>
		<a href="http://distrowatch.com/slitaz">Distrowatch</a>
		<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a>
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</p>
	<p>
		<a href="http://validator.w3.org/check?uri=referer">
			<img src="/static/xhtml10.png"
				alt="Valid XHTML 1.0" title="Code valid. XHTML 1.0"
				style="width: 80px; height: 15px;" /></a>
	</p>
</div>

</body>
</html>
