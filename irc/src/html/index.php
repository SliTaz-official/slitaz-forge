<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<?php
    include("config.inc.php");
?>
<html>
<head>
	<title>IRC Logs for SliTaz</title>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="IRC Logs for SliTaz" />
	<meta name="keywords" content="IRC Logs for SliTaz" />
	<link rel="stylesheet" href="style.css" type="text/css" />
</head>
<body>
	<div id="header">
		<div id="logo"></div>
		<div id="network">
			<a href="http://www.slitaz.org/">
				<img src="http://www.slitaz.org/images/network.png" alt="network.png" /></a>
			<a href="http://scn.slitaz.org/">Community</a>
			<a href="http://doc.slitaz.org/">Doc</a>
			<a href="http://forum.slitaz.org/">Forum</a>
			<a href="http://bugs.slitaz.org">Bugs</a>
			<a href="http://hg.slitaz.org/">Hg</a>
		</div>
		<h1><a href="./">IRC Logs for SliTaz</a></h1>
	</div>
	<?php
		$date = $_GET['date'];
		if (isset($date) && preg_match("/^\d\d\d\d-\d\d-\d\d$/", $date)) {
	?>
	<div id="contentbox">
		<h2>Log for <?php echo($date); ?></h2>
		<p>Timestamps are GMT-7</p>
		<p><a href="./"><< Back to Index</a></p>
	</div>
	<div id="content">
	<?php
			readfile($date . ".log");
	?>
	</div>
	<?php
		}
		else {
			$dir = opendir(".");
			while (false !== ($file = readdir($dir))) {
				if (strpos($file, ".log") == 10) {
					$filearray[] = $file;
				}
			}
			closedir($dir);
			rsort($filearray);
	?>
	<div id="contentbox">
		<ul>
	<?php
			foreach ($filearray as $file) {
				$file = substr($file, 0, 10);
	?>
			<li><a href="<?php echo($file); ?>"><?php echo($file); ?></a></li>
	<?php
			}
	?>
		</ul>
	</div>
	<?php
		}
	?>
	<div id="footer">
		<p>SliTaz @
			<a href="http://twitter.com/slitaz">Twitter</a>
			<a href="http://www.facebook.com/slitaz">Facebook</a>
			<a href="http://distrowatch.com/slitaz">Distrowatch</a>
			<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a>
			<a href="http://flattr.com/profile/slitaz">Flattr</a></p>
		<p>These logs were automatically created by <b><?php echo($nick); ?></b> 
		using <a href="http://www.jibble.org/logbot/">LogBot</a></p>
	<div/>
</body>
</html>
