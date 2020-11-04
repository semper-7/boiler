<?
date_default_timezone_set('Asia/Novosibirsk');
 if (strlen($_GET["var"]) == 55) {
 $var = preg_replace('/\+/',' ',$_GET["var"]);
 $r1 = (int) substr($var,-1);
 $m1 = (int) substr(date('i'),-1);
 $ll = file('log.txt');
 $r0 = (int) substr($ll[0],-1);
 $m0 = (int) substr($ll[0],4,1);
  if ($r1 > 3 || $r0 != $r1 || ($m0 != $m1 && ($m1 == 0 || $m1 == 5))) {
  file_put_contents('./Log/'.date('Ymd').'.log', date('H:i ').$var."\r\n", FILE_APPEND);
  }
 file_put_contents('log.txt', date('H:i ').$var);
 $cfg = file('log.cfg');
 echo (date('Hi ').$cfg[0]);
 }
?>
