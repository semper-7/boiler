<html>
<head>
<title>Log file <?echo date('Y.m.d')?></title>
<meta HTTP-EQUIV="Refresh" CONTENT="15">
</head>
<body style="font-family:Courier New;font-size:12px;">
<body>
<a name="bof"></a>
<pre><a href="#eof">End of file</a>				<a href="logs.php">View archive logs</a>
<?
$lines = file('./Log/'.$_GET["log"].'.log');
 for ($i = 0; $i < count($lines); $i++) {
 echo $lines[$i];
 }
?>
<a href="#bof">Begin of file</a>				<a href="logs.php">View archive logs</a>
<a name="eof"></a></pre>
</body>
</html>
