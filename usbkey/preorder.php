<?php
include("./head.php");

echo '<div id="content">';
$data = serialize($_POST);
$hash = md5($data);
@mkdir("pending/".substr($hash,0,1),0777,TRUE);
$fp = fopen("pending/".substr($hash,0,1)."/".$hash, "w");
fwrite($fp,$data);
fclose($fp);

system(dirname($_SERVER["SCRIPT_FILENAME"])."/helper.sh '".
	  $_POST['email']."' '".$_POST['surname']."' '".$_POST['size'].
	  "' ".$hash);
echo "Thanks ".$_POST['surname'].".<br>\nAn email has been send to ".$_POST['email'].".";
echo '</div>';
include("./tail.php");
?>
