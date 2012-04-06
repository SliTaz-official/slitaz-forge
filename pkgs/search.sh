#!/bin/sh
# Tiny CGI search engine for SliTaz packages on http://pkgs.slitaz.org/
# Christophe Lincoln <pankso@slitaz.org>
#

renice 20
read QUERY_STRING
for i in $(echo $QUERY_STRING | sed 's/&/ /g'); do
	i=$(httpd -d $i)
	eval $i
done
LANG=$lang
SEARCH=$query
SLITAZ_VERSION=$version
OBJECT=$object
DATE=$(date +%Y-%m-%d\ %H:%M:%S)
VERSION=cooking
if [ "$REQUEST_METHOD" = "GET" ]; then
	SEARCH=""
	VERBOSE=0
	for i in $(echo $REQUEST_URI | sed 's/[?&]/ /g'); do
		# i=$(httpd -d $i)
		SLITAZ_VERSION=cooking
		case "$(echo $i | tr [A-Z] [a-z])" in
		query=*|search=*)
			[ ${i#*=} == Search ] || SEARCH=${i#*=};;
		object=*)
			OBJECT=${i#*=};;
		verbose=*)
			VERBOSE=${i#*=};;
		lang=*)
			LANG=${i#*=};;
		file=*)
			SEARCH=${i#*=}
			OBJECT=File;;
		desc=*)
			SEARCH=${i#*=}
			OBJECT=Desc;;
		tags=*)
			SEARCH=${i#*=}
			OBJECT=Tags;;
		receipt=*)
			SEARCH=${i#*=}
			OBJECT=Receipt;;
		filelist=*)
			SEARCH=${i#*=}
			OBJECT=File_list;;
		package=*)
			SEARCH=${i#*=}
			OBJECT=Package;;
		depends=*)
			SEARCH=${i#*=}
			OBJECT=Depends;;
		builddepends=*)
			SEARCH=${i#*=}
			OBJECT=BuildDepends;;
		fileoverlap=*)
			SEARCH=${i#*=}
			OBJECT=FileOverlap;;
		version=s*|version=3*)
			SLITAZ_VERSION=stable;;
		version=[1-9]*)
			i=${i%%.*}
			SLITAZ_VERSION=${i#*=}.0;;
		version=u*)
			SLITAZ_VERSION=undigest;;
		esac
	done
	[ -n "$SEARCH" ] && REQUEST_METHOD="POST"
	[ "$SEARCH" == "." ] && SEARCH=
fi

case "$OBJECT" in
File)	 	selected_file="selected";;
Desc)	 	selected_desc="selected";;
Tags)	 	selected_tags="selected";;
Receipt) 	selected_receipt="selected";;
File_list) 	selected_file_list="selected";;
Depends)	selected_depends="selected";;
BuildDepends)	selected_build_depends="selected";;
FileOverlap)	selected_overlap="selected";;
esac

case "$SLITAZ_VERSION" in
tiny)		selected_tiny="selected";;
1.0)	 	selected_1="selected";;
2.0)	 	selected_2="selected";;
stable)		selected_stable="selected";;
undigest)	selected_undigest="selected";;
esac

# unescape query
SEARCH="$(echo $SEARCH | sed 's/%2B/+/g' | sed 's/%3A/:/g' | sed 's|%2F|/|g')"

if [ -z "$LANG" ]; then
	for i in $(echo $HTTP_ACCEPT_LANGUAGE | sed 's/[,;]/ /g'); do
		case "$i" in
		fr|de|pt|ru|cn)
			LANG=$i
			break;;
		esac
	done
fi

# --- Search form
_package="Package"
_desc="Description"
_tags="Tags"
_receipt="Receipt"
_depends="Depends"
_bdepends="Build depends"
_file="File"
_file_list="File list"
_overlap="common files"
_cooking="cooking"
_search="Search"
# --- Titles
_noresult="No package $SEARCH"
_search_title="Search"
_depends_loops="Depends loops"
_deptree="Dependency tree for: $SEARCH"
_deptree_suggested="$_deptree (SUGGESTED)"
_rdeptree="Reverse dependency tree for: $SEARCH"
_bdepends_loops="Build depends loops"
_bdeplist="$SEARCH needs these packages to be built"
_rbdeplist="Packages who need $SEARCH to be built"
_overloading="Theses packages may overload files of $SEARCH"
_result="Result for: $SEARCH"
_result_providing="$_result (package providing %VPKG%)"
# --- Messages
_main_libs_warn="glibc-base and gcc-lib-base are implicit dependencies, <b>every</b> package is supposed to depend on them."
_description="description"
_pkgs_report="%PKGS% packages and %FILES% files in $SLITAZ_VERSION database"
# --- HTML Header
_h_title="SliTaz Packages - Search %SEARCH%"

case "$LANG" in

fr)	_package="Paquet"
#	_desc=
#	_tags=
	_receipt="Recette"
	_depends="Dépendances"
	_bdepends="Fabrication"
	_file="Fichier"
	_file_list="Liste des fichiers"
	_overlap="Fichiers communs"
#	_cooking=
	_search="Recherche"

	_noresult="Paquet $SEARCH introuvable"
	_search_title="Search"
	_depends_loops="Dépendances sans fin"
	_deptree="Arbre des dépendances de $SEARCH"
	_deptree_suggested="$_deptree (SUGGESTED)"
	_rdeptree="Arbre inversé des dépendances de $SEARCH"
	_bdepends_loops="Fabrication sans fin"
	_bdeplist="$SEARCH a besion de ces paquets pour être fabriqué"
	_rbdeplist="Paquets ayant besion de $SEARCH pour être fabriqués"
	_overloading="Paquets pouvant écraser des fichiers de $SEARCH"
	_result="Recherche de : $SEARCH"
	_result_providing="$_result (package providing %VPKG%)"

	_main_libs_warn="	glibc-base and gcc-lib-base are implicit dependencies,
	<b>every</b> package is supposed to depend on them."
	_description="description"
	_pkgs_report="%PKGS% packages and %FILES% files in $SLITAZ_VERSION database"
	;;

de)	_package="Paket"
	_desc="Beschreibung"
#	_tags=
#	_receipt=
	_depends="Abhängigkeiten"
#	_bdepends=
	_file="Datei"
	_file_list="Datei liste"
#	_overlap=
	_cooking="Cooking"
	_search="Suche"

	_noresult="Kein Paket für $SEARCH"
	_search_title="Search"
	_depends_loops="Abhängigkeiten loops"
	_deptree="Abhängigkeiten von: $SEARCH"
	_deptree_suggested="$_deptree (SUGGESTED)"
	_rdeptree="Abhängigkeit für: $SEARCH"
#	_bdepends_loops=
#	_bdeplist=
#	_rbdeplist=
#	_overloading=
	_result="Resultate für : $SEARCH"
	_result_providing="$_result (package providing %VPKG%)"

#	_main_libs_warn=
#	_description=
#	_pkgs_report=
	;;

pt)	_package="Pacote"
	_desc="Descrição"
#	_tags=
#	_receipt=
	_depends="Dependências"
#	_bdepends=
	_file="Arquivo"
	_file_list="Arquivo lista"
#	_overlap=
#	_cooking=
	_search="Buscar"

	_noresult="Sem resultado: $SEARCH"
#	_search_title=
	_depends_loops="Dependências loops"
	_deptree="Árvore de dependências para: $SEARCH"
	_deptree_suggested="$_deptree (SUGGESTED)"
	_rdeptree="Árvore de dependências reversa para: $SEARCH"
#	_bdepends_loops=
#	_bdeplist=
#	_rbdeplist=
#	_overloading=
	_result="Resultado para : $SEARCH"
	_result_providing="$_result (package providing %VPKG%)"

#	_main_libs_warn=
#	_description=
#	_pkgs_report=
	;;

cn)	_package="软件包："
	_desc="描述"
	_tags="标签"
#	_receipt=
	_depends="依赖"
#	_bdepends=
	_file="文件"
	_file_list="文件列表"
#	_overlap=
	_cooking="开发版"
#	_search=

#	_noresult=
#	_search_title=
	_depends_loops="依赖 loops"
#	_deptree=
#	_deptree_suggested=
#	_rdeptree=
#	_bdepends_loops=
#	_bdeplist=
#	_rbdeplist=
#	_overloading=
#	_result=
#	_result_providing=

#	_main_libs_warn=
#	_description=
#	_pkgs_report=
#	_stable="稳定版"
	;;

ru)	_package="пакет"
	_desc="описание"
	_tags="теги"
	_receipt="рецепт"
	_depends="зависимости"
	_bdepends="зависимости сборки"
	_file="файл"
	_file_list="список файлов"
	_overlap="общие файлы"
#	_cooking=
	_search="Искать"

	_noresult="Пакет $SEARCH отсутствует"
	_search_title="Поиск"
	_depends_loops="Циклические зависимости"
	_deptree="Дерево зависимостей для $SEARCH"
	_deptree_suggested="Дерево необязательных зависимостей для $SEARCH"
	_rdeptree="Обратное дерево зависимостей для $SEARCH"
	_bdepends_loops="Циклические зависимости сборки"
	_bdeplist="Следующие пакеты нужны, чтобы собрать $SEARCH"
	_rbdeplist="$SEARCH нужен, чтобы собрать следующие пакеты"
	_overloading="Следующие пакеты могут заменить файлы $SEARCH"
	_result="Результаты поиска $SEARCH"
	_result_providing="$_result (пакеты, предлагающие %VPKG%)"

	_main_libs_warn="glibc-base и gcc-lib-base являются неявными зависимостями <b>любого</b> пакета."
	_description="описание"
	_pkgs_report="%PKGS% пакетов и %FILES% файлов в базе данных $SLITAZ_VERSION"
	;;

*)	LANG="en";;

esac

WOK=/home/slitaz/$SLITAZ_VERSION/wok
PACKAGES_REPOSITORY=/home/slitaz/$SLITAZ_VERSION/packages

echo "Content-type: text/html"
echo

# Search form
search_form()
{
	cat << _EOT_

<div style="text-align: center; padding: 20px;">
<form method="post" action="$(basename $SCRIPT_NAME)">
	<input type="hidden" name="lang" value="$LANG" />
	<select name="object">
		<option value="Package">$_package</option>
		<option $selected_desc value="Desc">$_desc</option>
		<option $selected_tags value="Tags">$_tags</option>
		<option $selected_receipt value="Receipt">$_receipt</option>
		<option $selected_depends value="Depends">$_depends</option>
		<option $selected_build_depends value="BuildDepends">$_bdepends</option>
		<option $selected_file value="File">$_file</option>
		<option $selected_file_list value="File_list">$_file_list</option>
		<option $selected_overlap value="FileOverlap">$_overlap</option>
	</select>
	<input type="text" name="query" size="20" value="$SEARCH" />
	<select name="version">
		<option value="cooking">$_cooking</option>
		<option $selected_stable value="stable">3.0</option>
		<option $selected_2 value="2.0">2.0</option>
		<option $selected_1 value="1.0">1.0</option>
		<option $selected_tiny value="tiny">tiny</option>
		<option $selected_undigest value="undigest">undigest</option>
	</select>
	<input type="submit" name="search" value="$_search" />
</form>
</div>
_EOT_
}

# xHTML Header.
xhtml_header() {
	header=$(cat lib/header.html | sed s/'%SEARCH%'/"$SEARCH"/)
	# header i18n
	case "$LANG" in
	pt)
		header=$(echo "$header" | sed 's/SliTaz Packages/SliTaz Pacotes/g;s/Community/Comunidade/;s/Forum/Fórum');;
	ru)
		header=$(echo "$header" | sed 's/SliTaz Packages/Пакеты SliTaz/g;s/Home/Сайт/;s/Community/Сообщество/;s/Doc/Документация/;s/Forum/Форум/;s/Pro/PRO/;s/Shop/Магазин/;s/Bugs/Баг-трекер/');;
	esac
	echo "$header"
}

# xHTML Footer.
xhtml_footer() {
# Is it not too hard? (unlzma etc...) -- lexeii
PKGS=$(ls $WOK/ | wc -l)
FILES=$(unlzma -c $PACKAGES_REPOSITORY/files.list.lzma | wc -l)
	cat << _EOT_

<center>
<i>$(echo $_pkgs_report | sed s/'%PKGS%'/"$PKGS"/ | sed s/'%FILES%'/"$FILES"/)</i>
</center>

_EOT_
	cat lib/footer.html
}

installed_size()
{
[ $VERBOSE -gt 0 ] &&
grep -A 3 "^$1\$" $PACKAGES_REPOSITORY/packages.txt | \
       grep installed | sed 's/.*(\(.*\) installed.*/(\1) /'
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
	PACKAGE_URL="http://mirror.slitaz.org/packages/$SLITAZ_VERSION/$(cd /var/www/slitaz/mirror/packages/$SLITAZ_VERSION ; ls $PACKAGE-$VERSION*.tazpkg)"
	busybox wget -s $PACKAGE_URL 2> /dev/null &&
	PACKAGE_HREF="<a href=\"$PACKAGE_URL\">$PACKAGE</a>"
	cat << _EOT_
$PACKAGE_HREF $(installed_size $PACKAGE): $SHORT_DESC
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
	echo $pkg ":" $@ "..."
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
glibc-base|gcc-lib-base) echo $_main_libs_warn
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

<h3>$_noresult</h3>
<pre>
_EOT_
	return 1
}

# Display < > &
htmlize()
{
	sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

echonb()
{
read n
echo -n "$n $1"
[ $n -gt 1 ] && echo -n s
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

# Display search form and result if requested.
if [ "$REQUEST_METHOD" != "POST" ]; then
	xhtml_header
	cat << _EOT_

<!-- Content -->
<div id="content">
<a name="content"></a>

<h2>$_search_title</h2>
_EOT_
	search_form
	xhtml_footer
else
	xhtml_header
	cat << _EOT_

<!-- Content -->
<div id="content">
<a name="content"></a>

<h2>$_search_title</h2>
_EOT_
	search_form
	if [ "$OBJECT" = "Depends" ]; then
		if [ -z "$SEARCH" ]; then
			cat << _EOT_

<h3>$_depends_loops</h3>
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

<h3>$_deptree</h3>
<pre>
_EOT_
			ALL_DEPS=""
			dep_scan $SEARCH ""
			SUGGESTED=""
			. $WOK/$SEARCH/receipt
			if [ -n "$SUGGESTED" ]; then
				cat << _EOT_
</pre>

<h3>$_deptree_suggested</h3>
<pre>
_EOT_
				ALL_DEPS=""
				dep_scan "$SUGGESTED" "    "
			fi
			cat << _EOT_
</pre>

<h3>$_rdeptree</h3>
<pre>
_EOT_
			ALL_DEPS=""
			rdep_scan $SEARCH
			cat << _EOT_
</pre>
_EOT_
		fi
	elif [ "$OBJECT" = "BuildDepends" ]; then
		if [ -z "$SEARCH" ]; then
			cat << _EOT_

<h3>$_bdepends_loops</h3>
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

<h3>$_bdeplist</h3>
<pre>
_EOT_
			ALL_DEPS=""
			dep_scan $SEARCH "" build
			cat << _EOT_
</pre>

<h3>$_rbdeplist</h3>
<pre>
_EOT_
			ALL_DEPS=""
			rdep_scan $SEARCH build
			cat << _EOT_
</pre>
_EOT_
		fi
	elif [ "$OBJECT" = "FileOverlap" ]; then
		if package_exist $SEARCH ; then
			cat << _EOT_

<h3>$_overloading</h3>
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
	elif [ "$OBJECT" = "File" ]; then
		cat << _EOT_

<h3>$_result</h3>
<pre>
_EOT_
		last=""
		unlzma -c $PACKAGES_REPOSITORY/files.list.lzma \
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
	elif [ "$OBJECT" = "File_list" ]; then
		if package_exist $SEARCH; then
			cat << _EOT_

<h3>$_result</h3>
<pre>
_EOT_
			last=""
			unlzma -c $PACKAGES_REPOSITORY/files.list.lzma \
			| grep ^$SEARCH: |  sed 's/.*: /    /' | sort
			cat << _EOT_
</pre>
<pre>
$(unlzma -c $PACKAGES_REPOSITORY/files.list.lzma | grep ^$SEARCH: | wc -l | echonb file)  \
$(busybox sed -n "/^$SEARCH$/{nnnpq}" $PACKAGES_REPOSITORY/packages.txt)
_EOT_
		fi
	elif [ "$OBJECT" = "Desc" ]; then
		if [ -f $WOK/$SEARCH/description.txt ]; then
			cat << _EOT_

<h3>$_result</h3>
<pre>
$(htmlize < $WOK/$SEARCH/description.txt)
</pre>
_EOT_
		else
			cat << _EOT_

<h3>$_result</h3>
<pre>
_EOT_
			last=""
			grep -i "$SEARCH" $PACKAGES_REPOSITORY/packages.desc | \
			sort | while read pkg extras ; do
				. $WOK/$pkg/receipt
				package_entry
			done
		fi
	elif [ "$OBJECT" = "Tags" ]; then
		cat << _EOT_

<h3>$_result</h3>
<pre>
_EOT_
		last=""
		grep ^TAGS= $WOK/*/receipt |  grep -i "$SEARCH" | \
		sed "s|$WOK/\(.*\)/receipt:.*|\1|" | sort | while read pkg ; do
				. $WOK/$pkg/receipt
				package_entry
			done
	elif [ "$OBJECT" = "Receipt" ]; then
		package_exist $SEARCH && cat << _EOT_

<h3>$_result</h3>
<pre>
$(if [ -f  $WOK/$SEARCH/taz/*/receipt ]; then
	cat $WOK/$SEARCH/taz/*/receipt
  else
    cat $WOK/$SEARCH/receipt
  fi | htmlize)
</pre>
_EOT_
	else
		cat << _EOT_

<h3>$_result</h3>
<pre>
_EOT_
		for pkg in `ls $WOK/ | grep "$SEARCH"`
		do
			. $WOK/$pkg/receipt
			DESC=" <a href=\"?desc=$pkg\">$_description</a>"
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

<h3>$(echo $_result_providing | sed s/'%VPKG%'/"$vpkg"/)</h3>
<pre>
_EOT_
			for pkg in $(grep $vpkg= $equiv | sed "s/$vpkg=//"); do
				. $WOK/${pkg#*:}/receipt
				package_entry
			done
		done
	fi
	cat << _EOT_
</pre>
_EOT_
	xhtml_footer
fi

exit 0
