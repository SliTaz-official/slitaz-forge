<?php
$i = 1;
for ($i = 1; isset($argv[$i]); $i++) {
	$hash = basename($argv[$i]);
	$data = file_get_contents($argv[$i]);
	$_POST = unserialize($data);

system(dirname($_SERVER["SCRIPT_FILENAME"])."/helper.sh '".
	  $_POST['email']."' '".$_POST['surname']."' '".$_POST['size'].
	  "' ".$hash);
}
?>
