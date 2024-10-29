<?php

// Check if there is a post or not - to safeguarding request
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	die;
}

include_once("dbconnect.php");
$email = $_POST['email']; // post array - to protect the data ub body section better
$password = sha1($_POST['password']); // hashing algorithm - simplest one

$sqllogin = "SELECT `admin_email`, `admin_pass` FROM `tbl_admins` WHERE `admin_email` = '$email' AND `admin_pass` = '$password'";
$result = $conn->query($sqllogin);
if ($result->num_rows > 0){
	$response = array('status' => 'success', 'data' => null);
	sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}



// Build the Json data respon
function sendJsonResponse($sentArray){
	header('Content-Type: application/json');
	echo json_encode($sentArray);
}	

?>