<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="pt" lang="pt">
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
			<li><a href="http://doc.slitaz.org/pt:cookbook:start">SliTaz Cookbook</a></li>
			<li><a href="http://doc.slitaz.org/pt:handbook:genlivecd">LiveCD flavor howto</a></li>
		</ul>	
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Web Boot</h4>
		<p>
			Bem vindo ao servidor de boot via rede do <a 
			href="http://www.slitaz.org/en/">SliTaz GNU/Linux</a>;
			boot.slitaz.org permite a voc� inicializar o  SliTaz 
			a partir da web usando um cdrom, m�dia USB ou disquete. 
		</p>
		<div class="button" style="padding-top: 8px;">
			Link para Download:
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
	<a href="../fr/">Fran�ais</a>
	<a href="../pt/">Portugu�s</a>
</div>

<!-- Content -->
<div id="content">

<h2>Introdu��o</h2>

<p>
	Inicialize seu sistema operacional pela internet e aproveite um
	uma distribui��o GNU/Linux completa e funcional rodando na mem�ria RAM
	com velocidade e estabilidade. O kernel Linux e o sistema de arquivos
	comprimido do SliTaz ser�o carregados na RAM a partir da web usando
	os protocolos PXE e HTTP.
</p>

<a name="guide"></a>
<h2>Guia R�pido</h2>
<p>
Para inicializar a partir da internet voc� necessidade de um servidor DHCP,
servidor DNS e uma rota para internet. Voc� j� possui tudo isto caso use
um roteador para conex�es de rede.
</p>
<ul>
	<li>O SliTaz Cooking possui a op��o de boot <code>web</code>, 
	ent�o voc� pode usar boot.slitaz.org a partir do LiveCD.</li>
	<li>SliTaz boot ISO: Baixe
	<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
	(<a href="http://mirror.slitaz.org/boot/slitaz-boot.md5">md5</a>)
	e grave a imagem em um cdrom. Inicialize pelo dispositivo de cdrom
	e selecione gPXE. Esta imagem ISO tamb�m fornece o Memtest86 para
	testar a mem�ria do sistema.
	</li>
	<li>M�dia USB: Use o TazUSB para gerar uma m�dia USB inicializ�vel. 
	Instale o pacote <code>gpxe</code>, copie /boot/gpxe no diret�rio
	de boot da m�dia e adicione uma entrada no arquivo de configura��o do
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
O tempo de boot depende de sua conex�o de rede. Com uma conex�o de 1MB
na Fran�a, o boot leva 5 minutos. Caso deseje, voc� pode reportar o seu
tempo de boot na lista de discuss�o ou no f�rum.
</p>

<h3>Configura��o requerida</h3>
<p>
A entrada padr�o de boot necessidade de 160MB de mem�ria RAM. Duas entradas
est�o dispon�veis para boot com 24MB:
</p>
<ul>
	<li><code>tiny</code> inicia em modo texto.</li>
	<li><code>loram</code> inicia em modo gr�fico.</li>
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
