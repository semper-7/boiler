<?
$lines = file('./Log/20181029.log');
$cnt = count($lines);
 for ($i = 0; $i < $cnt; $i++) {
 $t[$i][] = explode(" ", $lines[$i]);
 }
/*
function ImageColor($im, $color_array) {
 return ImageColorAllocate( $im,
 isset($color_array['r']) ? $color_array['r'] : 0, 
 isset($color_array['g']) ? $color_array['g'] : 0, 
 isset($color_array['b']) ? $color_array['b'] : 0 
 );
}
$im = @ImageCreate (720, 200) 
  or die ("Cannot Initialize new GD image stream");
$bgcolor = ImageColor($im, array('r'=>255, 'g'=>255, 'b'=>255)); 
$color = ImageColor($im, array('b'=>175)); 
$green = ImageColor($im, array('g'=>175)); 
$gray = ImageColor($im, array('r'=>175, 'g'=>175, 'b'=>175)); 


$j=1
$x2=0
$y2=$t[0][$j] * 2

 for($i = 0; $i < $cnt; $i++) {
 $x1 = $x2;
 $x2 = (substr($t[$i][0],0,2) * 30) + (substr($t[$i][0],3,2) / 2);
 $y1 = $y2;
 $y2 = $t[$i][$j] * 2;
 ImageLine($im, $x1, $y1, $x2, $y2, $color);
 }
*/

header("Content-Type: image/png");
$im = @imagecreate(720, 200) or die('Error GDI');
$background_color = imagecolorallocate($im, 240, 240, 240);
$color = imagecolorallocate($im, 233, 14, 91);
//imagettftext($im, 20, 0, 50, 50, $color, 'arial.ttf', 'GRAPH');
imageline($im, 20,20,700,180, $color);
$j=1;
$x2=0;
$y2=$t[0][$j] * 2;
 for($i = 0; $i < $cnt; $i++) {
 $x1 = $x2;
 $x2 = (substr($t[$i][0],0,2) * 30) + (substr($t[$i][0],3,2) / 2);
 $y1 = $y2;
 $y2 = $t[$i][$j] * 2;
 imageline($im, $x1, $y1, $x2, $y2, $color);
 }
imagepng($im);
imagedestroy($im);
?>
