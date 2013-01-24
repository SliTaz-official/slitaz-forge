cat << _EOF_
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta charset="utf-8" />
	<title>$(eval_gettext "SliTaz Packages - Search \$SEARCH")</title>
	<meta name="description" content="slitaz packages search" />
	<meta name="keywords" lang="en" content="SliTaz, Tazpkg" />
	<meta name="robots" content="index, follow, all" />
	<meta name="expires" content="never" />
	<link rel="shortcut icon" href="style/favicon.ico" />
	<link rel="stylesheet" type="text/css" href="style/slitaz.css" />
	<link rel="stylesheet" type="text/css" href="pkgs.css" />
</head>
<body>

<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://www.slitaz.org/">$(gettext Home)</a>
		<a href="http://scn.slitaz.org/">$(gettext Community)</a>
		<a href="http://doc.slitaz.org/">$(gettext Doc)</a>
		<a href="http://forum.slitaz.org/">$(gettext Forum)</a>
		<a href="http://slitaz.pro/">$(gettext Pro)</a>
		<a href="http://shop.slitaz.org/">$(gettext Shop)</a>
		<a href="http://bugs.slitaz.org/">$(gettext Bugs)</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">$(gettext Hg)</a>
	</div>
	<h1><a href="./">$(gettext "SliTaz Packages")</a></h1>
</div>

_EOF_
