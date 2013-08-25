<?php
$ambulance=$_POST['ambno'];

//$ambulance='KA0EE1284';

//test

$myFile = "testFile4.txt";
$fh = fopen($myFile, 'w') or die("can't open file");
fwrite($fh, $ambulance);
fclose($fh);


//connect to the db
$con = mysql_connect('mysql15.000webhost.com', 'a7548625_deepu','910910deepug');
mysql_select_db('a7548625_folio', $con);
//run the query to search for the username and password the match
//$query = "SELECT * FROM $tbl_name WHERE first_name = '$un' AND password = '$pw'";

$query1 = "SELECT amb_id FROM ambulance WHERE amb_no = '$ambulance'";
$res= mysql_query($query1) or die("Unable to verify user because : " . mysql_error());

if(mysql_num_rows($res) > 0)
{
$row = mysql_fetch_array($res);
	$ambid = $row['amb_id'] ;
  
}
  
//date and time are inserted by sql itself
//changing the state of ambulance from normal to emergency by inserting into emergency table

echo '1';
$query3 = " INSERT INTO log (amb_id ,t_sigid,l_event) VALUES ($ambid,2,'LOGOUT')";
$res1= mysql_query($query3) or die("Unable to logout user because : " . mysql_error());

mysql_close($con);

?>
