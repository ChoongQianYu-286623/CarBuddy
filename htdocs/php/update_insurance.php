<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$carid = $_POST['carid'];
$newName = $_POST['newName'];
$newNumber = $_POST['newNumber'];
$newStartDate = $_POST['newStartDate'];
$newEndDate = $_POST['newEndDate'];
$image = $_POST['image'];

$year = date('Y', strtotime($newStartDate));

$sqlupdate = "UPDATE `tbl_insurance` SET `insurance_name`='$newName',`policy_number`='$newNumber',`start_date`='$newStartDate',`end_date`='$newEndDate' WHERE `car_id` = '$carid'";

if ($conn->query($sqlupdate) === TRUE) {
	//$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => $sqlupdate);
	$decoded_string = base64_decode($image);
	$path = '../assets/insurance/' . $userid . '(' . $carid . ')_' . $year . '.png';
	file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
} //update

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>