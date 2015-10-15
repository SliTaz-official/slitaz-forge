<!DOCTYPE html>
<html lang="de">
<head>
	<meta charset="UTF-8">
	<title>SliTaz Web Boot</title>
	<meta name="description" content="slitaz gPXE boot online your OS web-boot slitaz-cooking">
	<meta name="keywords" lang="en" content="slitaz, boot, pxe, web OS">
	<meta name="robots" content="index, follow, all">
	<meta name="modified" content="<?php echo (date( "Y-m-d H:i:s", getlastmod())); ?>">
	<meta name="author" content="Christophe Lincoln">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="../favicon.ico">
	<link rel="stylesheet" type="text/css" href="/static/slitaz.min.css">
</head>
<body>

<script>de=document.documentElement;de.className+=(("ontouchstart" in de)?' touch':' no-touch');</script>

<header>
	<h1><a href="http://boot.slitaz.org/">SliTaz Web Boot</a></h1>
	<div class="network">
		<a href="http://www.slitaz.org/" class="home"></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	</div>
</header>

<!-- Block -->
<div class="block"><div>

	<!-- Information/image -->
	<div class="block_info">
		<header>Web Boot</header>
		<p>
			Willkommen am Start-Provider gPXE von
			<a href="http://www.slitaz.org/de/">SliTaz GNU/Linux</a>,
			boot.slitaz.org ermöglicht Ihnen, SliTaz aus dem Netzwerk
			durch einfache benützung einer CD-ROM, eines USB-Sticks oder
			gar einer Start-Floppy, einzusetzen.
		</p>
		<p>
			Quick Download:
			<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
		</p>
	</div>

	<!-- Navigation -->
	<nav>
		<header>Community</header>
		<ul>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://pizza.slitaz.org/">LiveCD Online Builder</a></li>
			<li><a href="http://doc.slitaz.org/en:cookbook:start">SliTaz Cookbook</a></li>
			<li><a href="http://doc.slitaz.org/en:handbook:genlivecd">LiveCD flavor howto</a></li>
		</ul>
	</nav>
</div></div>

<!-- Content -->
<main>

<!-- Languages -->
<div class="lang">
	<a href="http://www.slitaz.org/i18n.php" class="locale"></a>
	<b>Deutsch</b>
	<a href="../en/">English</a>
	<a href="../fr/">Français</a>
	<a href="../pt/">Português</a>
	<a href="../ru/">Русский</a>
</div>


<h2>Introduction und guide</h2>

<p>
Linux-Kernel und erforderliche komprimierte Dateien werden dann in Ihr RAM aus dem Internet über das Protokol
PXE/HTTP geladen. Viel Freude damit! <a href="../en/#guide">Short guide...</a>
</p>

<p> <br/> <br/> <br/> <br/> </p>

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
		Copyright © <span class="year"></span>
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
		<a href="http://de.wikipedia.org/wiki/SliTaz">Wikipedia</a> ·
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</div>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

</body>
</html>
