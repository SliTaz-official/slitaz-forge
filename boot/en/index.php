<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>SliTaz Web Boot</title>
	<meta name="description" content="slitaz iPXE boot online your OS web-boot slitaz-cooking">
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
			Welcome to the <a href="http://www.slitaz.org/en/">SliTaz GNU/Linux</a>
			iPXE boot host; boot.slitaz.org allows you to boot SliTaz from the Web
			using a cdrom, USB media or a floppy disk.
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
	</div>
</div></div>

<!-- Content -->
<main>

<!-- Languages -->
<div class="lang">
	<a href="http://www.slitaz.org/i18n.php" class="locale"></a>
	<a href="../de/">Deutsch</a>
	<b>English</b>
	<a href="../fr/">Français</a>
	<a href="../pt/">Português</a>
	<a href="../ru/">Русский</a>
</div>


<h2>Introduction</h2>

<p>
	Boot your operating system from the internet and enjoy a full system
	working entirely in RAM with speed and stability in mind. The Linux Kernel
	and the complete SliTaz compressed root filesystem will be loaded into
	RAM from the Web using PXE and HTTP protocols.
</p>


<h2 id="guide">Short guide</h2>
<p>
To boot from the internet you'll need a working DHCP server, DNS server/cache
and a default internet route. This is usually the case if you have a router
for network connection.
</p>
<ul>
	<li>SliTaz Cooking has the boot option <code>web</code>, so you can
	use boot.slitaz.org from the standard core LiveCD.</li>
	<li>SliTaz boot ISO: Download
	<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
	(<a href="http://mirror.slitaz.org/boot/slitaz-boot.md5">md5</a>)
	and burn the image to a CD ROM. Boot from the CD ROM device and select
	iPXE. This ISO image also provides Memtest86 to test system memory.
	</li>
	<li>USB media: Use TazUSB to generate bootable USB media. Install
	the package <code>ipxe</code>, copy /boot/ipxe into the boot
	directory of the USB media and add an entry to the Syslinux configuration
	file <code>syslinux.cfg</code>:
	<pre class="script">
label web
	kernel /boot/ipxe
	</pre></li>
	<li>Floppy image: Download
	<a href="http://mirror.slitaz.org/boot/floppy-grub4dos">floppy-grub4dos</a>
	(<a href="http://mirror.slitaz.org/boot/floppy-grub4dos.md5">md5</a>)
	and transfer the image to a blank floppy disk using the command:
	<code>dd if=floppy-grub4dos of=/dev/fd0</code>. Boot the floppy and select
	iPXE entry.</li>
	<li>Network boot: if you can modify your DHCP server configuration, declare
	the tftp server <i>mirror.slitaz.org</i> and the boot file
	<i>ipxe.pxe</i>:
	<ul>
	<li>for <b>udhcpd</b>
	<pre>siaddr mirror.slitaz.org
boot_file ipxe.pxe</pre></li>
	<li>for <b>dhcpd</b>
	<pre>next-server "mirror.slitaz.org"
filemane "ipxe.pxe"</pre></li>
	<li>for <b>dnsmasq</b>
	<pre>dhcp-boot=ipxe.pxe,mirror.slitaz.org</pre></li>
	</ul>
	</li>
</ul>


<h3>Boot time</h3>

<p>
The boot time largely depends on your network connection. With a 1 Mb/s
connection in France, it takes 5 min. If you want, you can report the
boot time on the Mailing list or the Forum.
</p>


<h3>Required configuration</h3>

<p>
The default boot entry needs 160 MB RAM. Two entries are available to
boot with 24 MB:
</p>
<ul>
	<li><code>tiny</code> starts in text mode.</li>
	<li><code>loram</code> starts in graphical mode.</li>
</ul>

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
		<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a> ·
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</div>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

</body>
</html>
