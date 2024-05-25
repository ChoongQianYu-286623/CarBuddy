<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$car_id = $_POST['car_id'];
$insuranceName = $_POST['insuranceName'];
$policyNumber = $_POST['policyNumber'];
$startDate = $_POST['startDate'];
$endDate = $_POST['endDate'];
$image = $_POST['image'];

// Extract the year from the startDate
$year = date('Y', strtotime($startDate));

$sqlinsert = "INSERT INTO `tbl_insurance`(`user_id`, `car_id`, `insurance_name`, `policy_number`, `start_date`, `end_date`) VALUES ('$user_id','$car_id','$insuranceName','$policyNumber','$startDate','$endDate')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => $sqlinsert);
    $decoded_string = base64_decode($image);
	$path = '../assets/insurance/' . $userid . '(' . $carid . ')_' . $year . '.png';
    file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
