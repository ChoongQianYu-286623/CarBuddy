<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$newname = $_POST['newname'];
$newic = $_POST['newic'];
$newemail = $_POST['newemail'];
$newphone = $_POST['newphone'];
//$image = $_POST['image'];

$sqlupdate = "UPDATE `tbl_users` SET `user_name`='$newname',`user_email`='$newemail',`user_ic`='$newic',`user_phone`='$newphone'WHERE `user_id` = '$user_id'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlupdate);
	//$decoded_string = base64_decode($image);
	//$path = '../assets/profile_picture/'.$user_id.'.png';
	//file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
} //update(name,email,phone,ic)

if (isset($_POST['oldpass'])) {
    $oldpass = sha1($_POST['oldpass']);
    $newpass = sha1($_POST['newpass']);
    $userid = $_POST['userid'];
    $sqllogin = "SELECT * FROM `tbl_users` WHERE user_id = '$userid' AND user_password = '$oldpass'";
	
    $result = $conn->query($sqllogin);
    if ($result->num_rows > 0) {
    	$sqlupdate2 = "UPDATE `tbl_users` SET user_password ='$newpass' WHERE user_id = '$userid'";
            if ($conn->query($sqlupdate2) === TRUE) {
                $response = array('status' => 'success', 'data' => null);
                sendJsonResponse($response);
            } else {
                $response = array('status' => 'failed', 'data' => null);
                sendJsonResponse($response);
            }
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    } 
} //update(password)

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>