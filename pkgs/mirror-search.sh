#!/bin/sh

# Tiny CGI search engine for SliTaz packages on http://pkgs.slitaz.org/
# Christophe Lincoln <pankso@slitaz.org>
# Pascal Bellard <pascal.bellard@slitaz.org>
# Aleksej Bobylev <al.bobylev@gmail.com>
#

renice -n 19 $$

# Parse query string
. /usr/lib/slitaz/httphelper.sh

case "$HTTP_USER_AGENT" in
*/[Bb]ot*|*[Bb]ot/*|*spider/*) exec $PWD/Travaux.sh ;;
esac

# User preferred language
# parameter $1 have priority; without parameter $1 - browser language only
# if we don't support any of user languages (or only en), then return C locale
user_lang() {
	LANG="C"
	IFS=","
	for lang in $1 $HTTP_ACCEPT_LANGUAGE
	do
		lang=${lang%;*} lang=${lang# } lang=${lang%-*} lang=${lang%_*}
		case "$lang" in
			de) LANG="de_DE" ;;
			es) LANG="es_AR" ;;
			fr) LANG="fr_FR" ;;
			it) LANG="it_IT" ;;
			pl) LANG="pl_PL" ;;
			pt) LANG="pt_BR" ;;
			ru) LANG="ru_RU" ;;
			sv) LANG="sv_SE" ;;
			zh) LANG="zh_TW" ;;
		esac
		if echo "de en es fr pl pt ru sv zh" | fgrep -q "$lang"; then
			break
		fi
	done
	unset IFS
	echo "$LANG"
}

# Short 2-letter lang code from ll_CC
ll_lang() {
	ll_CC="$1"
	echo ${ll_CC%_*}
}

# Nice URL replacer - to copy url from address bar
# TODO: deal with POST method of form submitting
nice_url() {
	# if user submitted a form
	if [ ! -z $(GET submit) ]; then
		OBJECT="$(GET object)"
		SEARCH="$(GET query)"
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
		esac
		# version, if needed
		version="$(GET version)"
		if [ ! -z "$version" -a "$version" != "cooking" ]; then
			NICE="${NICE}&version=${version:0:1}"
		fi
		# lang, if needed
		query_lang="$(GET lang)"
		pref_lang="$(user_lang)"
		browser_lang="$(ll_lang $pref_lang)"
		if [ ! -z "$query_lang" -a "$query_lang" != "$browser_lang" ]; then
			NICE="${NICE}&lang=$query_lang"
		fi
		# verbose, if needed
		verboseq="$(GET verbose)"
		if [ ! -z "$verboseq" -a "$verboseq" != "0" ]; then
			NICE="${NICE}&verbose=1"
		fi
		# redirect
		# TODO: implement HTTP 301 Redirect
		cat << EOT
Content-type: text/html

<!DOCTYPE html>
<html><head><meta http-equiv="refresh" content="0;url=$SCRIPT_NAME?$NICE" />
<title>Redirect</title></head></html>
EOT
#		echo "Location: $SCRIPT_NAME?$NICE"
#		echo
		exit 0
	fi
}

nice_url



OBJECT="$(GET object)"
SEARCH="$(GET query)"
SLITAZ_VERSION="$(GET version)"
VERBOSE="$(GET verbose)"

# Internal variables
#DATE=$(date +%Y-%m-%d\ %H:%M:%S)

# Internationalization
. /usr/bin/gettext.sh
export TEXTDOMAIN='tazpkg-web'

SEARCH=""
VERBOSE=0
for i in $(echo $QUERY_STRING | sed 's/[?&]/ /g'); do
#	SLITAZ_VERSION=cooking
	case "$(echo $i | tr [A-Z] [a-z])" in
		query=*|search=*)		[ ${i#*=} == Search ] || SEARCH=${i#*=};;
		object=*)				OBJECT=${i#*=};;
		verbose=*)				VERBOSE=${i#*=};;
		lang=*)					LANG=${i#*=};;
		file=*)					SEARCH=${i#*=}; OBJECT=File;;
		desc=*)					SEARCH=${i#*=}; OBJECT=Desc;;
		tags=*)					SEARCH=${i#*=}; OBJECT=Tags;;
		arch=*)					SEARCH=${i#*=}; OBJECT=Arch;;
		bugs=*)					SEARCH=${i#*=}; OBJECT=Bugs;;
		receipt=*)				SEARCH=${i#*=}; OBJECT=Receipt;;
		filelist=*)				SEARCH=${i#*=}; OBJECT=File_list;;
		package=*)				SEARCH=${i#*=}; OBJECT=Package;;
		depends=*)				SEARCH=${i#*=}; OBJECT=Depends;;
		builddepends=*)				SEARCH=${i#*=}; OBJECT=BuildDepends;;
		fileoverlap=*)				SEARCH=${i#*=}; OBJECT=FileOverlap;;
		category=*)				SEARCH=${i#*=}; OBJECT=Category;;
		maintainer=*)				SEARCH=${i#*=}; OBJECT=Maintainer;;
		license=*)				SEARCH=${i#*=}; OBJECT=License;;
		version=[1-9]*)			i=${i%%.*}; SLITAZ_VERSION=${i#*=}.0;;
		version=s*|version=4*)	SLITAZ_VERSION=stable;;
		version=u*)				SLITAZ_VERSION=undigest;;
		version=t*)				SLITAZ_VERSION=tiny;;
	esac
done
[ -z "$SLITAZ_VERSION" ] && SLITAZ_VERSION=cooking
#[ -n "$SEARCH" ] && REQUEST_METHOD="POST"
#[ "$SEARCH" == "." ] && SEARCH=


# Content negotiation for Gettext
LANG=$(user_lang $(GET lang))
lang="$(ll_lang $LANG)"
export LANG LC_ALL=$LANG


case "$OBJECT" in
	File)			selected_file="selected";;
	Desc)			selected_desc="selected";;
	Tags)			selected_tags="selected";;
	Arch)			selected_arch="selected";;
	Bugs)			selected_bugs="selected";;
	Receipt)		selected_receipt="selected";;
	File_list)		selected_file_list="selected";;
	Depends)		selected_depends="selected";;
	BuildDepends)	selected_build_depends="selected";;
	FileOverlap)	selected_overlap="selected";;
esac

case "$SLITAZ_VERSION" in
	tiny)		selected_tiny="selected";;
	1.0)		selected_1="selected";;
	2.0)		selected_2="selected";;
	3.0)		selected_3="selected";;
	stable)		selected_stable="selected";;
	undigest)	selected_undigest="selected";;
esac

# unescape query
SEARCH="$(echo $SEARCH | sed 's/%2B/+/g; s/%3A/:/g; s|%2F|/|g')"

WOK=/home/slitaz/$SLITAZ_VERSION/wok
PACKAGES_REPOSITORY=/home/slitaz/$SLITAZ_VERSION/packages


# TODO: header function from httphelper
echo "Content-type: text/html"
echo

# Search form
# TODO: implement POST method
# ... method="post" enctype="multipart/form-data" ...
# TODO: add hint 'You are can search for depends loop, if textfield is empty'...
# add progress ticker while page is not complete
search_form()
{
	cat << _EOT_

<form id="s_form" method="get" action="$SCRIPT_NAME">
	<input type="hidden" name="lang" value="$lang" />
	<select name="object">
		<option value="Package">$(gettext "Package")</option>
		<option $selected_desc value="Desc">$(gettext "Description")</option>
		<option $selected_tags value="Tags">$(gettext "Tags")</option>
		<!-- option $selected_arch value="Tags">$(gettext "Arch")</option -->
		<!-- option $selected_bugs value="Bugs">$(gettext "Bugs")</option -->
		<option $selected_receipt value="Receipt">$(gettext "Receipt")</option>
		<option $selected_depends value="Depends">$(gettext "Depends")</option>
		<option $selected_build_depends value="BuildDepends">$(gettext "Build depends")</option>
		<option $selected_file value="File">$(gettext "File")</option>
		<option $selected_file_list value="File_list">$(gettext "File list")</option>
		<option $selected_overlap value="FileOverlap">$(gettext "common files")</option>
	</select>
	<input type="text" name="query" id="query" size="20" value="$SEARCH" />
	<select name="version">
		<option value="cooking">$(gettext "cooking")</option>
		<option $selected_stable value="stable">4.0</option>
		<option $selected_3 value="3.0">3.0</option>
		<option $selected_2 value="2.0">2.0</option>
		<option $selected_1 value="1.0">1.0</option>
		<option $selected_tiny value="tiny">$(gettext "tiny")</option>
		<option $selected_undigest value="undigest">$(gettext "undigest")</option>
	</select>
	<input type="submit" name="submit" value="$(gettext 'Search')" />
</form>
_EOT_
}

# xHTML5 Header.
xhtml_header() {
	. lib/header.sh
}

cat_files_list()
{
	local tmp=/tmp/files.list.$(basename ${1%/packages})
	if [ ! -s $tmp -o $1/files.list.lzma -nt $tmp ]; then
		unlzma -c $1/files.list.lzma > $tmp.$$ && mv $tmp.$$ $tmp
	fi
	case "$2" in
	lines)	if [ ! -s $tmp.lines -o $tmp -nt $tmp.lines ]; then
			cat $tmp | wc -l > $tmp.lines.$$ &&
			mv $tmp.lines.$$ $tmp.lines
		fi
		cat $tmp.lines ;;	
	*)	cat $tmp ;;
	esac
}

# xHTML Footer.
# TODO: caching the summary for 5 minutes
xhtml_footer() {
	file=/tmp/footer-$SLITAZ_VERSION
	[ ! -e $file -o  $PACKAGES_REPOSITORY/packages.txt -nt $file ] &&
		cat > $file.$$ <<EOT && mv -f $file.$$ $file
PKGS=$(ls $WOK/ | wc -l)
FILES=$(cat_files_list $PACKAGES_REPOSITORY lines)
EOT
	PKGS=$(sed '/PKGS=/!d;s/PKGS=//' $file)
	FILES=$(sed '/FILES=/!d;s/FILES=//' $file)
	. lib/footer.sh
}

installed_size()
{
	if [ $VERBOSE -gt 0 ]; then
		inst=$(grep -A 3 "^$1\$" $PACKAGES_REPOSITORY/packages.txt | grep installed)
#		size=$(echo $inst | cut -d'(' -f2 | cut -d' ' -f1)
		echo $inst | sed 's/.*(\(.*\).*/(\1)/'
#		echo $size
#		 | sed 's/.*(\(.*\) installed.*/(\1) /'
	fi
}

package_entry()
{
if [ -s "$(dirname $0)/$SLITAZ_VERSION/$CATEGORY.html" ]; then
	cat << _EOT_
<a href="$SLITAZ_VERSION/$CATEGORY.html#$PACKAGE">$PACKAGE</a> $(installed_size $PACKAGE): $SHORT_DESC
_EOT_
else
	PACKAGE_HREF="<u>$PACKAGE</u>"
	PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION$EXTRA_VERSION.tazpkg"
	nslookup mirror.slitaz.org | grep -q 127.0.0.1 &&
	[ -d /var/www/slitaz/mirror/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION ] &&
	PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION" ||
	PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$(cd /var/www/slitaz/mirror/packages/$SLITAZ_VERSION ; ls $PACKAGE-$VERSION*.tazpkg)"
	busybox wget -s $PACKAGE_URL 2> /dev/null &&
	PACKAGE_HREF="<a href=\"$PACKAGE_URL\">$PACKAGE</a>"
	COOKER=""
	[ "$SLITAZ_VERSION" == "cooking" ] && 
	COOKER="<a href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\">$(gettext "Cooker")</a>"
	cat << _EOT_
$PACKAGE_HREF $(installed_size $PACKAGE): $SHORT_DESC \
<a href="?receipt=$PACKAGE&amp;version=$SLITAZ_VERSION">$(gettext "Receipt")</a> $COOKER
_EOT_
fi
	[ -n "$(GET debug)" ] && cat << _EOT_
<pre>
PACKAGE=$PACKAGE
VERSION=$VERSION
EXTRAVERSION=$EXTRAVERSION
SLITAZ_VERSION=$SLITAZ_VERSION
PACKAGE_URL=$PACKAGE_URL
$(cd /var/www/slitaz/mirror/packages/$SLITAZ_VERSION ; ls -l $PACKAGE*)
</pre>
_EOT_
}

# Show loop in depends/build_depends chains
show_loops()
{
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
dep_scan()
{
for i in $1; do
	case " $ALL_DEPS " in
	*\ $i\ *) continue;;
	esac
	ALL_DEPS="$ALL_DEPS $i"
	if [ -n "$2" ]; then
		echo -n "$2"
		(
		. $WOK/$i/receipt
		package_entry
		)
	fi
	[ -f $WOK/$i/receipt ] || continue
	DEPENDS=""
	BUILD_DEPENDS=""
	WANTED=""
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
rdep_scan()
{
SEARCH=$1
case "$SEARCH" in
glibc-base|gcc-lib-base)
	$(gettext "	glibc-base and gcc-lib-base are implicit dependencies,
	<b>every</b> package is supposed to depend on them."); echo
	return;;
esac
for i in $WOK/* ; do
	DEPENDS=""
	BUILD_DEPENDS=""
	WANTED=""
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
$(echo ${pkg%/*} | sed 's|/| |g') $(package_entry)
_EOT_
done
}

# Check package exists
package_exist()
{
	[ -f $WOK/$1/receipt ] && return 0
	cat << _EOT_

<h3>$(eval_gettext "No package \$SEARCH")</h3>
_EOT_
	return 1
}

# Display < > &
htmlize()
{
	sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Create some clickable links
urllink()
{
	local tarball_url
	sedit=""
	[ -n "$WEB_SITE" ] && sedit="$sedit -e 's|^WEB_SITE=\"\\(.*\\)\"|WEB_SITE=\"<a href=\"$WEB_SITE\">\\1</a>\"|'"
	[ -n "$WGET_URL" ] && sedit="$sedit -e 's#^WGET_URL=\"\\(.*\\)\"#WGET_URL=\"<a href=\"${WGET_URL##*|}\">\\1</a>\"#'"
	[ -n "$CATEGORY" ] && sedit="$sedit -e 's|^CATEGORY=\"\\(.*\\)\"|CATEGORY=\"<a href=\"?category=$CATEGORY\\&amp;version=$SLITAZ_VERSION\">\\1</a>\"|'"
	[ -n "$WANTED" ] && sedit="$sedit -e 's|^WANTED=\"\\(.*\\)\"|WANTED=\"<a href=\"?receipt=$WANTED\\&amp;version=$SLITAZ_VERSION\">\\1</a>\"|'"
	[ -n "$BUGS" ] && sedit="$sedit -e 's|^BUGS=\"\\(.*\\)\"|BUGS=\"<a href=\"?bugs=$PACKAGE\\&amp;version=$SLITAZ_VERSION\">\\1</a>\"|'"
	[ -f $WOK/$PACKAGE/description.txt ] && sedit="$sedit -e 's|^SHORT_DESC=\"\\(.*\\)\"|SHORT_DESC=\"<a href=\"?desc=$PACKAGE\\&amp;version=$SLITAZ_VERSION\">\\1</a>\"|'"
	tarball_url=sources/packages-$SLITAZ_VERSION/${TARBALL:0:1}/$TARBALL
	[ -f /var/www/slitaz/mirror/$tarball_url ] || case "$tarball_url" in
		*.gz)	tarball_url=${tarball_url%gz}lzma ;;
		*.tgz)	tarball_url=${tarball_url%tgz}tar.lzma ;;
		*.bz2)	tarball_url=${tarball_url%bz2}lzma ;;
	esac
	[ -f /var/www/slitaz/mirror/$tarball_url ] && sedit="$sedit -e 's|^TARBALL=\"\\(.*\\)\"|TARBALL=\"<a href=\"http://mirror.slitaz.org/$tarball_url\">\\1</a>\"|'"
	if [ -n "$HOST_ARCH" ]; then
		tmp=""
		for i in $HOST_ARCH ; do
			tmp="$tmp <a href=\\\"?arch=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>"
		done
		sedit="$sedit -e 's|^HOST_ARCH=\".*\"|HOST_ARCH=\"${tmp# }\"|'"
	fi
	if [ -n "$TAGS" ]; then
		tmp=""
		for i in $TAGS ; do
			tmp="$tmp <a href=\\\"?tags=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>"
		done
		sedit="$sedit -e 's|^TAGS=\".*\"|TAGS=\"${tmp# }\"|'"
	fi
	if [ -n "$DEPENDS$BUILD_DEPENDS$SUGGESTED" ]; then
		for i in $(echo $DEPENDS $BUILD_DEPENDS $SUGGESTED) ; do
			sedit="$sedit -e 's|\\([\" ]\\)$i\\([\" \\]\\)|\\1<a href=\\\"?package=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>\\2|'"
			sedit="$sedit -e 's|\\([\" ]\\)$i\$|\\1<a href=\\\"?package=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>|'"
			sedit="$sedit -e 's|^$i\\([\" \\]\\)|<a href=\\\"?package=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>\\1|'"
			sedit="$sedit -e 's|^$i\$|<a href=\\\"?package=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>|'"
		done
	fi
	if [ -n "$CONFIG_FILES" ]; then
		tmp=""
		for i in $(echo $CONFIG_FILES) ; do
			tmp="$tmp <a href=\\\"?file=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>"
		done
		sedit="$sedit -e 's|^CONFIG_FILES=\".*\"|CONFIG_FILES=\"${tmp# }\"|'"
	fi
	if [ -n "$PROVIDE" ]; then
		tmp=""
		for i in $(echo $PROVIDE) ; do
			tmp="$tmp <a href=\\\"?package=${i%:*}\\&amp;version=$SLITAZ_VERSION\\\">$i</a>"
		done
		sedit="$sedit -e 's|^PROVIDE=\".*\"|PROVIDE=\"${tmp# }\"|'"
	fi
	eval sed $sedit \
		-e "'s|^MAINTAINER=\".*\"|MAINTAINER=\"<a href=\"?maintainer=$MAINTAINER\">$MAINTAINER</a>\"|'" \
		-e "'s|^genpkg_rules|<a href=\"?filelist=$PACKAGE\\&amp;version=$SLITAZ_VERSION\">&</a>|'"
}

display_packages_and_files()
{
last=""
while read pkg file; do
	pkg=${pkg%:}
	if [ "$pkg" != "$last" ]; then
		. $WOK/$pkg/receipt
		package_entry
		last=$pkg
	fi
	echo "    $file"
done
}

build_cloud_cache()
{
	grep -l ^$1= $WOK/*/receipt | while read file; do
		eval $1=
		. $file
		eval echo \$$1
	done | sed "$2" | awk '
{
	for (i = 1; $i != ""; i++) {
		count[$i]++
	}
}
END {
	min=10000
	max=0
	for (i in count) {
		if (count[i] < min) min = count[i]
		if (count[i] > max) max = count[i]
	}
	for (i in count)
		print count[i] " " int((count[i] - min)*100/(max - min)) " " i
}' | sort -k 3
}

display_cloud()
{
	echo "<p>"
	while read cnt pct item ; do
		pct=$(((10000 - ((100 - $pct)**2))/100))
		pct=$(((10000 - ((100 - $pct)**2))/100))
		cat <<EOT
<span style="color:#99f; font-size:9pt; padding-left:5px; padding-right:2px;">\
$cnt</span><a href="?$1=$item&amp;version=$SLITAZ_VERSION" style="\
font-size:$((8+($pct/10)))pt; font-weight:bold; \
color:black; text-decoration:none">$(echo $item | sed 's/-/\&minus;/g')</a>
EOT
	done | tee /dev/stderr | printf "</p><p align=right>$2" $(wc -l)
	echo "</p>"
}

xhtml_header

#
# Handle GET requests
#
case " $(GET) " in
	*\ debug\ *|*\ debug*)
		cat << EOT
<h2>Debug info</h2>
<pre>$(httpinfo)</pre>
<pre>LANG=$LANG;
OBJECT=$OBJECT;
SEARCH=$SEARCH;
SLITAZ_VERSION=$SLITAZ_VERSION;
WOK=$WOK;
</pre>
EOT
#$(xhtml_footer)
#EOT
#		exit 0
	;;
esac

# Display search form and result if requested.
#xhtml_header
echo "<h2>$(gettext 'Search for packages')</h2>"
search_form

case "$OBJECT" in


### Depends loops; [Reverse] Dependency tree [(SUGGESTED)]
Depends)
	if [ -z "$SEARCH" ]; then
		cat << _EOT_

<h3>$(gettext "Depends loops")</h3>
<pre>
_EOT_
		for i in $WOK/*/receipt; do
			PACKAGE=
			DEPENDS=
			. $i
			echo "$PACKAGE $(echo $DEPENDS)"
		done | show_loops
		cat << _EOT_
</pre>
_EOT_
	elif package_exist $SEARCH ; then
		cat << _EOT_

<h3>$(eval_gettext "Dependency tree for: \$SEARCH")</h3>
<pre>
_EOT_
		ALL_DEPS=""
		dep_scan $SEARCH ""
		SUGGESTED=""
		. $WOK/$SEARCH/receipt
		if [ -n "$SUGGESTED" ]; then
			cat << _EOT_
</pre>

<h3>$(eval_gettext "Dependency tree for: \$SEARCH (SUGGESTED)")</h3>
<pre>
_EOT_
			ALL_DEPS=""
			dep_scan "$SUGGESTED" "    "
		fi
		cat << _EOT_
</pre>

<h3>$(eval_gettext "Reverse dependency tree for: \$SEARCH")</h3>
<pre>
_EOT_
		ALL_DEPS=""
		rdep_scan $SEARCH
		cat << _EOT_
</pre>
_EOT_
	fi
	;;


### Build depends loops; [Reverse] Build dependency tree
BuildDepends)
	if [ -z "$SEARCH" ]; then
		cat << _EOT_

<h3>$(gettext "Build depends loops")</h3>
<pre>
_EOT_
		for i in $WOK/*/receipt; do
			PACKAGE=
			WANTED=
			BUILD_DEPENDS=
			. $i
			echo "$PACKAGE $WANTED $(echo $BUILD_DEPENDS)"
		done | show_loops
		cat << _EOT_
</pre>
_EOT_
	elif package_exist $SEARCH ; then
		cat << _EOT_

<h3>$(eval_gettext "\$SEARCH needs these packages to be built")</h3>
<pre>
_EOT_
		ALL_DEPS=""
		dep_scan $SEARCH "" build
		cat << _EOT_
</pre>

<h3>$(eval_gettext "Packages who need \$SEARCH to be built")</h3>
<pre>
_EOT_
		ALL_DEPS=""
		rdep_scan $SEARCH build
		cat << _EOT_
</pre>
_EOT_
	fi
	;;


### Common files
FileOverlap)
		if package_exist $SEARCH; then
		cat << _EOT_

<h3>$(eval_gettext "These packages may overload files of \$SEARCH")</h3>
<pre>
_EOT_
		( cat_files_list $PACKAGES_REPOSITORY | grep ^$SEARCH: ;
		  cat_files_list $PACKAGES_REPOSITORY | grep -v ^$SEARCH: ) | awk '
BEGIN { pkg=""; last="x" }
{
	if ($2 == "") next
	if (index($2,last) == 1 && substr($2,1+length(last),1) == "/")
		delete file[last]
	last=$2
	if (pkg == "") pkg=$1
	if ($1 == pkg) file[$2]=$1
	else if (file[$2] == pkg) print
}
' | display_packages_and_files
			cat << _EOT_
</pre>
_EOT_
	fi
	;;


### File search
File)
	if [ -n "$SEARCH" ]; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
		last=""
		cat_files_list $PACKAGES_REPOSITORY \
		| grep "$SEARCH" | while read pkg file; do
			echo "$file" | grep -q "$SEARCH" || continue
			if [ "$last" != "${pkg%:}" ]; then
				last=${pkg%:}
				(
				. $WOK/$last/receipt
				cat << _EOT_

<i>$(package_entry)</i>
_EOT_
				)
			fi
			echo "    $file"
		done
		cat << _EOT_
</pre>
_EOT_
	fi
	;;


### List of files
File_list)
	if package_exist $SEARCH; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
		last=""
		cat_files_list $PACKAGES_REPOSITORY \
		| grep ^$SEARCH: |  sed 's/.*: /    /' | sort
		cat << _EOT_
</pre>
<pre>
_EOT_
		filenb=$(cat_files_list $PACKAGES_REPOSITORY | grep ^$SEARCH: | wc -l)
		eval_ngettext "\$filenb file" "\$filenb files" $filenb
		cat << _EOT_
  \
$(busybox sed -n "/^$SEARCH$/{nnnpq}" $PACKAGES_REPOSITORY/packages.txt)
</pre>
_EOT_
	fi
	;;


### Package description
Desc)
	cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
	if [ -f $WOK/$SEARCH/description.txt ]; then
		htmlize < $WOK/$SEARCH/description.txt
	else
		last=""
		grep -i "$SEARCH" $PACKAGES_REPOSITORY/packages.desc | \
		sort | while read pkg extras ; do
			. $WOK/$pkg/receipt
			package_entry
		done
	fi
	cat << _EOT_
</pre>
_EOT_
	;;


### Bugs
Bugs)
	cat << _EOT_

<h3>$(eval_gettext "Result for known bugs")</h3>
<pre>
_EOT_
	last=""
	grep ^BUGS= $WOK/*/receipt | \
	sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
		BUGS=
		. $WOK/$pkg/receipt
		package_entry
		echo "    $BUGS "
	done
	cat << _EOT_
</pre>
_EOT_
	;;


### Arch
Arch)
	cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
	last=""
	grep ^HOST_ARCH= $WOK/*/receipt |  grep -i "$SEARCH" | \
	sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
		HOST_ARCH=
		. $WOK/$pkg/receipt
		echo " $HOST_ARCH " | grep -iq " $SEARCH " &&
		package_entry
	done
	cat << _EOT_
</pre>
_EOT_
	;;


### Tags
Tags)
	if [ -n "$SEARCH" ]; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
		last=""
		grep ^TAGS= $WOK/*/receipt |  grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			TAGS=
			. $WOK/$pkg/receipt
			echo " $TAGS " | grep -iq " $SEARCH " &&
			package_entry
		done
		cat << _EOT_
</pre>
_EOT_
	else
		# Display clouds
		while read var arg title fmt filter; do
			file=/tmp/$arg-$SLITAZ_VERSION
			echo "<a name=\"$arg\"></a>"
			echo "<h3>$title</h3>"
			[ ! -e $file -o  \
			  $PACKAGES_REPOSITORY/packages.txt -nt $file ] &&
				build_cloud_cache $var "$filter" > $file.$$ &&
				mv -f $file.$$ $file
			display_cloud $arg "$fmt" < $file 2>&1
		done << EOT
TAGS		tags		Tag\ cloud		%d\ tags.
CATEGORY	category	Category\ cloud		%d\ categories.
LICENSE		license		License\ cloud		%d\ licenses.
MAINTAINER	maintainer	Maintainer\ cloud	%d\ maintainers.	s/.*<//;s/.*\ //;s/>//
EOT
	fi
	;;


### Package receipt
# TODO: add style highlighting
Receipt)
	package_exist $SEARCH && cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
$(receipt=$WOK/$SEARCH/taz/*/receipt
  [ -f  $receipt ] || receipt=$WOK/$SEARCH/receipt
  . /home/slitaz/repos/cookutils/cook.conf
  . $receipt
  cat $receipt | htmlize | urllink)
</pre>
_EOT_
	;;


### Package
Package)
#WHY#	if package_exist $SEARCH; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
		for pkg in `ls $WOK/ | grep "$SEARCH"`
		do
			. $WOK/$pkg/receipt
			DESC=" <a href=\"?object=Desc&query=$pkg&lang=$lang&version=$SLITAZ_VERSION&submit=go\">$(gettext description)</a>"
			[ -f $WOK/$pkg/description.txt ] || DESC=""
			cat << _EOT_
$(package_entry)$DESC
_EOT_
		done
		equiv=$PACKAGES_REPOSITORY/packages.equiv
		vpkgs="$(cat $equiv | cut -d= -f1 | grep $SEARCH)"
		for vpkg in $vpkgs ; do
			cat << _EOT_
</pre>

<h3>$(eval_gettext "Result for: \$SEARCH (package providing \$vpkg)")</h3>
<pre>
_EOT_
			for pkg in $(grep $vpkg= $equiv | sed "s/$vpkg=//"); do
				. $WOK/${pkg#*:}/receipt
				package_entry
			done
		done
		cat << _EOT_
</pre>
_EOT_
#WHY#	fi
	;;

### Category
Category)
	cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
	for pkg in `ls $WOK/`
	do
		CATEGORY=
		. $WOK/$pkg/receipt
		DESC=" <a href=\"?object=Desc&query=$pkg&lang=$lang&version=$SLITAZ_VERSION&submit=go\">$(gettext description)</a>"
		[ -f $WOK/$pkg/description.txt ] || DESC=""
		[ "$CATEGORY" == "$SEARCH" ] && cat << _EOT_
$(package_entry)$DESC
_EOT_
	done
	;;

### Maintainer
Maintainer)
	cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
	for pkg in `ls $WOK/`
	do
		MAINTAINER=
		. $WOK/$pkg/receipt
		DESC=" <a href=\"?object=Desc&query=$pkg&lang=$lang&version=$SLITAZ_VERSION&submit=go\">$(gettext description)</a>"
		[ -f $WOK/$pkg/description.txt ] || DESC=""
		[ "$MAINTAINER" == "$SEARCH" ] && cat << _EOT_
$(package_entry)$DESC
_EOT_
	done
	;;

### License
License)
	cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
	for pkg in `ls $WOK/`
	do
		LICENSE=
		. $WOK/$pkg/receipt
		DESC=" <a href=\"?object=Desc&query=$pkg&lang=$lang&version=$SLITAZ_VERSION&submit=go\">$(gettext description)</a>"
		[ -f $WOK/$pkg/description.txt ] || DESC=""
		case " $LICENSE " in
		*\ $SEARCH\ *) cat << _EOT_
$(package_entry)$DESC
_EOT_
		esac
	done
	;;
esac

xhtml_footer

exit 0
