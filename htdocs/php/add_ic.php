<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$image1 = $_POST['image1'];
$image2 = $_POST['image2'];

$decoded_string1 = base64_decode($image1);
$decoded_string2 = base64_decode($image2);
$path1 = '../assets/license/'.$user_id.'front.png';
$path2 = '../assets/license/'.$user_id.'back.png';
if ((file_put_contents($path1, $decoded_string1)) !== false && (file_put_contents($path2, $decoded_string2)) !== false) {
    // File was successfully written
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    // Failed to write the file
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
