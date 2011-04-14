<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<title>SliTaz People</title>
	<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
	<meta name="description" content="slitaz people" />
	<meta name="keywords" lang="en" content="slitaz network, slitaz developpers, slitaz contributors" />
	<meta name="robots" content="index, follow, all" />
    <meta name="modified" content="<?php echo (date( "Y-m-d H:i:s", getlastmod())); ?>" />
	<meta name="author" content="Christophe Lincoln"/>
	<link rel="shortcut icon" href="favicon.ico" />
	<link rel="stylesheet" type="text/css" href="slitaz.css" />
	<script type="text/javascript">
	/* <![CDATA[ */
	    (function() {
	        var s = document.createElement('script'), t = document.getElementsByTagName('script')[0];
	        s.type = 'text/javascript';
	        s.async = true;
	        s.src = 'http://api.flattr.com/js/0.6/load.js?mode=auto';
	        t.parentNode.insertBefore(s, t);
	    })();
	/* ]]> */
	</script>
</head>
<body>

<!-- Header -->
<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">
			<img src="images/network.png" alt="network.png" /></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/">Hg</a>
	</div>
	<h1><a href="http://people.slitaz.org/">SliTaz People</a></h1>
</div>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="images/development.png" alt="development.png" />Developers Corner</h4>
		<ul>
			<li><a href="http://www.slitaz.org/en/devel/">Website devel</a></li>
			<li><a href="http://scn.slitaz.org/">Community</a></li>
			<li><a href="http://labs.slitaz.org/">Laboratories</a></li>
			<li><a href="http://hg.slitaz.org/">Mercurial Repos</a></li>
			<li><a href="http://bb.slitaz.org/">Build Bot</a></li>
			<li><a href="http://tank.slitaz.org/">Tank Server</a></li>
		</ul>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>People</h4>
		<p>
			Each contributor who has access to the project main server,
			code name <a href="http://tank.slitaz.org/">Tank</a> and can 
			have a public directory. This Public directory can be reached
			with URLs in the form of: http://people.slitaz.org/~name/.
		</p>
		<p>
			You can help us maintain and improve this service with a small
			donation to the SliTaz association:
			<!-- PayPal Button -->
			<form action="https://www.paypal.com/cgi-bin/webscr" method="post"
				style="display: inline;">
				<input type="hidden" name="cmd" value="_s-xclick" />
				<input type="hidden" name="hosted_button_id" value="4885025" />
				<input type="image" src="images/paypal.png" name="submit" 
					alt="PayPal - The safer, easier way to pay online!" />
			</form>
			<!-- Flattr Button -->
			<a class="FlattrButton" style="display:none;" rev="flattr;button:compact;"
				href="http://www.slitaz.org/"></a>
		</p>
	</div>
</div>

<!-- Content -->
<div id="content">

<h2>SliTaz people</h2>

<style type="text/css">
ul span { 
	color: #666; 
	font-size: 11px; 
	font-weight: normal;
	display: block;
	padding: 2px 0;
}
ul { list-style-type: square; }
ul span a { color: #666; }
</style>

<ul>
<?php
if ($handle = opendir('/home')) {
	$scn_url = 'http://scn.slitaz.org/members';
	while (false !== ($dir = readdir($handle))) {
		if ($dir != "." && $dir != "..") {
			$pub = "/home/$dir/Public";
			$user = "$dir";
			if (file_exists($pub)) {
				echo "	<li><a href=\"/~$user/\">$user</a>\n";
				if (file_exists("$pub/profile.php")) {
					require_once("$pub/profile.php");
					echo "<span>Name: $name";
					if (! empty($location)) { 
						echo " | Location: $location"; 
					}
					if (! empty($scn_user)) { 
						echo " | <a href=\"$scn_url/$scn_user/\">SCN activity</a>"; 
					}
					if (! empty($skills)) { 
						echo " | Skills: $skills"; 
					}
					echo "</span>";
					if (! empty($wall)) { 
						echo "<span>$wall</span>";
					}
				}
				echo "</li>";
			}
			
		}
	}
	closedir($handle);
}
?>
</ul>

<!-- End of content -->
</div>

<div style="margin-top: 100px;"></div>

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
