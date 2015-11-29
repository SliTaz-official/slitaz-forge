# No need `<meta charset="UTF-8">` as we already have `Content-type: text/html; charset=UTF-8`.
# The HTTP Content-Type header and any BOM elements have precedence over this element.
# No need `<meta name="robots" content="index, follow, all">
# As the default value is "index, follow"
# No need to specify `type="text/css"` in the stylesheet link as html5 not required it.

case "${LANG%_*}" in
	fa) dir='rtl';;
	*)  dir='ltr';;
esac

cat << _EOF_
<!DOCTYPE html>
<html lang="${LANG%_*}" dir="$dir">
<head>
	<title>$(eval_gettext 'SliTaz Packages - Search $SEARCH')</title>
	<meta name="application-name" content="TazPkg">
	<meta name="description" content="SliTaz packages search">
	<meta name="keywords" content="SliTaz, TazPkg">
	<meta name="expires" content="never">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="shortcut icon" href="style/favicon.ico">
	<link rel="stylesheet" href="style/slitaz.min.css">
	<link rel="stylesheet" href="pkgs.css">
</head>
<body>

<script>de=document.documentElement;de.className+=(("ontouchstart" in de)?' touch':' no-touch');</script>

<header>
	<h1><a href="./">$(gettext 'SliTaz Packages')</a></h1>
	<div class="network">
		<a href="http://www.slitaz.org/" class="home" title="$(gettext 'Home')"></a>
		<a href="http://scn.slitaz.org/">$(gettext 'Community')</a>
		<a href="http://doc.slitaz.org/">$(gettext 'Doc')</a>
		<a href="http://forum.slitaz.org/">$(gettext 'Forum')</a>
		<a href="http://slitaz.pro/">$(gettext 'Pro')</a>
		<a href="http://shop.slitaz.org/">$(gettext 'Shop')</a>
		<a href="http://bugs.slitaz.org/">$(gettext 'Bugs')</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">$(gettext 'Hg')</a>
	</div>
</header>

_EOF_
