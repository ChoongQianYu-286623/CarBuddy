<?php
// Check if user_id is set in the POST data
if (!isset($_POST['user_id'])) {
    $response = array('status' => 'failed', 'message' => 'user_id is missing in the POST request');
    sendJsonResponse($response);
    exit(); // Terminate script execution
}

include_once("dbconnect.php");

// Retrieve user_id from POST data
$user_id = $_POST['user_id'];

// Execute SQL query to fetch cars for the given user_id
$sqlloadcar = "SELECT * FROM `tbl_cars` WHERE user_id = ?";
$stmt = $conn->prepare($sqlloadcar);
$stmt->bind_param("s", $user_id);
$stmt->execute();
$result = $stmt->get_result();

// Check if any cars are found
if ($result->num_rows > 0) {
    $car = array(); // Initialize array to hold car data
    while ($row = $result->fetch_assoc()) {
        // Add car data to the array
        $carlist = array(
            'car_id' => $row['car_id'],
            'user_id' => $row['user_id'],
            'car_name' => $row['car_name'],
            'car_model' => $row['car_model'],
            'car_manufacturer' => $row['car_manufacturer'],
            'car_year' => $row['car_year'],
            'car_type' => $row['car_type'],
            'car_fuelType' => $row['car_fuelType'],
            'car_tank' => $row['car_tank']
        );
        $car[] = $carlist;
    }
    $response = array('status' => 'success', 'data' => $car);
} else {
    $response = array('status' => 'failed', 'message' => 'No cars found for the user');
}

// Send JSON response
sendJsonResponse($response);

// Function to send JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>