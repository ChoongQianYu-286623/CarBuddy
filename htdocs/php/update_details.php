<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$carid = $_POST['carid'];
$newname = $_POST['newname'];
$newmodel = $_POST['newmodel'];
$newmanufacturer = $_POST['newmanufacturer'];
$newyear = $_POST['newyear'];
$newtype = $_POST['newtype'];
$newfueltype = $_POST['newfueltype'];
$newtank = $_POST['newtank'];
//$image = $_POST['image'];

$sqlupdate = "UPDATE `tbl_cars` SET `car_name`='$newname',`car_model`='$newmodel',`car_manufacturer`='$newmanufacturer',`car_year`='$newyear',`car_type`='$newtype',`car_fuelType`='$newfueltype',`car_tank`='$newtank' WHERE `car_id`='$carid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlupdate);
	//$decoded_string = base64_decode($image);
	//$path = '../assets/profile_picture/'.$user_id.'.png';
	//file_put_contents($path, $decoded_string);
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