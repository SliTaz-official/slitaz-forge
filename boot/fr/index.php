<!DOCTYPE html>
<html lang="fr">
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
		<header>Démarrage via le réseau</header>
		<p>
			Bienvenue sur l'hôte de démarrage iPXE de
			<a href="http://www.slitaz.org/fr/">SliTaz GNU/Linux</a>,
			boot.slitaz.org vous permet de démarrer SliTaz depuis le
			réseau en utilisant un CD-ROM, une clé USB ou une disquette
			de démarrage.
		</p>
		<p>
			Téléchargement rapide :
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
	<a href="../de/">Deutsch</a>
	<a href="../en/">English</a>
	<b>Français</b>
	<a href="../pt/">Português</a>
	<a href="../ru/">Русский</a>
</div>


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
	CD-ROM.</li>

	<li>Image ISO SliTaz boot : Téléchargez le fichier
	<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
	(<a href="http://mirror.slitaz.org/boot/slitaz-boot.md5">md5</a>)
	et gravez l'image sur un CD-ROM vierge. Démarrez depuis le CD-ROM et
	choisissez l'option iPXE. Cette image ISO vous permet également de tester
	la mémoire système avec Memtest86.</li>
	<li>Média USB : Utilisez TazUSB pour générer un média USB amorçable.
	Installez le paquet <code>ipxe</code>, copiez le répertoire /boot/ipxe
	dans le répertoire boot du média USB et ajoutez une entrée dans le
	fichier de configuration de Syslinux <code>syslinux.cfg</code> :
<pre>
label web
	kernel /boot/ipxe
</pre></li>

	<li>Image de disquette : Téléchargez le fichier
	<a href="http://mirror.slitaz.org/boot/floppy-grub4dos">floppy-grub4dos</a>
	(<a href="http://mirror.slitaz.org/boot/floppy-grub4dos.md5">md5</a>)
	Transférez l'image sur une disquette vierge en utilisant la commande
	suivant : <code>dd if=floppy-grub4dos of=/dev/fd0</code>. Démarrez sur
	la disquette et choisissez l'entrée iPXE.
	Vous pouvez aussi créer une disquette uniquement pour
	<a href="http://mirror.slitaz.org/boot/ipxe">iPXE</a> afin de
	démarrer plus rapidement avec la commande: <code>dd if=ipxe of=/dev/fd0</code>.
	</li>
	<li>Démarrage réseau : si vous pouvez modifier la configuration du server DHCP,
	déclarez le serveur tftp <i>mirror.slitaz.org</i> et le fichier de boot
	<i><a href="http://mirror.slitaz.org/boot/ipxe.pxe">ipxe.pxe</a></i> :
	<ul>
	<li>pour <b>udhcpd</b>
	<pre>siaddr mirror.slitaz.org
boot_file ipxe.pxe</pre></li>
	<li>pour <b>dhcpd</b>
	<pre>next-server "mirror.slitaz.org"
filemane "ipxe.pxe"</pre></li>
	<li>pour <b>dnsmasq</b>
	<pre>dhcp-boot=ipxe.pxe,mirror.slitaz.org</pre></li>
	</ul>
	</li>
	<li>Démarrer <a href="http://mirror.slitaz.org/boot/ipxe">iPXE</a>
	depuis DOS: renommé en ipxe.exe, il peut être lancé sous DOS
	(Windows n'est pas supporté).
	</li>
</ul>


<h3>Temps de démarrage</h3>

<p>
Le temps de démarrage dépend de votre vitesse de connexion à internet
et des charges du serveur. En France avec un débit de 1 Mo il faut 5 minutes.
Vous pouvez poster vos retours d'expériences sur le Wiki, Forum ou la
liste de diffusion.
</p>


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
		Network :
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
		<a href="http://fr.wikipedia.org/wiki/SliTaz">Wikipedia</a> ·
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</div>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

</body>
</html>
