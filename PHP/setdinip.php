<?php
 file_put_contents('ip.txt', $_SERVER['REMOTE_ADDR']);
 echo (file_get_contents('ip.txt'))
?>
