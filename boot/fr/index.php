<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
    <title>SliTaz Web Boot (fr)</title>
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
		<a href="http://labs.slitaz.org/issues">Bugs</a>
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
		<h4>Démarrage via le réseau</h4>
		<p>
			Bienvenue sur l'hôte de démarrage gPXE de
			<a href="http://www.slitaz.org/fr/">SliTaz GNU/Linux</a>,
			boot.slitaz.org vous permet de démarrer SliTaz depuis le
			réseau en utilisant un cdrom, une clé USB ou une disquette
			de démarrage.
		</p>
		<div class="button" style="padding-top: 8px;">
			Téléchargement rapide:
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
Démarrez votre système d'exploitation depuis internet! Le noyau Linux et
le système de fichiers compressé contenant SliTaz seront chargés en RAM
depuis internet en utilisant les protocoles PXE et HTTP. 
</p>

<h2>Guide rapide</h2>
<p>
Pour démarrer depuis internet vous devez avoir une configuration réseau 
fonctionnelle (Serveur DHCP, DNS/DNS cache, passerelle par défaut). 
C'est généralement le cas si vous utiliser un routeur pour votre 
connexion réseau.
</p>

<ul>
	<li>La version Cooking de permet de démarrer depuis boot.slitaz.org
	en utilisant l'option <code>web</code> au boot, cela permet d'utiliser
	le LiveCD standard pour tester la dernière version sans regraver un
	cdrom.</li>
	
	<li>Image ISO SliTaz boot: Téléchargez le fichier
	<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
	(<a href="http://mirror.slitaz.org/boot/slitaz-boot.md5">md5</a>)
	et gravez l'image sur un cdrom vierge. Démarrez depuis le cdrom et 
	choisissez l'option gPXE. Cette image ISO vous permet également de tester
	la mémoire système avec Memtest86.</li>
	<li>Média USB: Utilisez TazUSB pour générer un média USB amorçable.
	Installez le paquet <code>gpxe</code>, copiez le répertoire /boot/gpxe 
	dans le répertoire boot du média USB et ajoutez une entrée dans le 
	fichier de configuration de Syslinux <code>syslinux.cfg</code> :
<pre>
label web
	kernel /boot/gpxe
</pre></li>
	
	<li>Image de disquette: Téléchargez le fichier
	<a href="http://mirror.slitaz.org/boot/floppy-grub">floppy-grub</a>
	(<a href="http://mirror.slitaz.org/boot/floppy-grub.md5">md5</a>)
	Transférez l'image sur une disquette vierge en utilisant la commande 
	suivant: <code>dd if=floppy-grub of=/dev/fd0</code>. Démarrez sur 
	la disquette et choisissez l'entrée gPXE.
	</li>
</ul>

<h3>Temps de démarrage</h3>
<p>
Le temps de démarrage dépend de votre vitesse de connexion  à internet 
et des charges du serveur. En france avec un débit de 1Mo il faut 5 minutes.
Vous pouvez poster vos retours d'expériences sur le Wiki, Forum ou la 
liste de diffusion.
</p>

<h3>Configuration minimum</h3>
<p>
L'entrée par défaut nécessite au moins 160Mo de RAM. Deux autres sont
disponibles pour démarrer avec 24Mo ou plus :
<ul>
	<li><code>tiny</code> démarre en mode texte.</li>
	<li><code>loram</code> démarre en mode graphique.</li>
</ul>
</p>

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
	<a href="http://labs.slitaz.org/issues">Bugs</a>
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
