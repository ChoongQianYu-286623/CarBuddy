<?php
// Check if user_id is set in the POST data
if (!isset($_POST['user_id'])) {
    $response = array('status' => 'failed', 'message' => 'user_id is missing in the POST request');
    sendJsonResponse($response);
}

include_once("dbconnect.php");

// Retrieve user_id from POST data
$user_id = $_POST['user_id'];
//$car_id = $_POST['car_id'];

// Prepare and execute SQL query to fetch insurance data for the given user_id and car_id
$sqlloadfuel = "SELECT * FROM `tbl_fuel` WHERE user_id = ?";
$stmt = $conn->prepare($sqlloadfuel);
$stmt->bind_param("i", $user_id); // "ii" indicates that both parameters are integers
$stmt->execute();
$result = $stmt->get_result();
//$sqlloadfuel = "SELECT * FROM `tbl_fuel` WHERE `user_id` = '$user_id'";
//$result = mysqli_query($conn, $sqlloadfuel);


// Check if any fuel data is found
if ($result->num_rows > 0) {
    $fuel = array();
    while ($row = $result->fetch_assoc()) {
        $fuellist = array(
            'car_id' => $row['car_id'],
            'user_id' => $row['user_id'],
            'fuel_date' => $row['fuel_date'],
            'fuel_cost' => $row['fuel_cost'],
            'fuel_volume' => $row['fuel_volume'],
            'fuel_type' => $row['fuel_type'],
			'fuel_mileage' => $row['fuel_mileage'],
            'fuel_company' => $row['fuel_company'],
            'fuel_location' => $row['fuel_location'],
            'fuel_state' => $row['fuel_state']
        );
        array_push($fuel, $fuellist);
    }
    $response = array('status' => 'success', 'data' => $fuel);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'No fuel history found for the car');
    sendJsonResponse($response);
}

// Function to send JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

