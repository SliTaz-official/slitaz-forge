<!DOCTYPE html>
<html lang="ru">
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
	<h1><a href="http://boot.slitaz.org/">Веб-загрузка SliTaz</a></h1>
	<div class="network">
		<a href="http://www.slitaz.org/" class="home"></a>
		<a href="http://scn.slitaz.org/">Сообщество</a>
		<a href="http://doc.slitaz.org/">Документация</a>
		<a href="http://forum.slitaz.org/">Форум</a>
		<a href="http://bugs.slitaz.org">Баг-трекер</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	</div>
</header>

<!-- Block -->
<div class="block"><div>

	<!-- Information/image -->
	<div class="block_info">
		<header>Веб-загрузка</header>
		<p>Добро пожаловать на хост загрузки <a href="http://www.slitaz.org/"
			>SliTaz GNU/Linux</a>; boot.slitaz.org позволяет вам запустить
			SliTaz из интернета, используя CD-ROM, USB-флешку или дискету.</p>
		<p>
			Быстрая загрузка:
			<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
		</p>
	</div>

	<!-- Navigation -->
	<nav>
		<header>Сообщество</header>
		<ul>
			<li><a href="http://scn.slitaz.org/">Сеть сообщества</a></li>
			<li><a href="http://mypizza.slitaz.org/">Сборка LiveCD ISO онлайн</a></li>
			<li><a href="http://pizza.slitaz.org/">Сборка LiveCD онлайн</a></li>
			<li><a href="http://doc.slitaz.org/en:cookbook:start">Книга SliTaz
				Cookbook</a></li>
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
	<a href="../fr/">Français</a>
	<a href="../pt/">Português</a>
	<b>Русский</b>
</div>


<h2>Введение</h2>

<p>Запустите операционную систему из интернета и наслаждайтесь полной системой,
	работающей исключительно в оперативной памяти, и обладающей высокой
	скоростью и стабильностью. Ядро Linux и полная сжатая корневая файловая
	система SliTaz будет загружена в оперативную память из интернета,
	используя протоколы PXE и HTTP.</p>


<h2 id="guide">Краткое руководство</h2>

<p>Для загрузки из интернета вам понадобится работающий сервер DHCP, сервер/кеш
	DNS и интернет-маршрут по умолчанию. Всё это, как правило, имеется, если
	вы подключены к интернету через маршрутизатор.</p>

<ul>
	<li>В SliTaz Cooking есть параметр загрузки <code>web</code>, таким
		образом, вы можете использовать boot.slitaz.org из стандартного
		основного LiveCD.</li>
	<li>Загрузочные ISO-образы SliTaz: загрузите
		<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
		(<a href="http://mirror.slitaz.org/boot/slitaz-boot.md5">md5</a>)
		и запишите образ на CD-ROM. Загрузитесь с CD-ROM и выберите iPXE.
		В этом ISO-образе также содержится Memtest86 для проверки системной
		памяти.</li>
	<li>USB-флеш: Создайте загрузочную USB-флеш при помощи TazUSB. Установите
		пакет <code>ipxe</code>, скопируйте <code>/boot/ipxe</code> в папку
		<code>boot</code> на USB-флеш и добавьте пункт в файл конфигурации
		Syslinux — <code>syslinux.cfg</code>:
	<pre class="script">label web
	kernel /boot/ipxe</pre></li>
	<li>Образ дискеты: Загрузите
		<a href="http://mirror.slitaz.org/boot/floppy-grub4dos">floppy-grub4dos</a>
		(<a href="http://mirror.slitaz.org/boot/floppy-grub4dos.md5">md5</a>)
		и перенесите образ на чистую дискету при помощи команды:
		<code>dd if=floppy-grub4dos of=/dev/fd0</code>. Загрузитесь с дискеты
		и выберите пункт iPXE.</li>
</ul>


<h3>Время загрузки</h3>

<p>Время загрузки во многом зависит от сетевого подключения. С соединением
	1 МБ/с во Франции, загрузка занимает 5 минут. При желании, вы можете
	сообщить ваше время загрузки в рассылке или на форуме.</p>


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
		Сеть:
		<a href="http://scn.slitaz.org/">Сообщество</a> ·
		<a href="http://doc.slitaz.org/">Документация</a> ·
		<a href="http://forum.slitaz.org/">Форум</a> ·
		<a href="http://pkgs.slitaz.org/">Пакеты</a> ·
		<a href="http://bugs.slitaz.org">Баг-трекер</a> ·
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	</div>
	<div>
		SliTaz @
		<a href="http://twitter.com/slitaz">Twitter</a> ·
		<a href="http://www.facebook.com/slitaz">Facebook</a> ·
		<a href="http://distrowatch.com/slitaz">Distrowatch</a> ·
		<a href="http://ru.wikipedia.org/wiki/SliTaz">Википедия</a> ·
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</div>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

</body>
</html>
