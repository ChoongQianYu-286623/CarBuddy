<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$name = $_POST['name'];
$model = $_POST['model'];
$manufacturer = $_POST['manufacturer'];
$year = $_POST['year'];
$type = $_POST['type'];
$fuel = $_POST['fuel'];
$tank = $_POST['tank'];

$image = $_POST['image'];

$sqlinsert = "INSERT INTO `tbl_cars`(`user_id`,`car_name`, `car_model`, `car_manufacturer`, `car_year`, `car_type`, `car_fuelType`, `car_tank`) VALUES ('$user_id','$name','$model','$manufacturer','$year','$type','$fuel','$tank')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => $sqlinsert);
	$decoded_string = base64_decode($image);
	$path = '../assets/cars/'.$filename.'.png';
	file_put_contents($path, $decoded_string);
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