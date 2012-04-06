<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>SliTaz Web Boot</title>
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
			<img src="../images/network.png" alt="[ Home ]" /></a>
		<a href="http://scn.slitaz.org/">Сообщество</a>
		<a href="http://doc.slitaz.org/">Документация</a>
		<a href="http://forum.slitaz.org/">Форум</a>
		<a href="http://bugs.slitaz.org">Баг-трекер</a>
		<a href="http://hg.slitaz.org/">Hg</a>
	</div>
	<h1><a href="http://boot.slitaz.org/">Веб-загрузка SliTaz</a></h1>
</div>

<!-- Block -->
<div id="block">
	<!-- Navigation -->
	<div id="block_nav">
		<h4><img src="../images/users.png" alt="*" />Сообщество</h4>
		<ul>
			<li><a href="http://scn.slitaz.org/">Сеть сообщества</a></li>
			<li><a href="http://pizza.slitaz.org/">Сборка LiveCD онлайн</a></li>
			<li><a href="http://doc.slitaz.org/en:cookbook:start">Книга SliTaz
				Cookbook</a></li>
			<li><a href="http://doc.slitaz.org/en:handbook:genlivecd">LiveCD flavor howto</a></li>
		</ul>
	</div>
	<!-- Information/image -->
	<div id="block_info">
		<h4>Веб-загрузка</h4>
		<p>Добро пожаловать на хост загрузки <a href="http://www.slitaz.org/"
			>SliTaz GNU/Linux</a>; boot.slitaz.org позволяет вам запустить
			SliTaz из интернета, используя CD-ROM, USB-флешку или дискету.</p>
		<div class="button" style="padding-top: 8px;">
			Быстрая загрузка:
			<a href="http://mirror.slitaz.org/boot/slitaz-boot.iso">slitaz-boot.iso</a>
		</div>
	</div>
</div>

<!-- Languages -->
<div id="lang">
	<a href="http://www.slitaz.org/i18n.php">
		<img src="../images/locale.png" alt="i18n" /></a>
	<a href="../de/">Deutsch</a>
	<a href="../en/">English</a>
	<a href="../fr/">Français</a>
	<a href="../pt/">Português</a>
	<a href="../ru/">Русский</a>
</div>

<!-- Content -->
<div id="content">

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
		и запишите образ на CD-ROM. Загрузитесь с CD-ROM и выберите gPXE.
		В этом ISO-образе также содержится Memtest86 для проверки системной
		памяти.</li>
	<li>USB-флеш: Создайте загрузочную USB-флеш при помощи TazUSB. Установите
		пакет <code>gpxe</code>, скопируйте <code>/boot/gpxe</code> в папку
		<code>boot</code> на USB-флеш и добавьте пункт в файл конфигурации
		Syslinux — <code>syslinux.cfg</code>:
	<pre class="script">label web
	kernel /boot/gpxe</pre></li>
	<li>Образ дискеты: Загрузите
		<a href="http://mirror.slitaz.org/boot/floppy-grub">floppy-grub</a>
		(<a href="http://mirror.slitaz.org/boot/floppy-grub.md5">md5</a>)
		и перенесите образ на чистую дискету при помощи команды:
		<code>dd if=floppy-grub of=/dev/fd0</code>. Загрузитесь с дискеты
		и выберите пункт gPXE.</li>
</ul>


<h3>Время загрузки</h3>

<p>Время загрузки во многом зависит от сетевого подключения. С соединением
	1 МБ/с во Франции, загрузка занимает 5 минут. При желании, вы можете
	сообщить ваше время загрузки в рассылке или на форуме.</p>


<h3>Требуемая конфигурация</h3>

<p>Для загрузки по умолчанию необходимо 160 МБ ОЗУ. Следующие два пункта
	могут загружаться при наличии 24 МБ ОЗУ:</p>

<ul>
	<li><code>tiny</code> запускается в текстовом режиме.</li>
	<li><code>loram</code> запускается в графическом режиме.</li>
</ul>

<!-- End of content -->
</div>

<!-- Footer -->
<div id="footer">
	Copyright © <span class="year"></span>
	<a href="http://www.slitaz.org/">SliTaz</a> — Сеть:
	<a href="http://scn.slitaz.org/">Сообщество</a>
	<a href="http://doc.slitaz.org/">Документация</a>
	<a href="http://forum.slitaz.org/">Форум</a>
	<a href="http://pkgs.slitaz.org/">Пакеты</a>
	<a href="http://bugs.slitaz.org">Баг-трекер</a>
	<a href="http://hg.slitaz.org/">Hg</a>
	<p>
		SliTaz @
		<a href="http://twitter.com/slitaz">Twitter</a>
		<a href="http://www.facebook.com/slitaz">Facebook</a>
		<a href="http://distrowatch.com/slitaz">Distrowatch</a>
		<a href="http://ru.wikipedia.org/wiki/SliTaz">Википедия</a>
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</p>
</div>

</body>
</html>
