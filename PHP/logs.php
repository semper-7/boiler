<html>
<head>
<title>Log files archiv</title>
</head>
<body style="font-family:sans-serif;font-size:16px;">
<table border="1" cellspacing="0" bgcolor="#EEE">
<tr><th>Filename</th><th>Filesize</th></tr>
<? $files = './Log/*.*' ?>
<? foreach (glob($files) as $file): ?>
<tr><td><?php echo '<a href="'.$file.'">'.basename($file).'</a>'?></td><td><?php echo filesize($file)?></td></tr>
<? endforeach ?>
</table>
</body>
</html>
