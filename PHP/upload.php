<html>
<head>
<?php echo '<meta http-equiv="Refresh" content="1; URL='.$_SERVER['HTTP_REFERER'].'">';?>
<title>��������� �������� �����</title>
</head>
<body style="font-family:sans-serif;font-size:24px">
<?php
if($_FILES["filename"]["size"] > 1024*3*1024)
{
echo ("������ ����� ��������� ��� ���������!");
exit;
}
if(is_uploaded_file($_FILES["filename"]["tmp_name"]))
{
move_uploaded_file($_FILES["filename"]["tmp_name"], "./Download/".$_FILES["filename"]["name"]);
echo("�������� �������� �����!");
} else {
echo("������ �������� �����!");
}
?>
</body>
</html>
