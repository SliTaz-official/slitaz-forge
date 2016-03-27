<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>SliTaz Pangolin</title>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="slitaz pangolin server" />
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
		<a href="http://www.slitaz.org/">Home</a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://irc.slitaz.org/">IRC</a>
		<a href="http://slitaz.pro/">Pro</a>
		<a href="http://shop.slitaz.org/">Shop</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	</div>
	<h1><a href="http://www.slitaz.org/">SliTaz Pangolin</a></h1>
</div>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="images/development.png" alt="development.png" />Developers Corner</h4>
		<div class="right_box">
			<ul>
				<li><a href="http://tank.slitaz.org/">Tank Server</a></li>
				<li><a href="http://mirror1.slitaz.org/">Main Mirror</a></li>
				<li><a href="http://pangolin.slitaz.org/console/">Console</a></li>
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
		<h4>Codename: pangolin - Maintainer: erjo</h4>
		<p>
			This is the SliTaz GNU/Linux main server and build host. 
			The server runs naturally SliTaz and provides some services
			to all contributors.
		</p>
		<p>
			Pangolin CPU is a <?php system("sed -e '/^model name/!d;s/.*Intel(R) //;" .
			"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //' </proc/cpuinfo |" .
			" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
			"if (n == 4) printf \"quad \"; print s }' ")?> -
			<?php system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
			"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
			"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")?>
			- Located in Paris, 
			France. Pangolin is also monitored by RRDtool which provides 
			<a href="graphs.php">graphical stats</a>.
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

<h2><a href="graphs.php"><img 
	style="vertical-align: middle; padding: 0 4px 4px 0;"
	title="Pangolin RRDtool graphs" alt="graphs"
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
system("[ -d /sys/block ] && [ -x /usr/sbin/smartctl ] && { cd /sys/block ; for i in [hs]d? ; do echo -n \$i ; /usr/sbin/smartctl -a /dev/\$i 2> /dev/null | sed '/Power_On_Hours/{s/.*Pow/: Pow/;s/ours.*-/ours/;p};/offline/!d;q'; echo; done; }");
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
	style="vertical-align: middle; padding: 0 4px 4px 0;"
	title="Pangolin Virtual hosts" alt="vhosts"
    src="images/network.png" /></a>Virtual hosts</h2>

<ul>
	<li><a href="http://www.slitaz.org/">www.slitaz.org</a> - SliTaz Website.
	(<a href="/stats/awstats.pl?config=www.slitaz.org">stats</a>)</li>
	<li><a href="http://doc.slitaz.org/">doc.slitaz.org</a> - Documentation platform.</li>
	<li><a href="http://forum.slitaz.org/">forum.slitaz.org</a> - SliTaz support forum.</li>
	<li><a href="http://vanilla.slitaz.org/">vanilla.slitaz.org</a> - previous SliTaz forum.</li>
	<li><a href="http://hg.slitaz.org/">hg.slitaz.org</a> - Mercurial repositories.</li>
	<li><a href="http://pizza.slitaz.me/">pizza.slitaz.me</a> - SliTaz flavor builder.</li>
	<li><a href="http://scn.slitaz.org/">scn.slitaz.org</a> - Community platform.</li>
</ul>

<h2><img
	style="vertical-align: middle; padding: 0 4px 4px 0;"
	title="Erjo Virtual hosts" alt="vhosts"
    src="images/network.png" />Other hosts</h2>

<p>
	These services are hosted by some individual sponsors who gracefully offer
	resources to the SliTaz project.
</p>
<ul>
	<li><a href="http://mirror.slitaz.org/">mirror1.slitaz.org</a> - SliTaz main mirror and replicas.
		(<a href="http://mirror1.slitaz.org/info/">more...</a>)</li>
	<li><a href="http://pkgs.slitaz.org/">pkgs.slitaz.org</a> - Packages Web interface.</li>
	<li><a href="http://tiny.slitaz.org/">tiny.slitaz.org</a> - Tiny SliTaz builder.</li>
	<!-- ajaxterm archives console-mirror demo dvd floppy ssh usbkey -->
	<li><a href="http://boot.slitaz.org/">boot.slitaz.org</a> - gPXE Web boot.</li>
	<li><a href="http://cook.slitaz.org/">cook.slitaz.org</a> - SliTaz Build Bot.</li>
	<li><a href="http://people.slitaz.org/">people.slitaz.org</a> - SliTaz People stuff.</li>
	<li><a href="http://slitaz.pro/">slitaz.pro</a> - SliTaz Professional services.</li>
	<!-- bb cloud ssfs stats store tank -->
</ul>
    
<a name="mirrors"></a>
<h2><a href="http://mirror1.slitaz.org/info/"> <img
	style="vertical-align: middle; padding: 0 4px 4px 0;"
	src="images/network.png"
	title="Secondary mirrors" alt="mirrors" /></a>Mirrors</h2>
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
$mirrors_url_file="./mirrors";

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
	array(	"flag"  => "cn",
		"http"  => "http://mirror.lupaworld.com/slitaz/"),
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
	array(	"flag"  => "si",
		"ftp"   => "ftp://ftp.pina.si/slitaz/"),
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
		"http"  => "http://ftp.ch.xemacs.org/ftp/pool/4/mirror/slitaz/",
		"ftp"   => "ftp://ftp.ch.xemacs.org//pool/4/mirror/slitaz/"),
	array(	"flag"  => "de",
		"http"  => "http://ftp.uni-stuttgart.de/slitaz/",
		"ftp"   => "ftp://ftp.uni-stuttgart.de/slitaz/"),
	array(	"flag"  => "ro",
		"http"  => "http://ftp.info.uvt.ro/pub/slitaz/",
		"ftp"   => "ftp://ftp.info.uvt.ro/pub/slitaz/",
		"rsync" => "rsync://ftp.info.uvt.ro/ftp/pub/slitaz/"),
	array(	"flag"  => "au",
		"http"  => "http://mirror.iprimus.com/slitaz/"),
	array(	"flag"  => "au",
		"http"  => "http://mirror01.ipgn.com.au/slitaz/"),
	array(	"flag"  => "us",
		"http"  => "http://mirror.clarkson.edu/slitaz/",
		"rsync" => "rsync://mirror.clarkson.edu/slitaz/")) as $mirror) {
	$flag = "pics/website/".$mirror["flag"].".png";
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
