<!DOCTYPE html>
<html lang="pt">
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
			Bem vindo ao servidor de boot via rede do <a
			href="http://www.slitaz.org/en/">SliTaz GNU/Linux</a>;
			boot.slitaz.org permite a você inicializar o  SliTaz
			a partir da web usando um cdrom, mídia USB ou disquete.
		</p>
		<p>
			Link para Download:
			<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
		</p>
	</div>

	<!-- Navigation -->
	<nav>
		<header>Community</header>
		<ul>
			<li><a href="http://scn.slitaz.org/">Community Network</a></li>
			<li><a href="http://pizza.slitaz.org/">LiveCD Online Builder</a></li>
			<li><a href="http://doc.slitaz.org/pt:cookbook:start">SliTaz Cookbook</a></li>
			<li><a href="http://doc.slitaz.org/pt:handbook:genlivecd">LiveCD flavor howto</a></li>
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
	<a href="../fr/">Français</a>
	<b>Português</b>
	<a href="../ru/">Русский</a>
</div>


<h2>Introdução</h2>

<p>
	Inicialize seu sistema operacional pela internet e aproveite um
	uma distribuição GNU/Linux completa e funcional rodando na memória RAM
	com velocidade e estabilidade. O kernel Linux e o sistema de arquivos
	comprimido do SliTaz serão carregados na RAM a partir da web usando
	os protocolos PXE e HTTP.
</p>


<h2 id="guide">Guia Rápido</h2>

<p>
Para inicializar a partir da internet você necessidade de um servidor DHCP,
servidor DNS e uma rota para internet. Você já possui tudo isto caso use
um roteador para conexões de rede.
</p>
<ul>
	<li>O SliTaz Cooking possui a opção de boot <code>web</code>,
	então você pode usar boot.slitaz.org a partir do LiveCD.</li>
	<li>SliTaz boot ISO: Baixe
	<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
	(<a href="http://mirror.slitaz.org/boot/slitaz-boot.md5">md5</a>)
	e grave a imagem em um CD ROM. Inicialize pelo dispositivo de CD ROM
	e selecione gPXE. Esta imagem ISO também fornece o Memtest86 para
	testar a memória do sistema.
	</li>
	<li>Mídia USB: Use o TazUSB para gerar uma mídia USB inicializável.
	Instale o pacote <code>gpxe</code>, copie /boot/gpxe no diretório
	de boot da mídia e adicione uma entrada no arquivo de configuração do
	Syslinux <code>syslinux.cfg</code>:
	<pre class="script">
label web
	kernel /boot/gpxe
	</pre></li>
	<li>Imagem de disquete: Baixe
	<a href="http://mirror.slitaz.org/boot/floppy-grub">floppy-grub</a>
	(<a href="http://mirror.slitaz.org/boot/floppy-grub.md5">md5</a>)
	e copie a imagem para um disquete usando o comando:
	<code>dd if=floppy-grub of=/dev/fd0</code>. Inicialize pelo disquete
	e selecione a entrada gPXE.</li>
</ul>


<h3>Tempo de boot</h3>

<p>
O tempo de boot depende de sua conexão de rede. Com uma conexão de 1MB
na França, o boot leva 5 minutos. Caso deseje, você pode reportar o seu
tempo de boot na lista de discussão ou no fórum.
</p>


<h3>Configuração requerida</h3>

<p>
A entrada padrão de boot necessidade de 160MB de memória RAM. Duas entradas
estão disponíveis para boot com 24MB:
</p>
<ul>
	<li><code>tiny</code> inicia em modo texto.</li>
	<li><code>loram</code> inicia em modo gráfico.</li>
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
		<a href="http://pt.wikipedia.org/wiki/SliTaz">Wikipedia</a> ·
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</div>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

</body>
</html>
