<?
date_default_timezone_set('Asia/Novosibirsk');
 if (strlen($_GET["var"]) == 55) {
 $var = preg_replace('/\+/',' ',$_GET["var"]);
 file_put_contents('./Log/'.date('Ymd').'.log', date('H:i ').$var."\r\n", FILE_APPEND);
 $cfg = file('log.cfg');
 echo (date('Hi ').$cfg[0]);
 }
?>
