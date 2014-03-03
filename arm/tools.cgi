#!/bin/sh
#
# SliTaz ARM CGI Tools.
#
. /usr/lib/slitaz/httphelper.sh

repos="/home/slitaz/repos"
pkgs="/home/slitaz/cooking/arm/packages"
mirror="http://cook.slitaz.org/cross/arm/packages/"
hgsat="$repos/slitaz-arm"
hgcook="$repos/cookutils"

#
# Functions
#

html_header() {
	cat << EOT
<!DOCTYPE html>
<html lang="en">
<head>
	<title>SliTaz ARM $title</title>
	<meta charset="utf-8" />
	<link rel="stylesheet" type="text/css" href="style.css" />
</head>
<body>

<div id="header">
	<div id="logo"></div>
	<div id="network">
		<a href="http://bugs.slitaz.org/">Bugs</a>
		<a href="http://hg.slitaz.org/slitaz-arm">Hg</a>
		<a href="http://cook.slitaz.org/cross/arm/">Cooker</a>
	</div>
	<h1><a href="./">SliTaz ARM</a></h1>
</div>

<!-- Content -->
<div id="content">
EOT
}

html_footer() {
	cat << EOT
</div>

</body>
</html>
EOT
}

#
# Handle GET actions
#

case " $(GET) " in
	*\ doc\ *)
		header "Content-Type: text/plain"
		case "$(GET tool)" in
			cook) cat ${hgcook}/README ;;
			cross) cat ${hgcook}/doc/cross.txt ;;
			sat) cat ${hgsat}/README ;;
			*) echo "No README file for: $(GET tool)" ;;
		esac ;;
	*\ pkgs\ *)
		# TODO: link packages and add link to raw lists
		title="- Packages"
		count="$(cat $pkgs/packages.list | wc -l)"
		html_header
		echo "<h2>Packages: $count</h2>"
		IFS="|"
		cat $pkgs/packages.desc | while read pkg vers desc web deps
		do
			cat << EOT
<div>
	<b>$pkg</b> $vers
	<pre>  $desc</pre>
</div>
EOT
		done
		unset IFS
		html_footer ;;
	*)
		header "Content-Type: text/plain"
		echo "Hello World!" ;;
esac

exit 0
