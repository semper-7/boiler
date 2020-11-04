<html>
<head>
<title>Download files</title>
</head>
<body style="font-family:sans-serif;font-size:16px;">
<table border="1" cellspacing="0" bgcolor="#dddddd">
<tr><th>Filename</th><th>Filesize</th></tr>
<?php $files = './Download/*.*' ?>
<?php foreach (glob($files) as $file): ?>
<tr><td><?php echo '<a href="'.$file.'">'.basename($file).'</a>'?></td><td><?php echo filesize($file)?></td></tr>
<?php endforeach ?>
</table>
<br>
<p><b> Upload files</b></p>
<form action="upload.php" method="post" enctype="multipart/form-data">
<input type="file" name="filename"><br><br>
<input type="submit" value="Upload"><br>
</form>
</body>
</html>
