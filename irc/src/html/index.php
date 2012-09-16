<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<?php
    include("config.inc.php");
?>
<html><head>
<title>SliTaz IRC Logs</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<meta name="description" content="SliTaz IRC Logs" />
<meta name="keywords" content="SliTaz IRC Logs" />
<link rel="stylesheet" href="style.css" type="text/css" />
</head>
<body>
<?php $now = date('Y-m-d'); ?>
<!-- Header -->
<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">Home</a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://webchat.freenode.net/?channels=#slitaz">IRC</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://slitaz.pro/">Pro</a>
		<a href="http://shop.slitaz.org/">Shop</a>
		<a href="http://bugs.slitaz.org/">Bugs</a>
		<a href="http://hg.slitaz.org/">Hg</a>
	</div>
	<h1><a href="./">SliTaz IRC Logs</a></h1>
</div>
<?php
    $date = $_GET['date'];
    if (is_null($date)) {
		$date = $now;
	}
    if (isset($date) && preg_match("/^\d\d\d\d-\d\d-\d\d$/", $date)) {
?>
<div id="contentbox">
    <h2>Log for <?php echo($date); ?></h2>
    <p>Timestamps are GMT-6</p>
    <p><a href="./index"><< Go to Index</a></p>
</div>
<div id="content">
<?php
        readfile($date . ".log");
?>
</div>
<?php
    }
    elseif (isset($date) && preg_match("/^index$/", $date)) {
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
	<div style="text-align: justify; width: 48%; padding: 20px 10px 0pt 0pt;">
		These are the logs from the #slitaz support channel on freenode.<br />
		The main purpose of these is to provide records of meetings and<br />
		dicussions we have on IRC - not that pankso is around much...<br /><br />
		Please click on the date of the log you wish to view:<br />
	</div>
</div>
<div id="content">
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
	<p>
		Network: 
		<a href="http://www.slitaz.org/">Main Site</a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://pkgs.slitaz.org/">Packages</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/">Hg</a>
	<br>
		SliTaz @
		<a href="http://twitter.com/slitaz">Twitter</a>
		<a href="http://www.facebook.com/slitaz">Facebook</a>
		<a href="http://distrowatch.com/slitaz">Distrowatch</a>
		<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a>
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</p>
	<p>
		These logs were automatically created by <b><?php echo($nick); ?></b> 
		using <a href="http://www.jibble.org/logbot/">LogBot</a>
	</p>
<div/>
</body></html>
