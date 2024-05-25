<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$car_id = $_POST['car_id'];
$date = $_POST['date'];
$serviceType = $_POST['serviceType'];
$workshop = $_POST['workshop'];
$location = $_POST['location'];
$state = $_POST['state'];

$sqlinsert = "INSERT INTO `tbl_maintenance`(`user_id`, `car_id`, `maintenance_date`, `maintenance_type`, `maintenance_workshop`, `maintenance_location`, `maintenance_state`) VALUES ('$user_id','$car_id','$date','$serviceType','$workshop','$location','$state')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlinsert);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>