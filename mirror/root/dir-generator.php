<?php
if (substr_count($_SERVER['HTTP_ACCEPT_ENCODING'], 'gzip'))
	ob_start('ob_gzhandler');
else
	ob_start();

function redirect() {
?>
<!DOCTYPE html>
<html lang="en">
<head>
	<title>SliTaz mirror redirection</title>
	<meta charset="UTF-8">
	<meta name="description" content="slitaz mirror redirection">
	<meta name="robots" content="index, nofollow">
	<meta name="referrer" content="no-referrer">
	<meta name="author" content="SliTaz Contributors">
	<meta http-equiv="Refresh" content="0;url=http://mirror1.slitaz.org/">
</head>
<body>
	<script>window.location.replace('http://mirror1.slitaz.org/')</script>
	<noscript>
	<frameset rows="100%">
		<frame src="http://mirror1.slitaz.org/">
		<noframes>
		<body>Please follow <a href="http://mirror1.slitaz.org/">this link</a>.</body>
		</noframes>
	</frameset>
	</noscript>
</body>
</html>
<?php
}

$VERSION = "0.4-slitaz";

/*  Lighttpd Enhanced Directory Listing Script
 *  ------------------------------------------
 *  Authors: Evan Fosmark   <me@evanfosmark.com>,
 *           Pascal Bellard <pascal.bellard@slitaz.org>
 *           Christophe Lincoln <pankso@slitaz.org>
 *
 *
 *  GNU License Agreement
 *  ---------------------
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *  http://www.gnu.org/licenses/gpl.txt
 */


// Get the path (cut out the query string from the request_uri)
list($path) = explode('?', $_SERVER['REQUEST_URI']);


// Get the path that we're supposed to show.
$path = ltrim(rawurldecode($path), '/');


if(strlen($path) == 0)
	$path = "./";


// Can't call the script directly since REQUEST_URI won't be a directory
if($_SERVER['PHP_SELF'] == '/' . $path) {
	redirect();
//	die("Unable to call " . $path . " directly.");
}


$vpath = ($path != "./") ? $path : "";
// Make sure it is valid.
if (!is_dir($path)) {
//	die("<b>" . $path . "</b> is not a valid path.");
	$path = dirname($_SERVER["SCRIPT_FILENAME"]);
	list($vpath) = explode('?', $_SERVER['REQUEST_URI']);
	$vpath = ltrim(rawurldecode($vpath), '/');
}


//
// This function returns the file size of a specified $file.
//
function format_bytes($size, $precision=1) {
	$sizes = array('Y', 'Z', 'E', 'P', 'T', 'G', 'M', 'K', '');
	$total = count($sizes);

	while ($total-- && $size > 1024)
		$size /= 1024;
	if ($sizes[$total] == '') {
		$size /= 1024;
		$total--;
	}
	return sprintf('%.' . $precision . 'f', $size) . $sizes[$total];
}


//
// Get some variables from /etc/lighttpd/lighttpd.conf
//
$conf_lightty = file_get_contents("/etc/lighttpd/lighttpd.conf");

function get_conf($var, $start, $stop, $default='') {
	global $conf_lightty;

	if (!preg_match('/' . $var . '/', $conf_lightty))
		return $default;
	$filter = '/(.*\n)*' . $var . '\s*=\s*' . $start . '(([^' . $stop . ']*\n*)*)' . $stop . '(.*\n)*/';
	return preg_replace($filter, '$2', $conf_lightty);
}

$encoding = get_conf('dir-listing.encoding', '"', '"', 'ascii');
$external_css = get_conf('dir-listing.external-css', '"', '"');

$show_hidden_files = false;
if (get_conf('dir-listing.hide-dotfile', '"', '"', 'disable') == "disable")
	$show_hidden_files = true;
// get_conf('dir-listing.exclude','\(','\)');
// get_conf('dir-listing.set-footer','"','"');

$mime_types = array();
foreach (explode(',', get_conf('mimetype.assign','\(','\)')) as $item) {
	$filter = '/\s*"(.*)"\s*=>\s*"(.*)".*/';
	$val = explode(',', preg_replace($filter, '$1,$2', $item));
	if (isset($val[1]))
		$mime_types[$val[0]] = $val[1];
}


//
// This function returns the mime type of $file.
//
function get_file_type($file) {
	global $mime_types;

	$file = basename($file);
	$default_type = "application/octet-stream";
	if (isset($mime_types[$file]))
		return $mime_types[$file];
	$pos = strrpos($file, ".");
	if ($pos === false)
		return $default_type;
//FIXME .tar.gz
	$ext = '.' . rtrim(substr($file, $pos+1), "~");
	if (isset($mime_types[$ext]))
		return $mime_types[$ext];
	return $default_type;
}




//$slitaz_style = (dirname($_SERVER["PHP_SELF"]) == '/');
//$slitaz_style = ($_SERVER["SERVER_NAME"] == "mirror1.slitaz.org");
$slitaz_style = preg_match("/mirror1\.slitaz\./", $_SERVER["SERVER_NAME"]);
if (!$slitaz_style) $slitaz_style = preg_match("/mirror\.slitaz\./", $_SERVER["SERVER_NAME"]);

if ($slitaz_style) {
	// SliTaz Style
	$modified = gmdate("D, d M Y H:i:s e", strtotime("-1 hour"));
	$expires  = gmdate("D, d M Y H:i:s e", strtotime("+1 hour"));
	$fvalue = "";
	if (isset($_GET['f']))
		$fvalue = 'value="' . $_GET['f'] . '"';
	header("Expires: " . $expires);
	header("Last-Modified: " . $modified);
	header('Referrer-policy: "no-referrer"');
	header("Pragma: cache");
	//	header("Cache-Control: public");
	//	<meta http-equiv="cache-control" content="public" />
	//	<meta http-equiv="last-modified" content="$modified" />
	//	<meta http-equiv="expires" content="$expires" />
	print "
<!DOCTYPE html>
<html lang=\"en\">
<head>
	<title>Index of /$vpath</title>
	<meta charset=\"UTF-8\">
	<meta name=\"description\" content=\"Index of /$vpath\">
";
?>
	<meta name="robots" content="index, nofollow">
	<meta name="referrer" content="no-referrer">
	<meta name="author" content="SliTaz Contributors">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="/static/favicon.ico">
	<link rel="stylesheet" type="text/css" href="/static/slitaz.min.css">
</head>
<body>

<script>de=document.documentElement;de.className+=(("ontouchstart" in de)?' touch':' no-touch');</script>

<header>
	<h1><a href="http://mirror1.slitaz.org/">SliTaz Mirror</a></h1>
	<div class="network">
		<a class="home" href="http://www.slitaz.org/"></a>
		<a href="http://scn.slitaz.org/">Community</a>
		<a href="http://doc.slitaz.org/">Doc</a>
		<a href="http://forum.slitaz.org/">Forum</a>
		<a href="http://bugs.slitaz.org">Bugs</a>
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
		<a href="http://cook.slitaz.org/">Cook</a>
	</div>
</header>

<div class="block"><div>
	<!-- Information/image -->
	<div class="block_info">
		<header>Welcome to Open Source!</header>
<?php

	if (preg_match("/mirror1\.slitaz\./", $_SERVER["SERVER_NAME"]))
		{ ?>
		<p>This is the SliTaz GNU/Linux main mirror. The server runs naturally 
		SliTaz (stable) in a virtual machine provided by 
		<a href="https://www.linkedin.com/company/balinor-technologies/">balinor-technologies</a>
		and is located in France.</p>
		<p><a href="/info/">Mirror info...</a></p>
<?php
	} else { ?>
		<p>This is a SliTaz GNU/Linux mirror. The server is synchronized regularly
		with the <a href="https://mirror1.slitaz.org/">Slitaz main mirror</a>
<?php
	}

	?>
		<form action="/" method="get">
			<input type="search" name="f"/>
		</form>
	</div>
	<!-- Navigation -->
	<nav>
		<header>Online Tools</header>
		<ul>
			<li><a href="http://mypizza.slitaz.org/">Live ISO Builder</a></li>
			<li><a href="http://pizza.slitaz.org/">Live flavor Builder</a></li>
			<li><a href="http://tiny.slitaz.org/">Tiny SliTaz Builder</a></li>
			<li><a href="http://boot.slitaz.org/">Web Boot</a></li>
			<li><a href="http://web.archive.org/web/*/http://mirror.slitaz.org">WebArchive</a></li>
		</ul>
	</nav>
</div></div>

<script>
	function QRCodePNG(str, obj) {
		try {
			obj.height = obj.width += 200;
			return QRCode.generatePNG(str, {ecclevel: 'H'});
		}
		catch (any) {
			var element = document.createElement("script");
			element.src = "/static/qrcode.min.js";
			element.type ="text/javascript"; 
			element.onload = function() {
				obj.src = QRCode.generatePNG(str, {ecclevel: 'H'});
			};
			document.body.appendChild(element);
		}
	}
</script>

<div class="mirrors">
<?php

	// Mirror list
	$mirrors = array();
	$fp = @fopen(dirname($_SERVER["SCRIPT_FILENAME"]) . "/mirrors.html", "r");
	if ($fp) {
		// Parse mirrors.html
		while (($line = fgets($fp)) !== false) {
			// string /" is the end of mirrors url
			$fullline = str_replace('/"', "/" . $vpath . '"', $line);
			print $fullline;
		}
		fclose($fp);
	} else {
		$fp = @fopen(dirname($_SERVER["SCRIPT_FILENAME"]) . "/mirrors", "r");
		if ($fp) {
			while (($line = fgets($fp)) !== false) {
				$line = chop($line);
				$url = parse_url($line);
				if ($_SERVER["SERVER_NAME"] == $url['host'])
					continue;
				$host = explode('.', $url['host']);
				$mirrors[$host[count($host)-2] . "." .
				         $host[count($host)-1]] = $line;
			}
		}
		fclose($fp);
		foreach($mirrors as $name => $url) {
			print "<a href=\"$url$vpath\" title=\"$name mirror\">$name</a>\n";
		}
	}

	print "</div>";
	// end SliTaz Style
} else {
	// not SliTaz Style

	// Print the heading stuff
	print "<?xml version='1.0' encoding='$encoding'?>
<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.1//EN' 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'>
<html xmlns='http://www.w3.org/1999/xhtml' xml:lang='en'>
	<head>
		<title>Index of /$vpath</title>
";
	if ($external_css != '') {
		print "	<link rel='stylesheet' type='text/css' href='$external_css' />";
	} else {
		print "<style type='text/css'>
	a, a:active {text-decoration: none; color: blue;}
	a:visited {color: #48468F;}
	a:hover, a:focus {text-decoration: underline; color: red;}
	body {background-color: #F5F5F5;}
	h2 {margin-bottom: 12px;}
	table {margin-left: 12px;}
	th, td {font: 90% monospace; text-align: left;}
	th {font-weight: bold; padding-right: 14px; padding-bottom: 3px;}
	td {padding-right: 14px;}
	td.s, th.s {text-align: right;}
	div.list {background-color: white; border-top: 1px solid #646464; border-bottom: 1px solid #646464; padding-top: 10px; padding-bottom: 14px;}
	div.foot { font: 90% monospace; color: #787878; padding-top: 4px;}
</style>
";
	}

	print "	</head>
	<body>
		<h2>Index of /$vpath</h2>
";
	// end not SliTaz Style
}




print "<!-- Content -->
<main>
	<div class='list'>
		<div class='lang'>Path: /$vpath</div>
		<table>";


function my_is_file($path) {
	// 2G+ file support
	exec("[ -f '" . $path . "' ]", $tmp, $ret);
	return $ret == 0;
	//return is_file($path);
}


function my_filesize($path) {
	// 2G+ file support
	return rtrim(shell_exec("stat -Lc %s '" . $path . "'"));
	//return filesize($path);
}


function my_filemtime($path) {
	// 2G+ file support
	return rtrim(shell_exec("stat -Lc %Y '" . $path . "'"));
	//return filemtime($path);
}


function my_filemtimeasc($path) {
	// 2G+ file support
	return rtrim(shell_exec("LC_ALL=C date -r '" . $path . "' '+%Y-%b-%d %H:%M:%S'"));
	//return date('Y-M-d H:m:s', filemtime($path));
}


if (filesize($path . "/.folderlist") > 0 &&
	filesize($path . "/.filelist") > 0 &&
	filemtime($path . "/.filelist") > filemtime($path)) {
	$folderlist = unserialize(file_get_contents($path . "/.folderlist"));
	$filelist   = unserialize(file_get_contents($path . "/.filelist"));
} else {

	proc_nice(10);
	// Get all of the folders and files.
	$folderlist = array();
	$filelist = array();
	if($handle = @opendir($path)) {
		while(($item = readdir($handle)) !== false) {
			if ($item == "index.php")			continue;
			if ($item == ".folderlist")			continue;
			if ($item == ".filelist")			continue;
			if ($item == "dir-generator.php")	continue;
			if ($item == "robots.txt")			continue;
			if ($item == "humans.txt")			continue;
			if ($item == "mirrors.html")		continue;
			if (is_dir($path.'/'.$item) and $item != '.' and $item != '..') {
				$folderlist[] = array(
					'name' => $item,
					'size' => 0,
					'modtime'=> filemtime($path . '/' . $item),
					'modtimeasc'=> my_filemtimeasc($path . '/' . $item),
					'file_type' => "Directory"
				);
			} elseif (my_is_file($path . '/' . $item)) {
				if (!$show_hidden_files) {
					if (substr($item, 0, 1) == "." or substr($item, -1) == "~")
						continue;
				}
				$filelist[] = array(
					'name'=> $item,
					'size'=> my_filesize($path . '/' . $item),
					'modtime'=> my_filemtime($path . '/' . $item),
					'modtimeasc'=> my_filemtimeasc($path . '/' . $item),
					'file_type' => get_file_type($path . '/' . $item)
				);
			}
		}
		closedir($handle);
		file_put_contents($path . "/.folderlist", serialize($folderlist), LOCK_EX);
		file_put_contents($path . "/.filelist", serialize($filelist), LOCK_EX);
	}
}

if (isset($_GET['f'])) {
	$filter = $_GET['f'];
	if (substr($filter, 0, 1) != '/')
		$filter = '/' . $filter . '/i';
	foreach ($filelist as $key => $value)
		if (!preg_match($filter, $value['name']))
			unset($filelist[$key]);
	foreach ($folderlist as $key => $value)
		if (!preg_match($filter, $value['name']))
			unset($folderlist[$key]);
}

if (!isset($_GET['s']))
	$_GET['s'] = 'name';


// Figure out what to sort files by
$file_order_by = array();
foreach ($filelist as $key => $row)
	$file_order_by[$key] = $row[$_GET['s']];


// Figure out what to sort folders by
$folder_order_by = array();
foreach ($folderlist as $key => $row)
	$folder_order_by[$key] = $row[$_GET['s']];


// Order the files and folders
$sort_type = SORT_ASC;
$order = "&amp;o=d";
if (isset($_GET['o'])) {
	$sort_type = SORT_DESC;
	$order = "";
}
array_multisort($folder_order_by, $sort_type, $folderlist);
array_multisort($file_order_by,   $sort_type, $filelist);


// Table caption: number of folders and files
print "<caption>" . count($folderlist) . " folders and " . count($filelist) . " files.</caption>";


// Show sort methods
print "<thead><tr>";

$sort_methods = array();
$sort_methods['name'] = "Name";
$sort_methods['modtime'] = "Last Modified";
$sort_methods['size'] = "Size";

foreach($sort_methods as $key => $item) {
	if ($_GET['s'] == $key)
		$key = "$key$order";
	print "<th><a href='?s=$key'>$item</a></th>";
}
print "</tr></thead>\n<tbody>\n";




// Parent directory link
if ($path != "./")
	print "<tr><td class='up'><a href='..'>Parent Directory</a>/</td>" .
		"<td>&nbsp;</td>" .
		"<td>- &nbsp;</td></tr>\n";




// Print folder information
foreach($folderlist as $folder)
	print "<tr><td class='dir'><a href='" . addslashes($folder['name']). "/'>" .
		htmlentities($folder['name']) . "</a>/</td>" .
		"<td>" . $folder['modtimeasc'] . "</td>" .
		"<td>- &nbsp;</td></tr>\n";



// Print file information
foreach($filelist as $file) {
	$filename = $file['name'];
	$url = addslashes($filename);

	if (preg_match('/\.(tazpkg|deb)$/', $filename))
		$class = "pkg";
	elseif (preg_match('/\.iso$/', $filename))
		$class = "iso";
	elseif (preg_match('/\.(exe|com)$/', $filename))
		$class = "exe";
	elseif (preg_match('/^README$/', $filename))
		$class = "rme";
	elseif (preg_match('/^bzImage$/', $filename))
		$class = "krn";
	elseif (preg_match('/\.zip$/', $filename))
		$class = "zip";
	elseif (preg_match('/\.log$/', $filename))
		$class = "log";
	else {
		$classes = explode('/', $file['file_type']);
		$class = $classes[1];
	}


	print "<tr><td class='$class'><a href='$url'>" . htmlentities($filename) . "</a></td>" .
		"<td>" . $file['modtimeasc'] .
		" <img src='/static/qr.png' alt='#' " .
		"onmouseover=\"this.title = location.href+'$url'\" " .
		"onclick=\"this.src = QRCodePNG(location.href+'$url', this)\"/></td>" .
		"<td>" . format_bytes($file['size']) . "</td></tr>\n";
}

// Print ending stuff
print "		</tbody>
	</table>
</div>";

$soft = explode('/', $_SERVER["SERVER_SOFTWARE"]);
$tag = get_conf('server.tag', '"', '"', $soft[0] . ' &lt;' . $soft[1] . '&gt;');


if (filesize($path . "/README"))
	print "<pre>" .
		preg_replace('!(((f|ht)tp(s)?://)[-a-zA-Z()0-9@:%_+.~#?&;//=]+)!i',
			'<a href="$1">$1</a>', file_get_contents($path . "/README")) .
		"</pre>\n";



if ($slitaz_style) {
	// SliTaz Style
?>

<!-- End of content -->
</main>

<footer>
	<div>
		Copyright &copy; <span class="year"></span>
		<a href="http://www.slitaz.org/">SliTaz</a>
	</div>
	<div>
		Network:
		<a href="http://scn.slitaz.org/">Community</a> ·
		<a href="http://doc.slitaz.org/">Doc</a> ·
		<a href="http://forum.slitaz.org/">Forum</a> ·
		<a href="http://pkgs.slitaz.org/">Packages</a> ·
		<a href="http://bugs.slitaz.org">Bugs</a> ·
		<a href="http://hg.slitaz.org/?sort=lastchange">Hg</a>
	</div>
	<div>
		SliTaz @
		<a href="http://twitter.com/slitaz">Twitter</a> ·
		<a href="http://www.facebook.com/slitaz">Facebook</a> ·
		<a href="http://distrowatch.com/slitaz">Distrowatch</a> ·
		<a href="http://en.wikipedia.org/wiki/SliTaz">Wikipedia</a> ·
		<a href="http://flattr.com/profile/slitaz">Flattr</a>
	</div>
	<img src="/static/qr.png" alt="#" onmouseover="this.title = location.href"
	onclick="this.src = QRCodePNG(location.href, this)"/>
</footer>

<?php
	// end SliTaz Style
} else {
	// not SliTaz Style
	print "
	<form action='" . $_SERVER["REQUEST_URI"] . "' method='get'>
		<div class='foot'>" . $tag . "
			<input type='text' name='f'/>
			<!-- <input type='submit' value='Filter' /> -->
		</div>
	</form>
";
	// end not SliTaz Style
}

print "</body>
	</html>";
?>
