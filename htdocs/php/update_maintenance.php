<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userid = $_POST['userid'];
$carid = $_POST['carid'];
$maintenanceid = $_POST['maintenanceid'];
$newDate = $_POST['newDate'];
$newType = $_POST['newType'];
$newWorkshop = $_POST['newWorkshop'];
$newLocation = $_POST['newLocation'];
$newState = $_POST['newState'];

$sqlupdate = "UPDATE `tbl_maintenance` SET `maintenance_date`='$newDate',`maintenance_type`='$newType',`maintenance_workshop`='$newWorkshop',`maintenance_location`='$newLocation',`maintenance_state`='$newState' WHERE `maintenance_id`='$maintenanceid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlupdate);
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