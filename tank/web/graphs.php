<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>Tank RRD stats</title>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="slitaz tank rrdtool graphs" />
	<meta name="robots" content="noindex" />
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
		<h1>Tank RRD stats</h1>
		<p>
			This is the SliTaz GNU/Linux main server and build host. The server runs
			naturally SliTaz (stable) and provides some services to all contributors
			such as: secure access, disk space, a public directory, cron jobs and the
			<a href="http://bb.slitaz.org/">Build Bot</a>.
		</p>
	<!-- Top block end -->
	</div>
<!-- Block end -->
</div>

<?php

$myurl="http://".$_SERVER['SERVER_NAME'].$_SERVER['SCRIPT_NAME'];

function one_graphic($img,$name)
{
	echo '<img src="pics/rrd/'.$img.'" title="'.
		$name.'" alt="'.$name.'" />'."\n";
}

function graphic($res, $img='')
{
	global $myurl;
	if (!$img) $img=$res;
	echo "<a name=\"".$res."\"></a>";
	echo "<a href=\"".$myurl."?stats=".$res."#".$res."\">\n";
	one_graphic($img."-day.png",$res." daily");
	echo "</a>";
	if ($_GET['stats'] == $res) {
		one_graphic($img."-week.png",$res." weekly");
		one_graphic($img."-month.png",$res." monthly");
		one_graphic($img."-year.png",$res." yearly");
	}
}

echo "<h2>CPU</h2>\n";
graphic("cpu");
echo "<h2>Memory</h2>\n";
graphic("memory");
echo "<h2>Disk</h2>\n";
graphic("disk");
echo "<h2>Network</h2>\n";
$eth = array();
exec("/sbin/route -n | awk '{ if (/^0.0.0.0/) print $8 }'", $eth);
graphic("net",$eth[0]);

?>

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
