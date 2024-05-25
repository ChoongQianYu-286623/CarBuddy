<?php
if (!isset($_POST['carid'])) {
    $response = array('status' => 'failed', 'message' => 'carid is missing in the POST request');
    sendJsonResponse($response);
}

include_once("dbconnect.php");

$car_id = $_POST['carid'];

// Combine multiple DELETE queries into a single multi-query statement
$sqldelete = "
  DELETE FROM `tbl_cars` WHERE `car_id` = '$car_id';
";


if ($conn->query($sqldelete) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
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
