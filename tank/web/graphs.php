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

<?php include("lib/html/header.html"); ?>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="images/server.png" alt="[ Server ]" />Project servers</h4>
		<ul>
			<li><a href="http://mirror1.slitaz.org/">Mirror server</a></li>
			<li><a href="http://pangolin.slitaz.org/">Pangolin server</a></li>
		</ul>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Codename: tank</h4>
		<p>
			This is the SliTaz GNU/Linux main server and build host. 
			The server runs naturally SliTaz and provides some services
			to all contributors such as: secure access, disk space, a 
			public directory or cron jobs. The virtual machine provided by 
			<a href="https://www.linkedin.com/company/balinor-technologies/">balinor-technologies</a>.
		</p>
		<p>
			Tank CPU is a <?php system("sed -e '/^model name/!d;s/.*Intel(R) //;" .         
			"s/@//;s/(.*)//;s/CPU //;s/.*AMD //;s/.*: //;s/Processor //' </etc/cpuinfo |" .
			" awk '{ s=$0; n++ } END { if (n == 2) printf \"dual \";" .
			"if (n == 4) printf \"quad \"; print s }' ")?> -
			<?php system("free | awk '/Mem:/ { x=2*$2-1; while (x >= 1024) { x /= 1024; ".
			"n++ }; y=1; while (x > 2) { x /= 2; y *= 2}; ".
			"printf \"%d%cB RAM\",y,substr(\"MG\",n,1) }' ")?>  - Located in Paris,
			France.
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

<div align="center"> <?php echo date("r"); ?> </div>
<?php

$myurl="http://".$_SERVER['SERVER_NAME'].$_SERVER['SCRIPT_NAME'];

function one_graphic($img,$name)
{
	echo '<img src="images/rrd/'.$img.'" title="'.
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
	if (isset($_GET['stats']) && $_GET['stats'] == $res) {
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

<?php include("lib/html/footer.html"); ?>

</body>
</html>
