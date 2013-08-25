
<?php

$ambulance=$_POST['ambno'];
$lati=$_POST['latitude'];
$longi=$_POST['longitude'];
$dir=$_POST['bearing'];
$speed=$_POST['speed'];

//$ambulance='KA06EE1284';
//$lati='12.11111';
//$longi='13.22222';

//test

$myFile = "testFile_update.txt";
$fh = fopen($myFile, 'w') or die("can't open file");
fwrite($fh, $ambulance);
fwrite($fh, $lati);
fwrite($fh, $longi);
fclose($fh);


//connect to the db
$con = mysql_connect('mysql15.000webhost.com', 'a7548625_deepu','910910deepug');
mysql_select_db('a7548625_folio', $con);

$query1 = "SELECT amb_id FROM ambulance WHERE amb_no = '$ambulance'";
$res= mysql_query($query1) or die("Unable to verify user because : " . mysql_error());

if(mysql_num_rows($res) > 0)
{
$row = mysql_fetch_array($res);
	$ambid = $row['amb_id'] ;
  
}


$query2 = " UPDATE emergency SET e_latitude=$lati,e_longitude=$longi,e_dir=$dir,e_speed=$speed WHERE amb_id=$ambid ";
$res1= mysql_query($query2) or die("Unable to verify user because : " . mysql_error());
echo $res1;

mysql_close($con);

?>
