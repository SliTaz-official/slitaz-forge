#!/bin/sh
# Tiny CGI search engine for SliTaz packages on http://pkgs.slitaz.org/
# Christophe Lincoln <pankso@slitaz.org>
# Aleksej Bobylev <al.bobylev@gmail.com>
#

# Parse query string
. /usr/lib/slitaz/httphelper.sh
echo -n "0" > $HOME/ifEven

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
			es) LANG="es_ES" ;;
			fr) LANG="fr_FR" ;;
			it) LANG="it_IT" ;;
			pt) LANG="pt_BR" ;;
			ru) LANG="ru_RU" ;;
			zh) LANG="zh_TW" ;;
		esac
		if echo "de en fr pt ru zh" | fgrep -q "$lang"; then
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
if [ "$REQUEST_METHOD" == "POST" -o ! -z $(GET submit) ]; then
	OBJECT=$(GETPOST object)
	SEARCH=$(GETPOST query)
	case "$OBJECT" in
		Package)		NICE="package=$SEARCH";;
		Desc)			NICE="desc=$SEARCH";;
		Tags)			NICE="tags=$SEARCH";;
		Receipt)		NICE="receipt=$SEARCH";;
		Depends)		NICE="depends=$SEARCH";;
		BuildDepends)	NICE="builddepends=$SEARCH";;
		File)			NICE="file=$SEARCH";;
		File_list)		NICE="filelist=$SEARCH";;
		FileOverlap)	NICE="fileoverlap=$SEARCH";;
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
	exit 0
fi



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
		receipt=*)				SEARCH=${i#*=}; OBJECT=Receipt;;
		filelist=*)				SEARCH=${i#*=}; OBJECT=File_list;;
		package=*)				SEARCH=${i#*=}; OBJECT=Package;;
		depends=*)				SEARCH=${i#*=}; OBJECT=Depends;;
		builddepends=*)			SEARCH=${i#*=}; OBJECT=BuildDepends;;
		fileoverlap=*)			SEARCH=${i#*=}; OBJECT=FileOverlap;;
		version=[1-9]*)			i=${i%%.*}; SLITAZ_VERSION=${i#*=}.0;;
		version=s*|version=4*)	SLITAZ_VERSION=stable;;
		version=u*)				SLITAZ_VERSION=undigest;;
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
			<option $selected_receipt value="Receipt">$(gettext "Receipt")</option>
			<option $selected_depends value="Depends">$(gettext "Depends")</option>
			<option $selected_build_depends value="BuildDepends">$(gettext "Build depends")</option>
			<option $selected_file value="File">$(gettext "File")</option>
			<option $selected_file_list value="File_list">$(gettext "File list")</option>
			<option $selected_overlap value="FileOverlap">$(gettext "common files")</option>
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

# xHTML Footer.
# TODO: caching the summary for 5 minutes
xhtml_footer() {
	PKGS=$(ls $WOK/ | wc -l)
	FILES=$(unlzma -c $PACKAGES_REPOSITORY/files.list.lzma | wc -l)
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
		PACKAGE_HREF="<u>$PACKAGE</u>"
		PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION$EXTRA_VERSION.tazpkg"
		nslookup mirror.slitaz.org | grep -q 127.0.0.1 &&
		PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$(cd /var/www/slitaz/mirror/packages/$SLITAZ_VERSION ; ls $PACKAGE-$VERSION*.tazpkg)"
		busybox wget -s $PACKAGE_URL 2> /dev/null &&
		PACKAGE_HREF="<a href=\"$PACKAGE_URL\">$PACKAGE</a>"
		cat << _EOT_
	<td class="first">$PACKAGE_HREF</td>
	<td class="first">$(installed_size $PACKAGE)</td>
	<td>$SHORT_DESC</td>
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
		PACKAGE_HREF="<u>$PACKAGE</u>"
		PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$PACKAGE-$VERSION$EXTRA_VERSION.tazpkg"
		nslookup mirror.slitaz.org | grep -q 127.0.0.1 &&
		PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$(cd /var/www/slitaz/mirror/packages/$SLITAZ_VERSION ; ls $PACKAGE-$VERSION*.tazpkg)"
		busybox wget -s $PACKAGE_URL 2> /dev/null &&
		PACKAGE_HREF="<a href=\"$PACKAGE_URL\">$PACKAGE</a>"
		cat << _EOT_
$PACKAGE_HREF $(installed_size $PACKAGE) : $SHORT_DESC
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
last=""
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
	cat "$1" | sed -e "s|\&|\&amp;|g; s|<|\&lt;|g; s|>|\&gt;|g; s|	|    |g" \
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
			-e "s|~|</span>|g"
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
		if [ package_exist $SEARCH ]; then
		cat << _EOT_

<h3>$(eval_gettext "These packages may overload files of \$SEARCH")</h3>
<pre>
_EOT_
		( unlzma -c $PACKAGES_REPOSITORY/files.list.lzma | grep ^$SEARCH: ;
		  unlzma -c $PACKAGES_REPOSITORY/files.list.lzma | grep -v ^$SEARCH: ) | awk '
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
		last=""
		unlzma -c $PACKAGES_REPOSITORY/files.list.lzma \
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
		last=""
		unlzma -c $PACKAGES_REPOSITORY/files.list.lzma \
		| grep ^$SEARCH: | sed 's/.*: /    /' | sort
		cat << _EOT_
</pre>
<pre>
_EOT_
		filenb=$(unlzma -c $PACKAGES_REPOSITORY/files.list.lzma | grep ^$SEARCH: | wc -l)
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
		last=""
		grep -i "$SEARCH" $PACKAGES_REPOSITORY/packages.desc | \
		sort | while read pkg extras ; do
			. $WOK/$pkg/receipt
			package_entry
		done
		cat << _EOT_
</table>
_EOT_
	fi
	;;


### Tags
Tags)
	if [ -n "$SEARCH" ]; then
		cat << _EOT_

<h3>$(eval_gettext "Result for: \$SEARCH")</h3>
<table>
_EOT_
		last=""
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
			done | awk '
{
	for (i = 1; $i != ""; i++)
		count[$i]++
}
END {
	min=10000
	max=0
	for (i in count) {
		if (count[i] < min) min = count[i]
		if (count[i] > max) max = count[i]
	}
	for (i in count) 
		print count[i] " " min " " max " " i
}' | while read cnt min max tag ; do
			cat <<EOT
<span style="color:#99f; font-size:9pt; padding-left:5px; padding-right:2px;">\
$cnt</span><a href="?tags=$tag&amp;version=$SLITAZ_VERSION" style="\
font-size:$((8+(($cnt-$min)*10)/($max-$min)))pt; font-weight:bold; \
color:black; text-decoration:none">$tag</a>
EOT
		done
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
			DESC=" <a href=\"?object=Desc&query=$pkg&lang=$lang&version=$SLITAZ_VERSION$(ifdebug '&')&submit=go\">$(gettext description)</a>"
			[ -f $WOK/$pkg/description.txt ] || DESC=""
			cat << _EOT_
$(package_entry)$DESC
_EOT_
		done
		equiv=$PACKAGES_REPOSITORY/packages.equiv
		vpkgs="$(cat $equiv | cut -d= -f1 | grep $SEARCH)"
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
