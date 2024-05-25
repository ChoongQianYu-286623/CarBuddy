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
$cost = $_POST['cost'];
$volume = $_POST['volume'];
$type = $_POST['type'];
$mileage = $_POST['mileage'];
$company = $_POST['company'];
$location = $_POST['location'];
$state = $_POST['state'];

$sqlinsert = "INSERT INTO `tbl_fuel`(`user_id`, `car_id`, `fuel_date`, `fuel_cost`, `fuel_volume`, `fuel_type`, `fuel_mileage`, `fuel_company`, `fuel_location`, `fuel_state`) VALUES ('$user_id','$car_id','$date','$cost','$volume','$type','$mileage','$company','$location','$state')";


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