<?php
foreach (array("confirm", "cancel", "show") as $action) {
	if (!isset($_GET[$action]))
		continue;
	$hash = $_GET[$action];
	if ($hash == "")
		continue;
	$data = unserialize(file_get_contents("pending/".
		substr($hash,0,1)."/".$hash));
	if (!isset($data))
		continue;
	if ($action == "confirm") {
		@mkdir("confirmed/".substr($hash,0,1),0777,TRUE);
		rename("pending/".substr($hash,0,1)."/".$hash,
			"confirmed/".substr($hash,0,1)."/".$hash);
	}
	if ($action == "cancel") {
		unlink("pending/".substr($hash,0,1)."/".$hash);
	}
	include("head.php");
	echo "<div id=\"content\">\n";
	echo "<h2>SliTaz USB key pre-order ".$action."ed.</h2>\n<p><table>\n";
	foreach ($data as $key => $value) 
		echo "<tr><td>".$key."</td><td><b>".$value."</b></td></tr>\n"; 
	echo "</table></p>\n";
	echo "</div>\n";
	include("tail.php");
	exit;
}

foreach (explode(",", $_SERVER["HTTP_ACCEPT_LANGUAGE"]) as $lang) {
	foreach (array(';',' ','-') as $char) {
		if (($n = strpos($lang, $char)) !== false)
			$lang = substr($lang,0,$n);
	}
	if (is_dir($lang)) break;
	$lang = "en"; 
}
header("Location: $lang/");
?>
