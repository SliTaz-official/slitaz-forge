<?php
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
