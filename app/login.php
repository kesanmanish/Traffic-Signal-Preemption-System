<?php
//$user='KA06EE1284';
//$pwd='amb001';
$user=$_POST['username'];
$pwd=$_POST['pass1'];

//test

$myFile = "testFile.txt";
$fh = fopen($myFile, 'w') or die("can't open file");
fwrite($fh, $user);
fwrite($fh, $pwd);
fclose($fh);

//connect to the db
$con = mysql_connect('mysql15.000webhost.com', 'a7548625_deepu','910910deepug');
mysql_select_db('a7548625_folio', $con);
//run the query to search for the username and password the match
//$query = "SELECT * FROM $tbl_name WHERE first_name = '$un' AND password = '$pw'";

$query = "SELECT amb_id FROM ambulance WHERE amb_no = '$user' AND amb_pwd = '$pwd'";

$result = mysql_query($query) or die("Unable to verify user because : " . mysql_error());
if(mysql_num_rows($result) > 0)
{
$row = mysql_fetch_array($result);
	$ambid = $row['amb_id'] ;
  
}
//this is where the actual verification happens
if(mysql_num_rows($result) > 0)
{
	echo mysql_result($result,0);  // for correct login response
  $query2 = " INSERT INTO log (amb_id ,t_sigid,l_event) VALUES ($ambid,2,'LOGIN')";
$res1= mysql_query($query2) or die("Unable to verify user because : " . mysql_error());

 
 }
 else
echo 0; // for incorrect login response
mysql_close($con);
?>
