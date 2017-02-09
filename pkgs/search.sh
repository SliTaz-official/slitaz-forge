#!/bin/sh -v
#
# Tiny CGI search engine for SliTaz packages on http://pkgs.slitaz.org/
# Christophe Lincoln <pankso@slitaz.org>
# Aleksej Bobylev <al.bobylev@gmail.com>
#

date_start="$(date -u +%s)"

renice -n 19 $$


# Parse query string

. /etc/slitaz/slitaz.conf
. /usr/lib/slitaz/httphelper.sh
cache='/var/cache/pkgs'
mkdir -p "$cache"

_()  { local T="$1"; shift; printf "$(gettext "$T")" "$@"; echo; }
_n() { local T="$1"; shift; printf "$(gettext "$T")" "$@"; }
_p() { local S="$1" P="$2" N="$3"; shift 3; printf "$(ngettext "$S" "$P" "$N")" "$@"; }


[ -n "$MIRROR_URL" ] || MIRROR_URL="http://mirror.slitaz.org"


# User preferred language
# parameter $1 have priority; without parameter $1 - browser language only
# if we don't support any of user languages (or only en), then return C locale

user_lang() {
	unset LANG
	IFS=','
	for lang in $1 $HTTP_ACCEPT_LANGUAGE; do
		lang=${lang%;*}; lang=${lang# }; lang=${lang%-*}; lang=${lang%_*}
		case "$lang" in
			de) LANG='de_DE';;
			en) LANG='en_US';;
			es) LANG='es_ES';;
			fa) LANG='fa_IR';;
			fr) LANG='fr_FR';;
			#it) LANG='it_IT';;		# We haven't Italian translations
			pl) LANG='pl_PL';;
			pt) LANG='pt_BR';;
			ru) LANG='ru_RU';;
			sv) LANG='sv_SE';;
			uk) LANG='uk_UA';;
			zh) LANG='zh_TW';;
		esac
		[ -n "$LANG" ] && break
	done
	unset IFS
	echo "${LANG:-C}"
}


# Part of query to indicate current debug mode

ifdebug() {
	ifdebug="$(GET debug)"
	[ -n "$ifdebug" ] && ifdebug="$1$ifdebug"
	echo "$ifdebug"
}


# GET or POST variable

GETPOST() {
	echo "$(POST $1)$(GET $1)"
}


# Nice URL replacer - to copy URL from address bar
# TODO: deal with POST method of form submitting

nice_url() {
	# if user submitted a form
	if [ "$REQUEST_METHOD" == 'POST' -o -n "$(GET submit)" ]; then
		OBJECT="$(GETPOST object)"
		SEARCH="$(GETPOST query)"
		case $OBJECT in
			Package)		NICE="package=$SEARCH";;
			Desc)			NICE="desc=$SEARCH";;
			Tags)			NICE="tags=$SEARCH";;
			Arch)			NICE="arch=$SEARCH";;
			Bugs)			NICE="bugs=$SEARCH";;
			Receipt)		NICE="receipt=$SEARCH";;
			Depends)		NICE="depends=$SEARCH";;
			BuildDepends)	NICE="builddepends=$SEARCH";;
			File)			NICE="file=$SEARCH";;
			File_list)		NICE="filelist=$SEARCH";;
			FileOverlap)	NICE="fileoverlap=$SEARCH";;
			Category)		NICE="category=$SEARCH";;
			Maintainer)		NICE="maintainer=$SEARCH";;
			License)		NICE="license=$SEARCH";;
		esac

		# version, if needed
		version="$(GETPOST version)"
		if [ -n "$version" -a "$version" != 'cooking' -a "$version" != 'c' ]; then
			NICE="$NICE&version=${version:0:1}"
		fi

		# lang, if needed
		query_lang="$(GETPOST lang)"
		pref_lang="$(user_lang)"
		browser_lang="${pref_lang%_*}"
		if [ -n "$query_lang" ]; then
			COOKIE="lang=$query_lang"
		else
			COOKIE=''
		fi

		# verbose, if needed
		verboseq="$(GETPOST verbose)"
		if [ -n "$verboseq" -a "$verboseq" != '0' ]; then
			NICE="$NICE&verbose=1"
		fi

		# debug, if needed
		debugq="$(GET debug)"
		if [ -n "$debugq" -a "$debugq" == 'debug' ]; then
			NICE="$NICE&debug"
		fi

		# redirect
		if [ -z "$COOKIE" ]; then
			header "HTTP/1.1 301 Moved Permanently" "Location: ?$NICE"
		else
			header "HTTP/1.1 301 Moved Permanently" "Set-Cookie: $COOKIE" "Location: ?$NICE"
		fi
		exit 0
	fi
}


nice_url




# Internationalization
. /usr/bin/gettext.sh
export TEXTDOMAIN='tazpkg-web'
# Translate actions once
a_co="$(_ 'Cooker')"
a_dl="$(_ 'Download')"
a_rc="$(_ 'Receipt')"




# Cache icons to fast search
# Find the latest update in the "icons" folder
unset ICONS_CACHE_REBUILDED
iconslast="$cache/icons.$(date -u +%s -r /var/www/pkgs/icons/$(ls -t /var/www/pkgs/icons | head -n1))"

if [ ! -f "$iconslast" ]; then
	find "$cache" -name 'icons.*' -delete

	(
		cat icons/packages.icons
		awk '{printf "%s\tcli\n",$1}'  icons/packages-cli.icons
		awk '{printf "%s\tdoc\n",$1}'  icons/packages-doc.icons
		awk '{printf "%s\tfont\n",$1}' icons/packages-font.icons
		awk '{printf "%s\ti18n\n",$1}' icons/packages-i18n.icons
		awk '{printf "%s\tthm\n",$1}'  icons/packages-thm.icons
		awk '{printf "%s\tlib\n",$1}'  icons/packages-lib.icons
		awk '{printf "%s\tpy\n",$1}'   icons/packages-py.icons
		awk '{printf "%s\tperl\n",$1}' icons/packages-perl.icons
		ls icons/*.png | awk -F/ '{sub(/\.png/,"",$2);printf "%s\t%s\n", $2, $2}'
	) | sort > "$iconslast"
	ICONS_CACHE_REBUILDED='yes'
fi



unset SEARCH SLITAZ_VERSION
VERBOSE=0
s='selected'
for i in $(echo $QUERY_STRING | sed 's/[?&]/ /g'); do
	case "$(echo $i | tr [A-Z] [a-z])" in
		query=*|search=*)		[ ${i#*=} == Search ] || SEARCH=${i#*=};;
		object=*)				OBJECT=${i#*=};;
		verbose=*)				VERBOSE=${i#*=};;
		lang=*)					LANG=${i#*=};;
		file=*)					SEARCH=${i#*=}; OBJECT='File';         sel_file=$s;;
		desc=*)					SEARCH=${i#*=}; OBJECT='Desc';         sel_desc=$s;;
		tags=*)					SEARCH=${i#*=}; OBJECT='Tags';         sel_tags=$s;;
		arch=*)					SEARCH=${i#*=}; OBJECT='Arch';         sel_arch=$s;;
		bugs=*)					SEARCH=${i#*=}; OBJECT='Bugs';         sel_bugs=$s;;
		receipt=*)				SEARCH=${i#*=}; OBJECT='Receipt';      sel_rcpt=$s;;
		filelist=*)				SEARCH=${i#*=}; OBJECT='File_list';    sel_flst=$s;;
		package=*)				SEARCH=${i#*=}; OBJECT='Package';;
		depends=*)				SEARCH=${i#*=}; OBJECT='Depends';      sel_deps=$s;;
		builddepends=*)			SEARCH=${i#*=}; OBJECT='BuildDepends'; sel_bdps=$s;;
		fileoverlap=*)			SEARCH=${i#*=}; OBJECT='FileOverlap';  sel_over=$s;;
		category=*)				SEARCH=${i#*=}; OBJECT='Category';     sel_catg=$s;;
		maintainer=*)			SEARCH=${i#*=}; OBJECT='Maintainer';   sel_mtnr=$s;;
		license=*)				SEARCH=${i#*=}; OBJECT='License';      sel_lcns=$s;;
		version=1*)				SLITAZ_VERSION='1.0';       sel_1=$s;;
		version=2*)				SLITAZ_VERSION='2.0';       sel_2=$s;;
		version=3*)				SLITAZ_VERSION='3.0';       sel_3=$s;;
		version=s*|version=4*)	SLITAZ_VERSION='stable';    sel_s=$s;;
		version=u*)				SLITAZ_VERSION='undigest';  sel_u=$s;;
		version=b*)				SLITAZ_VERSION='backports'; sel_b=$s;;
		version=t*)				SLITAZ_VERSION='tiny';      sel_t=$s;;
	esac
done
[ -z "$SLITAZ_VERSION" ] && SLITAZ_VERSION='cooking'
addver=''; [ "$SLITAZ_VERSION" != 'cooking' ] && addver="&amp;version=$SLITAZ_VERSION"
SEARCH="${SEARCH//%20/ }"

#
# Content negotiation for Gettext
#

LANG=$(user_lang $(COOKIE lang))
lang="${LANG%_*}"
export LANG LC_ALL=$LANG


#
# Unescape query and set vars
#

SEARCH="$(echo $SEARCH | sed 's|%2B|+|g; s|%3A|:|g; s|%2F|/|g')"

SLITAZ_HOME="/home/slitaz"
if [ "$SLITAZ_VERSION" == 'cooking' ]; then
	WOK="$SLITAZ_HOME/wok"
else
	WOK="$SLITAZ_HOME/wok-$SLITAZ_VERSION"
fi

pkgsrepo="$SLITAZ_HOME/$SLITAZ_VERSION/packages"
repoid="$(cat "$pkgsrepo/ID")"
filelist="$pkgsrepo/files.list.lzma"
pkglist="$pkgsrepo/packages.txt"
equiv="$pkgsrepo/packages.equiv"
pinfo="$pkgsrepo/packages.info"

# Date of the last modification (both packages DB or icons DB)
if [ -f "$pkgsrepo/ID" ]; then
	if [ "$iconslast" -nt "$pkgsrepo/ID" ]; then
		lastmod="$(date -Rur "$iconslast")"
	else
		lastmod="$(date -Rur "$pkgsrepo/ID")"
	fi
	lastmod="${lastmod/UTC/GMT}"
fi




# Search form
# TODO: add hint 'You are can search for depends loop, if textfield is empty'...
# add progress ticker while page is not complete

search_form() {
	[ -z "$SEARCH$(GET info)" ] && autofocus='autofocus'

	cat <<EOT

<div class="form">
<form id="s_form" name="s_form" method="post" action="$(ifdebug '?')">
	<span class="small">
		<select name="object">
			<option value="Package" class="pkg">$(_ 'Package name')</option>
			<option $sel_desc value="Desc" class="description">$(_ 'Description')</option>
			<option $sel_tags value="Tags" class="tag">$(_ 'Tag')</option>
			<option $sel_arch value="Arch" class="arch">$(_ 'Architecture')</option>
			<option $sel_bugs value="Bugs" class="bugs">$(_ 'Bugs')</option>
			<option $sel_rcpt value="Receipt" class="receipt">$(_ 'Receipt')</option>
			<option $sel_deps value="Depends" class="dep">$(_ 'Dependencies')</option>
			<option $sel_bdps value="BuildDepends" class="dep">$(_ 'Build dependencies')</option>
			<option $sel_file value="File" class="file">$(_ 'File')</option>
			<option $sel_flst value="File_list" class="files-list">$(_ 'File list')</option>
			<option $sel_over value="FileOverlap" class="common">$(_ 'Common files')</option>
			<option $sel_catg value="Category" class="category">$(_ 'Category')</option>
			<option $sel_mtnr value="Maintainer" class="avatar">$(_ 'Maintainer')</option>
			<option $sel_lcns value="License" class="license">$(_ 'License')</option>
		</select>
	</span>
	<span class="stretch">
		<input $autofocus type="search" name="query" id="query" value="$SEARCH$(GET info)"
		autocorrect="off" autocapitalize="off" autocomplete="on" spellcheck="false"
		results="5" autosave="pkgsearch"/>
	</span>
	<span class="small">
		<select name="version" title="$(_ 'SliTaz version')">
			<option value="cooking">$(			_ 'cooking')</option>
			<option $sel_s value="stable">4.0</option>
			<option $sel_3 value="3.0">3.0</option>
			<option $sel_2 value="2.0">2.0</option>
			<option $sel_1 value="1.0">1.0</option>
			<option $sel_t value="tiny">$(		_ 'tiny')</option>
			<option $sel_u value="undigest">$(	_ 'undigest')</option>
			<option $sel_b value="backports">$(	_ 'backports')</option>
		</select>
	</span>
	<span class="small">
		<button type="submit">$(_ 'Search')</button>
	</span>
</form>
</div>
EOT
}


# xHTML5 Header.

xhtml_header() {
	. lib/header.sh
}


# FIXME: unused function

cat_files_list() {
	local tmp="/tmp/files.list.$(basename ${1%/packages})"
	if [ ! -s "$tmp" -o "$1/files.list.lzma" -nt "$tmp" ]; then
		unlzma < "$1/files.list.lzma" > "$tmp.$$" && mv "$tmp.$$" "$tmp"
	fi
	case "$2" in
		lines)
			if [ ! -s "$tmp.lines" -o "$tmp" -nt "$tmp.lines" ]; then
				wc -l < "$tmp" > "$tmp.lines.$$" &&
				mv "$tmp.lines.$$" "$tmp.lines"
			fi
			cat "$tmp.lines"
			;;
		*)
			cat "$tmp";;
	esac
}




# xHTML Footer.

xhtml_footer() {
	# Number of packages in the current repo
	if [ ! -f "$cache/stat.p.$SLITAZ_VERSION.$repoid" ]; then
		rm $cache/stat.p.$SLITAZ_VERSION.*
		ls "$WOK/" | wc -l > "$cache/stat.p.$SLITAZ_VERSION.$repoid"
	fi

	# Number of files in the current repo
	if [ ! -f "$cache/stat.f.$SLITAZ_VERSION.$repoid" ]; then
		rm $cache/stat.f.$SLITAZ_VERSION.*
		unlzma < "$filelist" | wc -l > "$cache/stat.f.$SLITAZ_VERSION.$repoid"
	fi

	PKGS=$( cat "$cache/stat.p.$SLITAZ_VERSION.$repoid")
	FILES=$(cat "$cache/stat.f.$SLITAZ_VERSION.$repoid")
	echo -en '\n<div class="summary">'
	_p '%s package' '%s packages' "$PKGS" \
		"$PKGS"
	_p ' and %s file in %s database' ' and %s files in %s database' "$FILES" \
		"$FILES" "$SLITAZ_VERSION"

	# Date of the last update...
	echo -n ' ('
	if [ -e "$pkgsrepo/IDs" ]; then
		# ...based on the value inside IDs
		date +"%c" -d@$(cut -d' ' -f2 "$pkgsrepo/IDs") | tr -d '\n'
	elif [ -e "$pkgsrepo/ID" ]; then
		# ...based on the date of ID
		date +"%c" -r "$pkgsrepo/ID" | tr -d '\n'
	else
		# ...based on the date of the newest file
		date +"%c" -r "$pkgsrepo/$(ls -Lt "$pkgsrepo" | head -n1)" | tr -d '\n'
	fi
	echo -n ')'

	cat <<EOT
</div>
</main>

EOT

	local lang="${LANG%_*}"
	if [ -e "lib/footer.$lang.sh" ]; then
		echo '<footer>'
		. lib/footer.$lang.sh
	else
		echo '<footer dir="ltr">'
		. lib/footer.sh
	fi

	echo -n '<div class="summary">'
	gen_time=$(( $(date -u +%s) - $date_start ))
	_p 'Page generated in %s second.' 'Page generated in %s seconds.' "$gen_time" \
		"$gen_time"

	cat <<EOT
	</div>
	<img src="style/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

<script>
function QRCodePNG(str, obj) {
	try {
		obj.height = obj.width += 300;
		return QRCode.generatePNG(str, {ecclevel: 'H'});
	}
	catch (any) {
		var element = document.createElement("script");
		element.src = "style/qrcode.min.js";
		element.type ="text/javascript";
		element.onload = function() {
			obj.src = QRCode.generatePNG(str, {ecclevel: 'H'});
		};
		document.body.appendChild(element);
	}
}

document.getElementById('ticker').style.visibility='hidden';
</script>
</body>
</html>
EOT
	exit 0
}




# TODO: to remove

installed_size() {
	if [ $VERBOSE -gt 0 ]; then
		inst=$(grep -A 3 "^$1\$" $pkgslist | grep installed)
#		size=$(echo $inst | cut -d'(' -f2 | cut -d' ' -f1)
		echo $inst | sed 's/.*(\(.*\).*/(\1)/'
#		echo $size
#		 | sed 's/.*(\(.*\) installed.*/(\1) /'
	fi
}




# Package icon

package_icon() {
	local icon='pkg'

	case "$1" in
		*-dev) icon='dev';;
		linux-*|linux64-*) icon='linux';;
		xorg-*) icon='xorg';;
		*) icon=$(awk -F$'\t' -vp="$1" '$1==p{print $2;exit}' "$iconslast");;
	esac
	echo "icons$2/${icon:-pkg}.png"
}




package_entry() {

	# Level for packages tree
	if [ -n "$1" ]; then
		echo "<tr class=\"l$1\">"
	else
		echo '<tr>'
	fi

	PACKAGE_URL="$MIRROR_URL/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION$EXTRAVERSION.tazpkg"

	case "$SLITAZ_VERSION" in
		cooking)
			COOKER="<a href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\" class=\"co\" title=\"$a_co\">$a_co</a>"
			;;
		stable|undigest|backports)
			COOKER="<a href=\"http://cook.slitaz.org/$SLITAZ_VERSION/cooker.cgi?pkg=$PACKAGE\" class=\"co\" title=\"$a_co\">$a_co</a>"
			;;
		*)
			COOKER=''
			;;
	esac

	cat <<EOT
	<td class="first"><a href="?info=$PACKAGE$addver"><img src="$(package_icon $PACKAGE)" alt="$PACKAGE icon"/></a></td>
	<td><b>$PACKAGE</b><br/>$SHORT_DESC</td>
	<td class="last">
		<a class="dl" href="$PACKAGE_URL" title="$a_dl">$a_dl</a>
		<a class="rc" href="?receipt=$PACKAGE$addver" title="$a_rc">$a_rc</a>
		$COOKER
	</td>
</tr>
EOT
}


package_entries() {
	# Input: $1 = [ desc | category | tags | name ]
	#        $2 = query

	awk -F$'\t' -vtype="$1" -vquery="$2" -vmurl="$MIRROR_URL" -vver="$SLITAZ_VERSION" \
		-vaco="$a_co" -vadl="$a_dl" -varc="$a_rc" -viconslast="$iconslast" \
		-vnf="$(_ 'Nothing found')" -vaddver="$addver" '
BEGIN {
	IGNORECASE = 1;
	print "<table class=\"list\">";
	notfound = "y";
}

function cooker() {
	if (ver!="cooking" && ver!="stable" && ver!="undigest" && ver!="backports") return;

	printf "\t<a href=\"http://cook.slitaz.org/";
	if (ver=="stable" || ver=="undigest" || ver=="backports") printf "%s/", ver;
	printf "cooker.cgi?pkg=%s\" class=\"co\" title=\"%s\">%s</a>", $1, aco, aco;
}

function icon(pkg) {
	i="";
	if (pkg ~ /-dev$/) { return "dev"; }
	if (pkg ~ /^linux(64)?-/) { return "linux"; }
	if (pkg ~ /^xorg-/) { return "xorg"; }
	"awk -vp=\"" pkg "\" \"BEGIN{FS=\\\"\t\\\"}\\\$1==p{print \\\$2;exit}\" " iconslast | getline i;
	if (i) { return i; }
	return "pkg";
}

function tabline() {
	markname = $1; if (type=="name") gsub(query, "<mark>&</mark>", markname);
	markdesc = $4; if (type=="desc") gsub(query, "<mark>&</mark>", markdesc);
	printf "<tr>\n\t<td class=\"first\">"
	printf "<a href=\"?info=%s%s\">", gensub(/\+/, "%2B", "g", $1), addver;
	printf "<img src=\"icons/%s.png\" alt=\"%s icon\"/></a></td>\n", icon($1), $1;
	printf "\t<td><b>%s</b><br/>%s</td>\n", markname, markdesc;
	printf "\t<td class=\"last\">\n";
	printf "\t<a class=\"dl\" href=\"%s\" ", murl "/packages/" ver "/" $1 "-" $2 ".tazpkg";
	printf "title=\"%s\">%s</a>\n", adl, adl;
	printf "\t<a class=\"rc\" href=\"?receipt=%s%s\" ", $1, addver;
	printf "title=\"%s\">%s</a>\n", arc, arc;
	cooker();
	printf "</td>\n</tr>\n"
}


{
	if (type=="name"     && match($1, query)) { tabline(); notfound = ""; }
	if (type=="category" && $3==query)        { tabline(); notfound = ""; }
	if (type=="desc"     && match($4, query)) { tabline(); notfound = ""; }
	if (type=="tags"     && match(" "$6" ", " "query" ")) { tabline(); notfound = ""; }
}

END {
	if (notfound) printf "<tr><td class=\"first\"><img src=\"icons/notfound.png\" alt="Not found"/></td><td><b>%s</b></td></tr>", nf;
	print "</table>";
}
' "$pinfo";
}




package_entry_inline() {
#	if [ -s "$(dirname $0)/$SLITAZ_VERSION/$CATEGORY.html" ]; then
#		cat << _EOT_
#<a href="$SLITAZ_VERSION/$CATEGORY.html#$PACKAGE">$PACKAGE</a> $(installed_size $PACKAGE) : $SHORT_DESC
#_EOT_
#	else
		PACKAGE_URL="$MIRROR_URL/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION$EXTRA_VERSION.tazpkg"
		PACKAGE_HREF="<a href=\"$PACKAGE_URL\">$PACKAGE</a>"
		case "$SLITAZ_VERSION" in
			cooking)
				COOKER="<a href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\">$a_co</a>";;
			stable|undigest|backports)
				COOKER="<a href=\"http://cook.slitaz.org/$SLITAZ_VERSION/cooker.cgi?pkg=$PACKAGE\">$a_co</a>";;
			*)
				COOKER='';;
		esac
		cat <<EOT
$PACKAGE_HREF $(installed_size $PACKAGE) : $SHORT_DESC \
<a href="?receipt=$PACKAGE&amp;version=$SLITAZ_VERSION">$a_rc</a>&nbsp;$COOKER
EOT
#	fi
}


# Show loop in depends/build_depends chains

show_loops() {
	awk '
function chkloop(pkg, i, n)
{
	if (n < 8)
	for (i = 1; i <= split(deps[pkg],curdep," "); i++) {
		if (curdep[i] == base || chkloop(curdep[i], 0, n+1)) {
			split(deps[pkg],curdep," ")
			p = curdep[i] " " p
			return 1
		}
	}
	return 0
}
{
	for (i = 2; i <= NF; i++)
		deps[$1] = deps[$1] " " $i
}
END {
	for (pkg in deps) {
		base = pkg
		p = ""
		if (chkloop(pkg, 0, 0))
			print pkg " " p
			#print pkg " : " p "..."
	}
}' | while read line; do
	set -- $line
	case " $last " in
	*\ $1\ *) continue
	esac
	last="$line"
	pkg=$1
	shift
	echo "<strong>$pkg </strong>: $@ ..."
done
}


# recursive dependencies scan

dep_scan() {
	for i in $1; do
		case " $ALL_DEPS " in
			*\ $i\ *)
				continue;;
		esac
		ALL_DEPS="$ALL_DEPS $i"
		if [ -n "$2" ]; then
			echo -n "$2"
			(
			. $WOK/$i/receipt
			package_entry_inline
			)
		fi
		[ -f $WOK/$i/receipt ] || continue
		unset BUILD_DEPENDS DEPENDS WANTED
		. $WOK/$i/receipt
		if [ -n "$3" ]; then
			[ -n "$BUILD_DEPENDS$WANTED" ] &&
			dep_scan "$WANTED $BUILD_DEPENDS" "$2    " $3
		else
			[ -n "$DEPENDS" ] && dep_scan "$DEPENDS" "$2    "
		fi
	done
}


# recursive reverse dependencies scan

rdep_scan() {
SEARCH=$1
case "$SEARCH" in
glibc-base|gcc-lib-base)
	_ '"glibc-base" and "gcc-lib-base" are implicit dependencies, <b>every</b> package is supposed to depend on them.'
	return;;
esac
for i in $WOK/* ; do
	unset BUILD_DEPENDS DEPENDS WANTED
	. $i/receipt
	if [ -n "$2" ]; then
		echo "$(basename $i) $(echo $WANTED $BUILD_DEPENDS)"
	else
		echo "$(basename $i) $(echo $DEPENDS)"
	fi
done | awk -v search=$SEARCH '
function show_deps(deps, all_deps, pkg, space)
{
	if (all_deps[pkg] == 1) return
	all_deps[pkg] = 1
	if (space != "") printf "%s%s\n",space,pkg
	for (i = 1; i <= split(deps[pkg], mydeps, " "); i++) {
		show_deps(deps, all_deps, mydeps[i],"////" space)
	}
}

{
	all_deps[$1] = 0
	for (i = 2; i <= NF; i++)
		deps[$i] = deps[$i] " " $1
}

END {
	show_deps(deps, all_deps, search, "")
}
' | while read pkg; do
		. $WOK/${pkg##*/}/receipt
		cat << _EOT_
$(echo ${pkg%/*} | sed 's|/| |g') $(package_entry_inline)
_EOT_
done
}




# Check non-empty argument

check_n() {
	if [ -z "$1" ]; then
		cat <<EOT
<div class="err">$(_ 'Please specify name of the package.')</div>
<p> <br/> </p>
EOT
		return 1
	fi
}


# Check package existence

package_exist() {
	check_n "$1"

	if [ ! -f "$WOK/$1/receipt" ]; then
		cat <<EOT
<div class="err">$(_ 'Package "%s" was not found' "$1")</div>
<p> <br/> </p>
EOT
		return 1
	fi

	return 0
}




# Display < > &

htmlize() {
	sed -e 's|&|\&amp;|g; s|<|\&lt;|g; s|>|\&gt;|g'
}




display_packages_and_files() {
	unset last
	while read pkg file; do
		pkg=${pkg%:}
		if [ "$pkg" != "$last" ]; then
			. "$WOK/$pkg/receipt"

			package_entry_inline
			last="$pkg"
		fi
		echo "    $file"
	done
}


# Syntax highlighting for receipt file - stolen from tazpanel:
# '/var/www/tazpanel/lib/libtazpanel' and developed

syntax_highlighter() {
	. $1
	sed -e "s|\&|\&amp;|g; s|<|\&lt;|g; s|>|\&gt;|g; s|	|    |g" \
			-e "s|@|\&#64;|g; s|~|\&#126;|g" \
	-e "#literals" \
			-e "s|'\([^']*\)'|@l\0~|g" \
			-e 's|"\([^"]*\)"|@l\0~|g' \
			-e 's|"\([^"]*\)\\|@l\0~|g' \
			-e 's|\([^"]*\)\"$|@l\0~|g' \
	-e "#paths" \
			-e 's|\([ =]\)\([a-zA-Z0-9/-]*/[\$a-zA-Z0-9/\.-]\+\)\([ )]\)|\1@p\2~\3|g' \
			-e 's|\([ =]\)\([a-zA-Z0-9/-]*/[\$a-zA-Z0-9/\.-]\+$\)|\1@p\2~|g' \
			-e 's|\(\$[a-zA-Z0-9_\.-]\+\)\(/[\$a-zA-Z0-9_/\.\*-]\+\)\([ )]*\)|@p\1\2~\3|g' \
	-e "#functions" \
			-e 's|^\([^()]*\)\(()\)|@f\0~|g' \
	-e "#single line comments" \
			-e 's|^\([ ]*\)#\([^#]*$\)|@c\0~|g' \
	-e "#parameters" \
			-e 's|\( \)\(-[a-z0-9]\+\)\( *\)|\1@r\2~\3|g' \
			-e 's|\( \)\(--[a-z0-9\-]\+\)\([= ]\)|\1@r\2~\3|g' \
	-e "#variables" \
			-e "s|^\([^=@#' \-]*\)\(=\)|@v\1~\2|g" \
			-e 's|\([ ^@-]*\)\([a-zA-Z0-9]\+\)\(=\)|\1@v\2~\3|g' \
			-e "s#\(\$[a-zA-Z0-9_]\+\)#@v\0~#g" \
	-e "#urls" \
			-e s"#\"\(http:[^\"\$ ]*\)\"#\"<a @u href=\0>\1</a>\"#"g \
			-e s"#\"\(ftp:[^\"\$ ]*\)\"#\"<a @u href=\0>\1</a>\"#"g \
	-e "#commands" \
			-e s"#^\( \+\)\([^'= @\-]\+\)#\1@m\2~#"g \
	-e "#simple commands" \
			-e s"#\([{}\]$\)#@s\0~#"g \
			-e s"#\( \)\(\&amp;\&amp;\)\( *\)#\1@s\2~\3#"g \
			-e s"#\(|\)#@s\0~#"g \
			-e s"#\(\&lt;\)#@s\0~#"g \
			-e s"#\(\&gt;\&amp;\)#@s\0~#"g \
			-e s"#\(\&gt;\)#@s\0~#"g \
			-e s"#\(\[\)#@s\0~#"g \
			-e s"#\(\]\)#@s\0~#"g \
\
			-e "s|´|'|g; s|›|</span>|g" \
			-e "s|@c|<span class='r-comment'>|g" \
			-e "s|@l|<span class='r-literal'>|g" \
			-e "s|@v|<span class='r-var'>|g" \
			-e "s|@f|<span class='r-func'>|g" \
			-e "s|@u|class='r-url' target='_blank'|g" \
			-e "s|@m|<span class='r-com'>|g" \
			-e "s|@s|<span class='r-scom'>|g" \
			-e "s|@p|<span class='r-path'>|g" \
			-e "s|@r|<span class='r-param'>|g" \
			-e "s|~|</span>|g" < "$1" | add_url_links
}


# Create some clickable links

add_url_links() {
	local tarball_url
	sedit=''
	case "$SLITAZ_VERSION" in
		cooking)
			[ -n "$VERSION" ] &&
			sedit="$sedit -e 's|\\(>VERSION<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\">\\2</a>|}'"
			;;
		stable|undigest|backports)
			[ -n "$VERSION" ] &&
			sedit="$sedit -e 's|\\(>VERSION<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"http://cook.slitaz.org/$SLITAZ_VERSION/cooker.cgi?pkg=$PACKAGE\">\\2</a>|}'"
			;;
	esac
	#[ -n "$WEB_SITE" ] && sedit="$sedit -e '/WEB_SITE/{s|\\($WEB_SITE\\)|<a class='r-url' target='_blank' href=\"\\1\">\\1</a>|}'"

	[ -n "$WGET_URL" ] &&
	sedit="$sedit -e 's|\\(>WGET_URL<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"${WGET_URL//|/\\|}\">\\2</a>|}'"

	[ -n "$MAINTAINER" ] &&
	sedit="$sedit -e '/MAINTAINER/{s|\\(${MAINTAINER/@/&#64;}\\)|<a class='r-url' target='_blank' href=\"?maintainer=\\1\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"

	[ -n "$CATEGORY" ] &&
	sedit="$sedit -e '/CATEGORY/{s|\\($CATEGORY\\)|<a class='r-url' target='_blank' href=\"?category=\\1\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"

	[ -f "$WOK/$PACKAGE/description.txt" ] &&
	sedit="$sedit -e '/SHORT_DESC/{s|\\($SHORT_DESC\\)|<a class='r-url' target='_blank' href=\"?desc=$PACKAGE\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"

	tarball_url=sources/packages-$SLITAZ_VERSION/${TARBALL:0:1}/$TARBALL
	[ -f /var/www/slitaz/mirror/$tarball_url ] || case "$tarball_url" in
		*.gz)	tarball_url=${tarball_url%gz}lzma ;;
		*.tgz)	tarball_url=${tarball_url%tgz}tar.lzma ;;
		*.bz2)	tarball_url=${tarball_url%bz2}lzma ;;
	esac
	[ -f /var/www/slitaz/mirror/$tarball_url ] && sedit="$sedit -e 's|\\(>TARBALL<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"http://mirror.slitaz.org/$tarball_url\">\\2</a>|'"

	if [ -n "$EXTRA_SOURCE_FILES" ]; then
		for i in $(echo $EXTRA_SOURCE_FILES) ; do
			p="sources/packages-$SLITAZ_VERSION/${i:0:1}/$i"
			[ -f "/var/www/slitaz/mirror/$p" ] || continue
#FIXME
			sedit="$sedit -e 's|\\([\" >]\\)$i\\([\" <\\]\\)|\\1<a class='r-url' target='_blank' href=\"http://mirror.slitaz.org/$p\">$i</a>\\2|'"
			sedit="$sedit -e 's|^$i\\([\" <\\]\\)|<a class='r-url' target='_blank' href=\"http://mirror.slitaz.org/$p\">$i</a>\\1|'"
		done
	fi
	if [ -n "$DEPENDS$BUILD_DEPENDS$SUGGESTED$PROVIDE$WANTED" ]; then
		for i in $(echo $DEPENDS $BUILD_DEPENDS $SUGGESTED $PROVIDE $WANTED) ; do
			sedit="$sedit -e 's|\\([\" >]\\)$i\\([\" <\\]\\)|\\1<a class='r-url' target='_blank' href=\\\"?receipt=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>\\2|'"
			sedit="$sedit -e 's|^$i\\([\" <\\]\\)|<a class='r-url' target='_blank' href=\\\"?receipt=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>\\1|'"
		done
	fi
	if [ -n "$LICENSE" ]; then
		for i in $LICENSE ; do
			sedit="$sedit -e '/LICENSE/{s|\\($i\\)|<a class='r-url' target='_blank' href=\"?license=\\1\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"
		done
	fi
	if [ -n "$HOST_ARCH" ]; then
		for i in $HOST_ARCH ; do
			sedit="$sedit -e '/HOST_ARCH/{s|\\([\" ]\\)$i\\([\" ]\\)|\\1<a class='r-url' target='_blank' href=\\\"?arch=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>\\2|}'"
		done
	fi
	if [ -n "$TAGS" ]; then
		for i in $TAGS ; do
			sedit="$sedit -e '/TAGS/{s|\\([\" ]\\)$i\\([\" ]\\)|\\1<a class='r-url' target='_blank' href=\\\"?tags=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>\\2|}'"
		done
	fi
	eval sed $sedit \
		-e "'s|genpkg_rules|<a class='r-url' target='_blank' href=\"?filelist=$PACKAGE\\&amp;version=$SLITAZ_VERSION\">&</a>|'"
}


display_cloud() {
	arg=$1
	awk '
{
	for (i = 1; $i != ""; i++)
		count[$i]++
}
END {
	min=10000
	max=0
	cnt=0
	for (i in count) {
		if (count[i] < min) min = count[i]
		if (count[i] > max) max = count[i]
		cnt++
	}
	for (i in count) 
		print count[i] " " min " " max " " i
	print cnt
}' | sed 's/[<>]//g' | sort -k 4 | {
		while read cnt min max tag ; do
			if [ -z "$min" ]; then
				count="$cnt"
				continue
			fi
			pct=$(((($cnt-$min)*100)/($max-$min)))
			pct=$(((10000 - ((100 - $pct)**2))/100))
			pct=$(((10000 - ((100 - $pct)**2))/100))
			cat <<EOT
<span class="tagn">$cnt</span><a href="?$arg=$tag$addver" class="tag$(($pct/10))">$tag</a>
EOT
		done
		echo -n '<hr/><p class="lang">'
		case $arg in
			arch)       _p '%s architecture' '%s architectures' "$count" "$count";;
			maintainer) _p '%s maintainer'   '%s maintainers'   "$count" "$count";;
			license)    _p '%s license'      '%s licenses'      "$count" "$count";;
			category)   _p '%s category'     '%s categories'    "$count" "$count";;
			tags)       _p '%s tag'          '%s tags'          "$count" "$count";;
		esac
		echo '</p>'
	}
}


build_cloud() {
	find $WOK/ -maxdepth 2 -name receipt -exec sed \
	 "/^$1=/!d;s/.*['\"<]\\(..*\\)[>\"'].*/\\1/" {} \; | \
		display_cloud $2
}


#
# page begins
#

if [ -n "$HTTP_IF_MODIFIED_SINCE" -a "$HTTP_IF_MODIFIED_SINCE" == "$lastmod" ]; then
	# When user agent asks if content modified since last seen and it is not modified
	header "HTTP/1.1 304 Not Modified"
	exit 0
fi
if [ -z "$lastmod" ]; then
	# We don't know last modification date
	header "HTTP/1.1 200 OK" "Content-type: text/html; charset=UTF-8"
else
	header "HTTP/1.1 200 OK" "Content-type: text/html; charset=UTF-8" "Last-Modified: $lastmod"
fi
xhtml_header


#
# Language selector
#

cat <<EOT
<!-- Languages -->
<div class="lang"><a class="locale2" href="http://www.slitaz.org/i18n.php"
target="_blank"></a><select form="s_form" name="lang" onchange="this.form.submit();">
EOT

for i in en de es fa fr ja pl pt ru sv uk zh; do
	case $i in
		en) c='us'; l='English';;
		de) c='de'; l='Deutsch';;
		es) c='es'; l='Español';;
		fa) c='ir'; l='فارسی';;
		fr) c='fr'; l='Français';;
		it) c='it'; l='Italiano';;
		ja) c='jp'; l='日本語';;
		pl) c='pl'; l='Polski';;
		pt) c='br'; l='Português';;
		ru) c='ru'; l='Русский';;
		sv) c='se'; l='Svenska';;
		uk) c='ua'; l='Українська';;
		zh) c='tw'; l='中文';;
	esac

	echo -n "<option class=\"$c\" value=\"$i\""
	[ "$i" == "${LANG%_*}" ] && echo -n " selected"
	echo ">$l</option>"
done
echo '</select></div>'

cat <<EOT
<!-- Content -->
<main>
EOT


#
# Handle GET requests
#

case " $(GET) " in
	*\ debug\ *|*\ debug*)
		cat <<EOT
<h2>Debug info</h2>

<pre>$(httpinfo)</pre>

<pre>$(env)</pre>

<pre>LANG="$LANG"
OBJECT="$OBJECT"
SEARCH="$SEARCH"
SLITAZ_VERSION="$SLITAZ_VERSION"
WOK="$WOK"
GET="$(GET)"

HTTP_IF_MODIFIED_SINCE="$HTTP_IF_MODIFIED_SINCE"
lastmod               ="$lastmod"
</pre>
EOT
	;;
esac




# Display search form and result if requested.

cat <<EOT
<div id="ticker"><img src="loader.gif" alt="."/></div>
EOT
search_form




# Show links for "info" page

show_info_links() {
	if [ -n "$1" ]; then
		echo -n "<tr><td class=\"first\"><b>$2</b></td><td class=\"spkg\">"

		echo $1 | tr ' ' $'\n' | awk -vt="$3" -vv="$addver" -viconslast="$iconslast" '
function icon(pkg) {
	i="";
	if (pkg ~ /-dev$/) { return "dev"; }
	if (pkg ~ /^linux(64)?-/) { return "linux"; }
	if (pkg ~ /^xorg-/) { return "xorg"; }
	"awk -vp=\"" pkg "\" \"BEGIN{FS=\\\"\t\\\"}\\\$1==p{print \\\$2;exit}\" " iconslast | getline i;
	if (i) { return i; }
	return "pkg";
}
function link(pkg) {
		printf "<a href=\"?%s=%s%s\">", t, gensub(/\+/, "%2B", "g", pkg), v;
		if (t!="tags") printf "<img src=\"icons-s/%s.png\" alt=\"%s icon\"/>", icon(pkg), pkg;
		printf "%s</a>", pkg;
}
{
	split($1, line, ":");
	link(line[1]);
	if (line[2]) { printf ":"; link(line[2]); }
	printf "  ";
}'
		echo "</td></tr>"
	fi
}

# Source for categories names to translate

noop() {
	_ 'base-system'; _ 'x-window'; _ 'utilities'; _ 'network'; _ 'graphics';
	_ 'multimedia'; _ 'office'; _ 'development'; _ 'system-tools'; _ 'security';
	_ 'games'; _ 'misc'; _ 'meta'; _ 'non-free'
}

case " $(GET) " in
	*\ info\ *)
		package_exist $(GET info) || xhtml_footer
		. "$WOK/$(GET info)/receipt"

		cat <<EOT
<table class="info">
	<tr>
		<td class="first"><b>$(gettext 'Name')</b></td>
		<td>$PACKAGE
			<div class="appImg" style="background: url($(package_icon $PACKAGE 2))"></div>
		</td>
	</tr>
EOT
		[ -n "$VERSION" ] && cat <<EOT
	<tr>
		<td class="first"><b>$(gettext 'Version')</b></td>
		<td>$VERSION</td>
	</tr>
EOT
		cat <<EOT
	<tr>
		<td class="first"><b>$(gettext 'Category')</b></td>
		<td><a href="?category=$CATEGORY$addver">$(gettext "$CATEGORY")</a></td>
	</tr>

	<tr>
		<td class="first"><b>$(gettext 'Description')</b></td>
		<td>$(echo "$SHORT_DESC" | htmlize)</td>
	</tr>
EOT
		if [ -n "$MAINTAINER" ]; then
			# For form "John Doe <jdoe@example.org>"
			M="${MAINTAINER#*<}"; M="${M%>}" # extract address "jdoe@example.org"
			MAINTAINER=$(echo $MAINTAINER | htmlize) # escape "<" and ">" for use in HTML
			cat <<EOT
	<tr>
		<td class="first"><b>$(gettext 'Maintainer')</b></td>
		<td><a href="?maintainer=$M$addver">${MAINTAINER/@/&#8203;@&#8203;}</a></td>
	</tr>
EOT
		fi
		[ -n "$LICENSE" ] && cat <<EOT
	<tr>
		<td class="first"><b>$(gettext 'License')</b></td>
		<td>$(for license in $LICENSE; do
			echo "<a href=\"?license=$license$addver\">$license</a> "
		done)</td>
	</tr>
EOT
		web_site="${WEB_SITE#http://}"
		cat <<EOT
	<tr>
		<td class="first"><b>$(gettext 'Website')</b></td>
		<td><a href="$WEB_SITE" target="_blank">${web_site%/}</a></td>
	</tr>
EOT
		show_info_links "$TAGS" "$(_ 'Tags')" 'tags'

		if [ -n "$PACKED_SIZE" ]; then
			cat <<EOT
	<tr>
		<td class="first"><b>$(gettext 'Sizes')</b></td>
		<td>${PACKED_SIZE/.0/} / ${UNPACKED_SIZE/.0/}</td>
	</tr>
EOT
		elif [ -f "$pinfo" ]; then
			cat <<EOT
	<tr>
		<td class="first"><b>$(gettext 'Sizes')</b></td>
		<td>$(awk -F$'\t' -vp=$PACKAGE '$1==p{print $7}' "$pinfo" | sed 's| | / |')</td>
	</tr>
EOT
		fi

		show_info_links "$DEPENDS" "$(gettext 'Depends on')" 'info'

		show_info_links "$PROVIDE" "$(gettext 'Provides')" 'info'

		show_info_links "$SUGGESTED" "$(gettext 'Suggested')" 'info'
		cat <<EOT
</table>

EOT

		# Actions / screenshot
		pkg=${PACKAGE//+/%2B}
		pkg_url="$MIRROR_URL/packages/$SLITAZ_VERSION/$pkg-$VERSION$EXTRA_VERSION.tazpkg"
		case "$SLITAZ_VERSION" in
			cooking)
				COOKER="<a class=\"cooker\" href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\">$(gettext 'Show cooking log')</a>";;
			stable|undigest|backports)
				COOKER="<a class=\"cooker\" href=\"http://cook.slitaz.org/$SLITAZ_VERSION/cooker.cgi?pkg=$PACKAGE\">$(gettext 'Show cooking log')</a>";;
			*)
				COOKER="<span class=\"cooker\">$(gettext 'N/A')</span>";;
		esac
		cat <<EOT
<div class="sssb desc center">
	<a href="http://screenshots.debian.net/package/$pkg" target="_blank"><img
		src="http://screenshots.debian.net/thumbnail/$pkg" alt="$PACKAGE screenshot"/></a>
</div>

<table class="info">
	<tr><td><span class="download"></span>
			<a href="$pkg_url">$(gettext 'Download package')</a>
		</td>
		<td rowspan="5" class="last hssc">
			<a href="http://screenshots.debian.net/package/$pkg" target="_blank"><img
				src="http://screenshots.debian.net/thumbnail/$pkg" alt="$PACKAGE screenshot"/></a>
		</td>
	</tr>
	<tr><td><a class="receipt" href="?receipt=$pkg$addver">$(gettext 'Show receipt')</a></td></tr>
	<tr><td><a class="files-list" href="?filelist=$pkg$addver">$(gettext 'Show files list')</a></td></tr>
	<tr><td>$COOKER</td></tr>
	<tr id="tazpanelButtons" class="hidden">
		<td>
			<span id="tazpaneli" class="hidden">
				<a class="pkgi" href="http://127.0.0.1:82/user/pkgs.cgi?do=Install&amp;pkg=$pkg" target="_blank">$(gettext 'Install package')</a>
			</span>
			<span id="tazpanelr" class="hidden">
				<a class="pkgr" href="http://127.0.0.1:82/user/pkgs.cgi?do=Remove&amp;pkg=$pkg" target="_blank">$(gettext 'Remove package')</a>
			</span>
		</td>
	</tr>
</table>

<script>
function ajaxTazPanel(pkg) {
	var req = new XMLHttpRequest();
	req.onreadystatechange = function() {
		if (req.readyState == XMLHttpRequest.DONE) {
			if (req.status == 200) {
				if (req.responseText == 'i') {
					// Package installed, allow to remove
					document.getElementById('tazpanelr').className='';
				} else {
					// Package not installed, allow to install
					document.getElementById('tazpaneli').className='';
				}
				document.getElementById('tazpanelButtons').className='';
			}
		}
	}
	req.open('GET', 'http://tazpanel:82/pkgs.cgi?status&web=y&pkg=' + pkg, true);
	req.send();
}
ajaxTazPanel('$pkg');
</script>
EOT

		# Description
		if [ -f "$WOK/$PACKAGE/description.txt" ]; then
			cat <<EOT
<h3>$(gettext 'Description')</h3>
<table><tr><td>$(./sundown < "$WOK/$PACKAGE/description.txt")</td></tr></table>
EOT
		fi

		# Config files
		if [ -n "$CONFIG_FILES" ]; then
			cat <<EOT
<div class="conf">
	<h3>$(gettext 'Configuration files')</h3>
	<table><tr><td><ul>
EOT
			for file in $CONFIG_FILES; do
				cat <<EOT
		<li><a href="ftp://cook.slitaz.org/$PACKAGE/taz/$PACKAGE-$VERSION$EXTRAVERSION/fs$file" target="_blank">$file</a></li>
EOT
			done
			cat <<EOT
	</ul></td></tr></table>
</div>
EOT
		fi

	;;
esac




case "$OBJECT" in


### Depends loops; [Reverse] Dependency tree [(SUGGESTED)]
Depends)
	if [ -z "$SEARCH" ]; then
		cat <<EOT
<h3>$(_ 'Loop dependency')</h3>
<pre class="hard">
EOT
		for i in $WOK/*/receipt; do
			PACKAGE=
			DEPENDS=
			. $i
			echo "$PACKAGE $(echo $DEPENDS)"
		done | show_loops
		echo '</pre>'

	elif package_exist $SEARCH ; then
		cat <<EOT
<h3>$(_ 'Dependency tree for package "%s"' "$SEARCH")</h3>
<pre class="hard">
EOT
		unset ALL_DEPS
		dep_scan $SEARCH ''
		unset SUGGESTED
		. $WOK/$SEARCH/receipt
		echo '</pre>'

		if [ -n "$SUGGESTED" ]; then
			cat <<EOT
<h3>$(_ 'Dependency tree for packages suggested by package "%s"' "$SEARCH")</h3>
<pre class="hard">
EOT
			unset ALL_DEPS
			dep_scan "$SUGGESTED" '    '
			echo '</pre>'
		fi

		cat <<EOT
<h3>$(_ 'Reverse dependency tree for package "%s"' "$SEARCH")</h3>
<pre class="hard">
EOT
		unset ALL_DEPS
		rdep_scan $SEARCH
		echo '</pre>'
	fi
	;;




### Build depends loops; [Reverse] Build dependency tree

BuildDepends)
	if [ -z "$SEARCH" ]; then
		cat <<EOT
<h3>$(_ 'Loop dependency of build')</h3>
<pre class="hard">
EOT
		for i in $WOK/*/receipt; do
			PACKAGE=
			WANTED=
			BUILD_DEPENDS=
			. $i
			echo "$PACKAGE $WANTED $(echo $BUILD_DEPENDS)"
		done | show_loops
		echo '</pre>'

	elif package_exist $SEARCH ; then
		cat <<EOT
<h3>$(_ 'Package "%s" requires next packages to be built' "$SEARCH")</h3>
<pre class="hard">
EOT
		unset ALL_DEPS
		dep_scan $SEARCH '' build
		echo '</pre>'

		cat <<EOT
<h3>$(_ 'Next packages require package "%s" to be built' "$SEARCH")</h3>
<pre class="hard">
EOT
		unset ALL_DEPS
		rdep_scan $SEARCH build
		echo '</pre>'
	fi
	;;




### Common files

FileOverlap)
		if package_exist $SEARCH; then
		cat <<EOT

<h3>$(_ 'Next packages may overwrite files of package "%s"' "$SEARCH")</h3>
<pre class="hard">
EOT
		( unlzma < $filelist | grep ^$SEARCH: ;
		  unlzma < $filelist | grep -v ^$SEARCH: ) | awk '
BEGIN { pkg=""; last="x" }
{
	if ($2 == "") next
	if (index($2, last) == 1 && substr($2, 1+length(last), 1) == "/")
		delete file[last]
	last=$2
	if (pkg == "") pkg=$1
	if ($1 == pkg) file[$2]=$1
	else if (file[$2] == pkg) print
}
' | display_packages_and_files
			echo '</pre>'
	fi
	;;




### File search

File)
	if [ -n "$SEARCH" ]; then
		cat <<EOT

<h3>$(_ 'File names matching "%s"' "$SEARCH")</h3>
<table class="list">
EOT
		unset last
		unlzma < $filelist | grep -i "$SEARCH" | \
		while read pkg file; do
			echo "$file" | grep -qi "$SEARCH" || continue
			if [ "$last" != "${pkg%:}" ]; then
				[ -n "$last" ] && cat <<EOT
</td></tr>
EOT
				last=${pkg%:}
				(
				. $WOK/$last/receipt
				package_entry
				cat <<EOT
<tr><td colspan="3" class="pre">
EOT
				)
			fi
			echo -n "$file" | awk -vquery="$SEARCH" 'BEGIN{IGNORECASE=1}gsub(query, "<mark>&</mark>")'
			echo "<br/>"
		done
		cat <<EOT
</td></tr>
</table>
EOT
	fi
	;;




### List of files

File_list)
	if package_exist $SEARCH; then
		cat <<EOT

<h3>$(_ 'List of files in the package "%s"' "$SEARCH")</h3>
<pre class="hard">
EOT
		unset last
		unlzma < $filelist \
		| grep ^$SEARCH: | sed 's|.*: |    |' | sort
		cat <<EOT
</pre>
<pre class="hard">
EOT
		filenb=$(unlzma < $filelist | grep ^$SEARCH: | wc -l)
		_p '%s file' '%s files' "$filenb" "$filenb"
		cat <<EOT
  \
$(busybox sed -n "/^$SEARCH$/{nnnpq}" $pkglist)
</pre>
EOT
	fi
	;;




### Package description

Desc)
	if [ -z "$SEARCH" ]; then
		cat <<EOT
<div class="err">$(_ 'Please specify name of the package.')</div>
<p> <br/> </p>
EOT
		xhtml_footer
		exit 0
	fi

	cat <<EOT
<h3>$(_ 'Descriptions matching "%s"' "$SEARCH")</h3>
EOT
	if [ -f "$pinfo" ]; then
		package_entries desc "$SEARCH"
	else
		echo '<table class="list">'
		unset last
		# FIXME packages.desc should not be used (at least this way)
		grep -i "$SEARCH" "$pkgsrepo/packages.desc" | \
		sort | while read pkg extras ; do
			. "$WOK/$pkg/receipt"
			package_entry
		done
		echo '</table>'
	fi
	;;




Bugs)
	cat <<EOT

<h3>$(_ 'Known bugs in the packages')</h3>

<table class="bugs list">
EOT
	unset last
	grep ^BUGS= $WOK/*/receipt | \
	sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
		unset BUGS
		. "$WOK/$pkg/receipt"
		package_entry
		echo -n '<tr><td> </td><td colspan="2">'
		echo -n "$BUGS" | htmlize
		echo    '</td></tr>'
	done
	echo '</table>'
	;;




### Arch

Arch)
	if [ -n "$SEARCH" ]; then
		cat <<EOT

<h3>$(_ 'The list of packages of architecture "%s"' "$SEARCH")</h3>
<pre class="hard">
EOT
		unset last
		grep ^HOST_ARCH= $WOK/*/receipt |  grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			unset HOST_ARCH
			. "$WOK/$pkg/receipt"
			echo " $HOST_ARCH " | grep -iq " $SEARCH " &&
			package_entry_inline
		done
		cat <<EOT
</pre>
EOT
	else
		# Display arch cloud
		build_cloud HOST_ARCH arch
	fi
	;;




### Maintainer

Maintainer)
	if [ -n "$SEARCH" ]; then
		cat <<EOT

<h3>$(_n 'The list of packages that <%s> maintains' "$SEARCH" | htmlize)</h3>
<table class="list">
EOT
		unset last
		grep ^MAINTAINER= $WOK/*/receipt | grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			. "$WOK/$pkg/receipt"
			package_entry
		done
		cat <<EOT
</table>
EOT
	else
		# Display maintainer cloud
		build_cloud MAINTAINER maintainer
	fi
	;;




### License

License)
	if [ -n "$SEARCH" ]; then
		cat <<EOT
<h3>$(_ 'Packages with "%s" license' "$SEARCH")</h3>
<table class="list">
EOT
		unset last
		grep ^LICENSE= $WOK/*/receipt | grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			. "$WOK/$pkg/receipt"
			package_entry
		done
		echo '</table>'
	else
		# Display license cloud
		build_cloud LICENSE license
	fi
	;;




### Category

Category)
	if [ -n "$SEARCH" ]; then
		cat <<EOT
<h3>$(_ 'Packages of category "%s"' "$SEARCH")</h3>
EOT
		if [ -f "$pinfo" ]; then
			package_entries category "$SEARCH"
		else
			echo '<table class="list">'
			unset last
			grep ^CATEGORY= $WOK/*/receipt | grep -i "$SEARCH" | \
			sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
				. "$WOK/$pkg/receipt"
				package_entry
			done
			echo '</table>'
		fi
	else
		# Display category cloud
		if [ -f "$pinfo" ]; then
			tags="$(awk -F$'\t' '{if($3){print $3}}' "$pinfo" | tr ' ' $'\n' | sort | uniq -c)"
			max="$(echo "$tags" | awk '{if ($1 > MAX) MAX = $1} END{print MAX}')"
			echo "$tags" | awk -vMAX="$max" -vaddver="$addver" '{
				printf "<span class=\"tagn\">%s</span>", $1;
				printf "<a class=\"tag%s\" ", int($1 * 10 / MAX + 1);
				printf "href=\"?category=%s%s\">%s</a> ", $2, addver, $2;
			}'
		else
			build_cloud CATEGORY category
		fi
	fi
	;;




### Tags

Tags)
	if [ -n "$SEARCH" ]; then
		cat <<EOT
<h3>$(_ 'The list of packages tagged "%s"' "$SEARCH")</h3>
EOT
		if [ -f "$pinfo" ]; then
			package_entries tags "$SEARCH"
		else
			echo '<table class="list">'
			unset last
			grep ^TAGS= $WOK/*/receipt | grep -i "$SEARCH" | \
			sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
				. "$WOK/$pkg/receipt"
				package_entry
			done
			echo '</table>'
		fi
	else
		# Display tag cloud
		if [ -f "$pinfo" ]; then
			TAGS="$(awk -F$'\t' '{if($6){print $6}}' "$pinfo" | tr ' ' $'\n' | sort | uniq -c)"
			MAX="$(echo "$TAGS" | awk '{if ($1 > MAX) MAX = $1} END{print MAX}')"
			echo "$TAGS" | awk -vMAX="$MAX" -vv="$addver" '{
				printf "<span class=\"tagn\">%s</span>", $1;
				printf "<a class=\"tag%s\" ", int($1 * 10 / MAX + 1);
				printf "href=\"?tags=%s%s\">%s</a> ", $2, v, $2;
			}'
		else
			build_cloud TAGS tags
		fi
	fi
	;;




### Package receipt with syntax highlighter

Receipt)
	if package_exist "$SEARCH"; then
		cat <<EOT

<h3>$(_ 'Receipt for package "%s"' "$SEARCH")</h3>
<pre class="hard">
EOT
		if [ -f $WOK/$SEARCH/taz/*/receipt ]; then
			syntax_highlighter $WOK/$SEARCH/taz/*/receipt
		else
			syntax_highlighter $WOK/$SEARCH/receipt
		fi
		echo '</pre>'
	fi
	;;




### Package

Package)
	if check_n "$SEARCH"; then
		cat <<EOT
<h3>$(_ 'Package names matching "%s"' "$SEARCH")</h3>
EOT

		if [ -f "$pinfo" ]; then
			package_entries name "$SEARCH"
		else
			echo '<table class="list">'
			for pkg in $(ls $WOK/ | grep -i "$SEARCH"); do
				. "$WOK/$pkg/receipt"
				package_entry
			done
			echo '</table>'
		fi

		vpkgs="$(cut -d= -f1 < $equiv | grep -i "$SEARCH")"
		for vpkg in $vpkgs; do
			cat <<EOT

<h3>$(_ 'Packages providing the package "%s"' "$vpkg")</h3>

<table class="list">
EOT
			for pkg in $(grep $vpkg= $equiv | sed "s|$vpkg=||"); do
				echo "		<!-- '$pkg' - '${pkg#*:}' -->"
				if [ -e "$WOK/${pkg#*:}/receipt" ]; then
					. $WOK/${pkg#*:}/receipt
					package_entry
				fi
			done
			echo '</table>'
		done
	fi
	;;
esac

xhtml_footer

exit 0
