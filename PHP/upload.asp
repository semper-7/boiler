<html>
<! Copyright (c) Realtek Semiconductor Corp., 2003. All Rights Reserved. ->
<head>
<meta http-equiv="Content-Type" content="text/html">
<title>Firmware Update</title>
<script>
function sendClicked()
{
	if (document.password.binary.value=="") {
		alert('Selected file cannot be empty!');
		document.password.binary.focus();
		return false;
	}
		
	if (!confirm('Do you really want to upgrade the firmware?'))
		return false;
	else
		return true;
}

</script>

</head>
<BODY>
<blockquote>
<h2><font color="#0000FF">Upgrade Firmware</font></h2>
<form action=/goform/admin/formUpload method=POST enctype="multipart/form-data" name="password">
<table border="0" cellspacing="4" width="500">
 <tr><font size=2>
 This page allows you upgrade the ADSL Router firmware to new version. Please note,
 do not power off the device during the upload because it may crash the system.
 </tr>
  <tr><hr size=1 noshade align=top></tr>
  <tr>
      <td width="20%"><font size=2><b>Select File:</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
      <td width="80%"><font size=2><input type="file" name="binary" size=20></td>
  </tr>
  </table>
    <p> <input type="submit" value="Upload" name="send" onclick="return sendClicked()">&nbsp;&nbsp;
	<input type="reset" value="Reset" name="reset">
	<input type="hidden" value="/admin/upload.asp" name="submit-url">
    </p>
 </form>
 </blockquote>
</body>
</html>
