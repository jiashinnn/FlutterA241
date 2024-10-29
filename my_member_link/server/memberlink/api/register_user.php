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

$email = $conn->real_escape_string($_POST['email']);
$password = sha1($conn->real_escape_string($_POST['password']));
$salt = substr(md5(mt_rand()), 0.7);
$secure_password = $password . $salt;
$hashed_password = password_hash($secure_password, PASSWORD_DEFAULT);

$sqlinsert = "INSERT INTO `tbl_admins`( `admin_email`, `admin_pass`, 'admin_salt') VALUES ('$email','$hashed_password', '$salt')";

if ($conn->query($sqlinsert) === TRUE){
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