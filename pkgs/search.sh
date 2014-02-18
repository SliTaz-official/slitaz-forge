#!/bin/sh
#
# Tiny CGI search engine for SliTaz packages on http://pkgs.slitaz.org/
# Christophe Lincoln <pankso@slitaz.org>
# Aleksej Bobylev <al.bobylev@gmail.com>
#

renice -n 19 $$

# Parse query string
. /etc/slitaz/slitaz.conf
. /usr/lib/slitaz/httphelper.sh
echo -n "0" > $HOME/ifEven
[ -n "$MIRROR_URL" ] || MIRROR_URL="http://mirror.slitaz.org"

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

# Part of query to indicate current debug mode
ifdebug() {
	ifdebug="$(GET debug)"
	[ ! -z "$ifdebug" ] && ifdebug="$1$ifdebug"
	echo "$ifdebug"
}

# GET or POST variable
GETPOST() {
	echo "$(POST $1)$(GET $1)"
}

# Nice URL replacer - to copy url from address bar
# TODO: deal with POST method of form submitting
nice_url() {
	# if user submitted a form
	if [ "$REQUEST_METHOD" == "POST" -o ! -z $(GET submit) ]; then
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
			Category)	NICE="category=$SEARCH";;
			Maintainer)	NICE="maintainer=$SEARCH";;
			License)	NICE="license=$SEARCH";;
		esac
		# version, if needed
		version="$(GETPOST version)"
		if [ ! -z "$version" -a "$version" != "cooking" ]; then
			NICE="${NICE}&version=${version:0:1}"
		fi
		# lang, if needed
		query_lang="$(GETPOST lang)"
		pref_lang="$(user_lang)"
		browser_lang="$(ll_lang $pref_lang)"
		if [ ! -z "$query_lang" -a "$query_lang" != "$browser_lang" ]; then
			NICE="${NICE}&lang=$query_lang"
		fi
		# verbose, if needed
		verboseq="$(GETPOST verbose)"
		if [ ! -z "$verboseq" -a "$verboseq" != "0" ]; then
			NICE="${NICE}&verbose=1"
		fi
		# debug, if needed
		debugq="$(GET debug)"
		if [ ! -z "$debugq" -a "$debugq" == "debug" ]; then
			NICE="${NICE}&debug"
		fi
		# redirect
		header "HTTP/1.1 301 Moved Permanently" "Location: $SCRIPT_NAME?$NICE"
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

unset SEARCH
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
		builddepends=*)			SEARCH=${i#*=}; OBJECT=BuildDepends;;
		fileoverlap=*)			SEARCH=${i#*=}; OBJECT=FileOverlap;;
		category=*)				SEARCH=${i#*=}; OBJECT=Category;;
		maintainer=*)			SEARCH=${i#*=}; OBJECT=Maintainer;;
		license=*)			SEARCH=${i#*=}; OBJECT=License;;
		version=[1-9]*)			i=${i%%.*}; SLITAZ_VERSION=${i#*=}.0;;
		version=s*|version=4*)	SLITAZ_VERSION=stable;;
		version=u*)				SLITAZ_VERSION=undigest;;
		version=b*)				SLITAZ_VERSION=backports;;
		version=t*)				SLITAZ_VERSION=tiny;;
	esac
done
[ -z "$SLITAZ_VERSION" ] && SLITAZ_VERSION=cooking

#
# Content negotiation for Gettext
#
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
	Category)	selected_category="selected";;
	Maintainer)	selected_maintainer="selected";;
	License)	selected_license="selected";;
esac

case "$SLITAZ_VERSION" in
	tiny)		selected_tiny="selected";;
	1.0)		selected_1="selected";;
	2.0)		selected_2="selected";;
	3.0)		selected_3="selected";;
	stable)		selected_stable="selected";;
	undigest)	selected_undigest="selected";;
	backports)	selected_backports="selected";;
esac

#
# Unescape query and set vars
#
SEARCH="$(echo $SEARCH | sed 's/%2B/+/g; s/%3A/:/g; s|%2F|/|g')"
SLITAZ_HOME="/home/slitaz"
if [ "$SLITAZ_VERSION" == "cooking" ]; then
	WOK=$SLITAZ_HOME/wok
else
	WOK=$SLITAZ_HOME/wok-${SLITAZ_VERSION}
fi
pkgsrepo=$SLITAZ_HOME/$SLITAZ_VERSION/packages
filelist=$pkgsrepo/files.list.lzma
pkglist=$pkgsrepo/packages.txt
equiv=$pkgsrepo/packages.equiv

# Search form
# TODO: add hint 'You are can search for depends loop, if textfield is empty'...
# add progress ticker while page is not complete
search_form()
{
	cat << _EOT_

<div class="form">
<form id="s_form" method="post" action="$SCRIPT_NAME$(ifdebug '?')">
	<input type="hidden" name="lang" value="$lang" />
	<span class="small">
		<select name="object">
			<option value="Package">$(gettext "Package")</option>
			<option $selected_desc value="Desc">$(gettext "Description")</option>
			<option $selected_tags value="Tags">$(gettext "Tags")</option>
			<option $selected_arch value="Arch">$(gettext "Arch")</option>
			<option $selected_bugs value="Bugs">$(gettext "Bugs")</option>
			<option $selected_receipt value="Receipt">$(gettext "Receipt")</option>
			<option $selected_depends value="Depends">$(gettext "Depends")</option>
			<option $selected_build_depends value="BuildDepends">$(gettext "Build depends")</option>
			<option $selected_file value="File">$(gettext "File")</option>
			<option $selected_file_list value="File_list">$(gettext "File list")</option>
			<option $selected_overlap value="FileOverlap">$(gettext "common files")</option>
			<option $selected_category value="Category">$(gettext "Category")</option>
			<option $selected_maintainer value="Maintainer">$(gettext "Maintainer")</option>
			<option $selected_license value="License">$(gettext "License")</option>
		</select>
	</span>
	<span class="stretch">
		<input autofocus type="text" name="query" id="query" value="$SEARCH" />
	</span>
	<span class="small">
		<select name="version">
			<option value="cooking">$(gettext "cooking")</option>
			<option $selected_stable value="stable">4.0</option>
			<option $selected_3 value="3.0">3.0</option>
			<option $selected_2 value="2.0">2.0</option>
			<option $selected_1 value="1.0">1.0</option>
			<option $selected_tiny value="tiny">$(gettext "tiny")</option>
			<option $selected_undigest value="undigest">$(gettext "undigest")</option>
			<option $selected_backports value="backports">$(gettext "backports")</option>
		</select>
	</span>
	<span class="small">
		<input type="submit" value="$(gettext 'Search')" />
	</span>
</form>
</div>
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
		unlzma < $1/files.list.lzma > $tmp.$$ && mv $tmp.$$ $tmp
	fi
	case "$2" in
	lines)	if [ ! -s $tmp.lines -o $tmp -nt $tmp.lines ]; then
			wc -l < $tmp > $tmp.lines.$$ &&
			mv $tmp.lines.$$ $tmp.lines
		fi
		cat $tmp.lines ;;	
	*)	cat $tmp ;;
	esac
}

# xHTML Footer.
# TODO: caching the summary for 5 minutes
xhtml_footer() {
	PKGS=$(ls $WOK/ | wc -l)
	#FILES=$(unlzma < $filelist | wc -l)
	. lib/footer.sh
}

installed_size()
{
	if [ $VERBOSE -gt 0 ]; then
		inst=$(grep -A 3 "^$1\$" $pkgslist | grep installed)
#		size=$(echo $inst | cut -d'(' -f2 | cut -d' ' -f1)
		echo $inst | sed 's/.*(\(.*\).*/(\1)/'
#		echo $size
#		 | sed 's/.*(\(.*\) installed.*/(\1) /'
	fi
}

oddeven() {
	ifEven=$(cat $HOME/ifEven)
	[ "$1" == "1" ] && ifEven="0"
	case "$ifEven" in
		"0")	ifEven="1"; echo -n " class=\"even\"";;
		"1")	ifEven="0";;
	esac
	echo -n "$ifEven" > $HOME/ifEven
}

package_entry() {
	cat << EOT
<tr$(oddeven $1)>
EOT
	if [ -s "$(dirname $0)/$SLITAZ_VERSION/$CATEGORY.html" ]; then
		cat << _EOT_
	<td class="first"><a href="$SLITAZ_VERSION/$CATEGORY.html#$PACKAGE">$PACKAGE</a></td>
	<td class="first">$(installed_size $PACKAGE)</td>
	<td>$SHORT_DESC</td>
_EOT_
	else
		PACKAGE_URL="$MIRROR_URL/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION$EXTRA_VERSION.tazpkg"
		PACKAGE_HREF="<a href=\"$PACKAGE_URL\">$PACKAGE</a>"
		case "$SLITAZ_VERSION" in
		cooking) COOKER="<a href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\">$(gettext "Cooker")</a>";;
		undigest) COOKER="<a href=\"http://cook.slitaz.org/undigest/cooker.cgi?pkg=$PACKAGE\">$(gettext "Cooker")</a>";;
		backports) COOKER="<a href=\"http://cook.slitaz.org/backports/cooker.cgi?pkg=$PACKAGE\">$(gettext "Cooker")</a>";;
		*)      COOKER="";;
		esac
		cat << _EOT_
	<td class="first">$PACKAGE_HREF</td>
	<td class="first">$(installed_size $PACKAGE)</td>
	<td>$SHORT_DESC</td>
	<td><a href="?receipt=$PACKAGE&amp;version=$SLITAZ_VERSION">$(gettext "Receipt")</a>&nbsp;$COOKER</td>
_EOT_
	fi
	cat << EOT
</tr>
EOT
}

package_entry_inline() {
	if [ -s "$(dirname $0)/$SLITAZ_VERSION/$CATEGORY.html" ]; then
		cat << _EOT_
<a href="$SLITAZ_VERSION/$CATEGORY.html#$PACKAGE">$PACKAGE</a> $(installed_size $PACKAGE) : $SHORT_DESC
_EOT_
	else
		PACKAGE_URL="$MIRROR_URL/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION$EXTRA_VERSION.tazpkg"
		PACKAGE_HREF="<a href=\"$PACKAGE_URL\">$PACKAGE</a>"
		case "$SLITAZ_VERSION" in
		cooking) COOKER="<a href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\">$(gettext "Cooker")</a>";;
		undigest) COOKER="<a href=\"http://cook.slitaz.org/undigest/cooker.cgi?pkg=$PACKAGE\">$(gettext "Cooker")</a>";;
		backports) COOKER="<a href=\"http://cook.slitaz.org/backports/cooker.cgi?pkg=$PACKAGE\">$(gettext "Cooker")</a>";;
		*)      COOKER="";;
		esac
		cat << _EOT_
$PACKAGE_HREF $(installed_size $PACKAGE) : $SHORT_DESC \
<a href="?receipt=$PACKAGE&amp;version=$SLITAZ_VERSION">$(gettext "Receipt")</a>&nbsp;$COOKER
_EOT_
	fi
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
htmlize() {
	sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

display_packages_and_files() {
unset last
while read pkg file; do
	pkg=${pkg%:}
	if [ "$pkg" != "$last" ]; then
		. $WOK/$pkg/receipt

		package_entry_inline
		last=$pkg
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
	sedit=""
	case "$SLITAZ_VERSION" in
	cooking) [ -n "$VERSION" ] &&
		sedit="$sedit -e 's|\\(>VERSION<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"http://cook.slitaz.org/cooker.cgi?pkg=$PACKAGE\">\\2</a>|}'" ;;
	undigest|backports) [ -n "$VERSION" ] &&
		sedit="$sedit -e 's|\\(>VERSION<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"http://cook.slitaz.org/$SLITAZ_VERSION/cooker.cgi?pkg=$PACKAGE\">\\2</a>|}'" ;;
	esac
	#[ -n "$WEB_SITE" ] && sedit="$sedit -e '/WEB_SITE/{s|\\($WEB_SITE\\)|<a class='r-url' target='_blank' href=\"\\1\">\\1</a>|}'"
	[ -n "$WGET_URL" ] && sedit="$sedit -e 's|\\(>WGET_URL<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"$WGET_URL\">\\2</a>|}'"
	[ -n "$MAINTAINER" ] && sedit="$sedit -e '/MAINTAINER/{s|\\(${MAINTAINER/@/&#64;}\\)|<a class='r-url' target='_blank' href=\"?maintainer=\\1\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"
	[ -n "$CATEGORY" ] && sedit="$sedit -e '/CATEGORY/{s|\\($CATEGORY\\)|<a class='r-url' target='_blank' href=\"?category=\\1\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"
	[ -n "$LICENSE" ] && sedit="$sedit -e '/LICENSE/{s|\\($LICENSE\\)|<a class='r-url' target='_blank' href=\"?license=\\1\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"
	[ -f $WOK/$PACKAGE/description.txt ] && sedit="$sedit -e '/SHORT_DESC/{s|\\($SHORT_DESC\\)|<a class='r-url' target='_blank' href=\"?desc=$PACKAGE\\&amp;version=$SLITAZ_VERSION\">\\1</a>|}'"
	tarball_url=sources/packages-$SLITAZ_VERSION/${TARBALL:0:1}/$TARBALL
	[ -f /var/www/slitaz/mirror/$tarball_url ] || case "$tarball_url" in
		*.gz)	tarball_url=${tarball_url%gz}lzma ;;
		*.tgz)	tarball_url=${tarball_url%tgz}tar.lzma ;;
		*.bz2)	tarball_url=${tarball_url%bz2}lzma ;;
	esac
	[ -f /var/www/slitaz/mirror/$tarball_url ] && sedit="$sedit -e 's|\\(>TARBALL<[^\"]*\"\\)\\([^\"]*\\)|\\1<a class='r-url' target='_blank' href=\"http://mirror.slitaz.org/$tarball_url\">\\2</a>|'"
	if [ -n "$DEPENDS$BUILD_DEPENDS$SUGGESTED$PROVIDE$WANTED" ]; then
		for i in $(echo $DEPENDS $BUILD_DEPENDS $SUGGESTED $PROVIDE $WANTED) ; do
			sedit="$sedit -e 's|\\([\" >]\\)$i\\([\" <\\]\\)|\\1<a class='r-url' target='_blank' href=\\\"?receipt=$i\\&amp;version=$SLITAZ_VERSION\\\">$i</a>\\2|'"
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
}' | sort -k 4 | {
		while read cnt min max tag ; do
			if [ -z "$min" ]; then
				count=$cnt
				continue
			fi
			pct=$(((($cnt-$min)*100)/($max-$min)))
			pct=$(((10000 - ((100 - $pct)**2))/100))
			pct=$(((10000 - ((100 - $pct)**2))/100))
			cat <<EOT
<span style="color:#99f; font-size:9pt; padding-left:5px; padding-right:2px;">\
$cnt</span><a href="?$arg=$tag&amp;version=$SLITAZ_VERSION" style="\
font-size:$((8+($pct/10)))pt; font-weight:bold;
color:black; text-decoration:none">$tag</a>
EOT
		done
		echo "<p align=right>$count ${arg/ry/rie}s.</p>"
	}
}

#
# page begins
#
header "HTTP/1.1 200 OK" "Content-type: text/html"
xhtml_header

#
# language selector, if needed
#
if [ -z "$HTTP_ACCEPT_LANGUAGE" ]; then
	oldlang=$(GETPOST lang)
	if [ -z "$oldlang" ]; then
		oldlang="C"
		[ -z "$QUERY_STRING" ] && QUERY_STRING="lang=C" || QUERY_STRING="${QUERY_STRING}&lang=C"
	fi
	cat << EOT
<!-- Languages -->
<div id="lang">
EOT
	for i in en de fr pt ru zh; do
		cat << EOT
	<a href="$SCRIPT_NAME?$(echo "$QUERY_STRING" | sed s/"lang=$oldlang"/"lang=$i"/)">$(
		case $i in
			en) echo -n "English";;
			de) echo -n "Deutsch";;
			fr) echo -n "Français";;
			pt) echo -n "Português";;
			ru) echo -n "Русский";;
			zh) echo -n "中文";;
		esac)</a>
EOT
	done
	cat << EOT
</div>

EOT
fi

cat << EOT
<!-- Content -->
<div id="content">
EOT

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
GET=$(GET);
</pre>
EOT
#$(xhtml_footer)
#EOT
#		exit 0
	;;
esac

# Display search form and result if requested.
#xhtml_header
cat << EOT
<h2>$(gettext 'Search for packages')</h2>
<div id="ticker"><img src="style/images/loader.gif" alt="." /></div>
EOT
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
		unset ALL_DEPS
		dep_scan $SEARCH ""
		unset SUGGESTED
		. $WOK/$SEARCH/receipt
		if [ -n "$SUGGESTED" ]; then
			cat << _EOT_
</pre>

<h3>$(eval_gettext "Dependency tree for: \$SEARCH (SUGGESTED)")</h3>
<pre>
_EOT_
			unset ALL_DEPS
			dep_scan "$SUGGESTED" "    "
		fi
		cat << _EOT_
</pre>

<h3>$(eval_gettext "Reverse dependency tree for: \$SEARCH")</h3>
<pre>
_EOT_
		unset ALL_DEPS
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
		unset ALL_DEPS
		dep_scan $SEARCH "" build
		cat << _EOT_
</pre>

<h3>$(eval_gettext "Packages who need \$SEARCH to be built")</h3>
<pre>
_EOT_
		unset ALL_DEPS
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
		( unlzma < $filelist | grep ^$SEARCH: ;
		  unlzma < $filelist | grep -v ^$SEARCH: ) | awk '
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
<table>
_EOT_
		unset last
		unlzma < $filelist \
		| grep "$SEARCH" | while read pkg file; do
			echo "$file" | grep -q "$SEARCH" || continue
			if [ "$last" != "${pkg%:}" ]; then
				last=${pkg%:}
				(
				. $WOK/$last/receipt
				[ -n "$last" ] && cat << EOT
</td></tr>
EOT
				cat << _EOT_

$(package_entry 1)
<tr><td colspan="3" class="pre">
_EOT_
				)
			fi
			echo -n "$file" | sed s/"$SEARCH"/"<span class='match'>$SEARCH<\/span>"/g 
			echo "<br />"
		done
		cat << _EOT_
</td></tr>
</table>
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
		unset last
		unlzma < $filelist \
		| grep ^$SEARCH: | sed 's/.*: /    /' | sort
		cat << _EOT_
</pre>
<pre>
_EOT_
		filenb=$(unlzma < $filelist | grep ^$SEARCH: | wc -l)
		eval_ngettext "\$filenb file" "\$filenb files" $filenb
		cat << _EOT_
  \
$(busybox sed -n "/^$SEARCH$/{nnnpq}" $pkglist)
</pre>
_EOT_
	fi
	;;


### Package description
Desc)
	if [ -f $WOK/$SEARCH/description.txt ]; then
		cat << _EOT_

<h3>$(eval_gettext "Description of package: \$SEARCH")</h3>
<table>
$(htmlize < $WOK/$SEARCH/description.txt)
</table>
_EOT_
	else
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<table>
_EOT_
		unset last
		grep -i "$SEARCH" $pkgsrepo/packages.desc | \
		sort | while read pkg extras ; do
			. $WOK/$pkg/receipt
			package_entry
		done
		cat << _EOT_
</table>
_EOT_
	fi
	;;

Bugs)
	cat << _EOT_

<h3>$(eval_gettext "Result for known bugs")</h3>
<pre>
_EOT_
	unset last
	grep ^BUGS= $WOK/*/receipt | \
	sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
		unset BUGS
		. $WOK/$pkg/receipt
		package_entry_inline
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
	unset last
	grep ^HOST_ARCH= $WOK/*/receipt |  grep -i "$SEARCH" | \
	sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
		unset HOST_ARCH
		. $WOK/$pkg/receipt
		echo " $HOST_ARCH " | grep -iq " $SEARCH " &&
		package_entry_inline
	done
	cat << _EOT_
</pre>
_EOT_
	;;

### Maintainer
Maintainer)
	if [ -n "$SEARCH" ]; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<table>
_EOT_
		unset last
		grep ^MAINTAINER= $WOK/*/receipt | grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			. $WOK/$pkg/receipt
			package_entry
		done
		cat << _EOT_
</table>
_EOT_
	else
		# Display maintainer cloud
		grep -l ^MAINTAINER= $WOK/*/receipt | while read file; do
			MAINTAINER=
			. $file
			echo $MAINTAINER
			done | display_cloud maintainer
	fi
	;;

### License
License)
	if [ -n "$SEARCH" ]; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<table>
_EOT_
		unset last
		grep ^LICENSE= $WOK/*/receipt | grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			. $WOK/$pkg/receipt
			package_entry
		done
		cat << _EOT_
</table>
_EOT_
	else
		# Display license cloud
		grep -l ^LICENSE= $WOK/*/receipt | while read file; do
			LICENSE=
			. $file
			echo $LICENSE
			done | display_cloud license
	fi
	;;

### Category
Category)
	if [ -n "$SEARCH" ]; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<table>
_EOT_
		unset last
		grep ^CATEGORY= $WOK/*/receipt | grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			. $WOK/$pkg/receipt
			package_entry
		done
		cat << _EOT_
</table>
_EOT_
	else
		# Display category cloud
		grep -l ^CATEGORY= $WOK/*/receipt | while read file; do
			CATEGORY=
			. $file
			echo $CATEGORY
			done | display_cloud category
	fi
	;;

### Tags
Tags)
	if [ -n "$SEARCH" ]; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<table>
_EOT_
		unset last
		grep ^TAGS= $WOK/*/receipt | grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
			. $WOK/$pkg/receipt
			package_entry
		done
		cat << _EOT_
</table>
_EOT_
	else
		# Display tag cloud
		grep -l ^TAGS= $WOK/*/receipt | while read file; do
			TAGS=
			. $file
			echo $TAGS
			done | display_cloud args
	fi
	;;


### Package receipt with syntax highlighter
Receipt)
	if package_exist "$SEARCH"; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<pre>
_EOT_
		if [ -f "$WOK/$SEARCH/taz/*/receipt" ]; then
			syntax_highlighter "$WOK/$SEARCH/taz/*/receipt"
		else
			syntax_highlighter "$WOK/$SEARCH/receipt"
		fi
		echo '</pre>'
	fi
	;;


### Package
Package)
	if package_exist $SEARCH; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<table>
_EOT_
		for pkg in `ls $WOK/ | grep "$SEARCH"`
		do
			. $WOK/$pkg/receipt
			DESC=" <p><a href=\"?object=Desc&query=$pkg&lang=$lang&version=$SLITAZ_VERSION$(ifdebug '&')&submit=go\">$(gettext description)</a><p>"
			[ -f $WOK/$pkg/description.txt ] || unset DESC
			cat << _EOT_
$(package_entry)$DESC
_EOT_
		done
		vpkgs="$(cut -d= -f1 < $equiv | grep $SEARCH)"
		for vpkg in $vpkgs ; do
			cat << _EOT_
</table>

<h3>$(eval_gettext "Result for: \$SEARCH (package providing \$vpkg)")</h3>
<table>
_EOT_
			for pkg in $(grep $vpkg= $equiv | sed "s/$vpkg=//"); do
				. $WOK/${pkg#*:}/receipt
				package_entry
			done
		done
		cat << _EOT_
</table>
_EOT_
	fi
	;;
esac

xhtml_footer

exit 0
