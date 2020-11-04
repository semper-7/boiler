<?
date_default_timezone_set('Asia/Novosibirsk');
 if (strlen($_GET["var"]) == 2) {
 $cfg = file('log.cfg');
 echo $cfg[0];
 }
?>
