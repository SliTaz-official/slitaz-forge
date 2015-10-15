<?php
if (false) {
?>
<html><body>
<script type="text/javascript">
<!--
var lang=["fr","pt","ru"]
for (var l in lang)
	if(navigator.language.indexOf(lang[l])>-1)
		document.URL=lang[l]+"/index.html";
document.URL="en/index.html";
//-->
</script>
</body></html>
<?php
}
else {
foreach (explode(",", $_SERVER["HTTP_ACCEPT_LANGUAGE"]) as $lang) {
	foreach (array(';',' ','-') as $char) {
		if (($n = strpos($lang, $char)) !== false)
			$lang = substr($lang,0,$n);
	}
	if (is_dir($lang)) break;
	$lang = "en"; 
}
header("Location: $lang/index.html");
}
?>
