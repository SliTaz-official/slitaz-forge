<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>SliTaz Web Boot</title>
    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
    <meta name="description" content="slitaz gPXE boot online your OS web-boot slitaz-cooking" />
    <meta name="keywords" lang="en" content="slitaz, boot, pxe, web OS" />
    <meta name="robots" content="index, follow, all" />
    <meta name="modified" content="<?php echo (date( "Y-m-d H:i:s", getlastmod())); ?>" />
    <meta name="author" content="Christophe Lincoln"/>
    <link rel="shortcut icon" href="../favicon.ico" />
    <link rel="stylesheet" type="text/css" href="../slitaz.css" />
</head>
<body>

<!-- Header -->
<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">
			<img src="../images/network.png" alt="network.png" /></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/">Hg</a>
	</div>
	<h1><a href="http://boot.slitaz.org/">SliTaz Web Boot</a></h1>
</div>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="../images/users.png" alt="users.png" />Community</h4>
		<ul>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://pizza.slitaz.org/">LiveCD Online Builder</a></li>
			<li><a href="http://doc.slitaz.org/en:cookbook:start">SliTaz Cookbook</a></li>
			<li><a href="http://doc.slitaz.org/en:handbook:genlivecd">LiveCD flavor howto</a></li>
		</ul>	
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Web Boot</h4>
		<p>
			Welcome to the <a href="http://www.slitaz.org/en/">SliTaz GNU/Linux</a>
			gPXE boot host; boot.slitaz.org allows you to boot SliTaz from the Web
			using a cdrom, USB media or a floppy disk. 
		</p>
		<div class="button" style="padding-top: 8px;">
			Quick Download:
			<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
		</div>
	</div>
</div>

<!-- Languages -->
<div id="lang">
	<a href="http://www.slitaz.org/i18n.php">
		<img src="../images/locale.png" alt="locale.png" /></a>
	<a href="../de/">Deutsch</a>
	<a href="../en/">English</a>
	<a href="../fr/">Français</a>
</div>

<!-- Content -->
<div id="content">

<h2>Introduction</h2>

<p>
	Boot your operating system from the internet and enjoy a full system
	working entirely in RAM with speed and stability in mind. The Linux Kernel
	and the complete SliTaz compressed root filesystem will be loaded into
	RAM from the Web using PXE and HTTP protocols.
</p>

<a name="guide"></a>
<h2>Short guide</h2>
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
	and burn the image to a cdrom. Boot from the cdrom device and select 
	gPXE. This ISO image also provides Memtest86 to test system memory.
	</li>
	<li>USB media: Use TazUSB to generate bootable USB media. Install 
	the package <code>gpxe</code>, copy /boot/gpxe into the boot 
	directory of the USB media and add an entry to the Syslinux configuration
	file <code>syslinux.cfg</code>:
	<pre class="script">
label web
	kernel /boot/gpxe
	</pre></li>
	<li>Floppy image: Download
	<a href="http://mirror.slitaz.org/boot/floppy-grub">floppy-grub</a>
	(<a href="http://mirror.slitaz.org/boot/floppy-grub.md5">md5</a>)
	and transfer the image to a blank floppy disk using the command: 
	<code>dd if=floppy-grub of=/dev/fd0</code>. Boot the floppy and select
	gPXE entry.</li>
</ul>

<h3>Boot time</h3>
<p>
The boot time largely depends on your network connection. With a 1Mb 
connection in France, it takes 5 min. If you want, you can report the
boot time on the Mailing list or the Forum.
</p>

<h3>Required configuration</h3>
<p>
The default boot entry needs 160Mb RAM. Two entries are available to
boot with 24Mb:
</p>
<ul>
	<li><code>tiny</code> starts in text mode.</li>
	<li><code>loram</code> starts in graphical mode.</li>
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
