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
$car_id = $_POST['car_id'];

// Prepare and execute SQL query to fetch insurance data for the given user_id and car_id
$sqlloadinsurance = "SELECT * FROM `tbl_insurance` WHERE user_id = ? AND car_id = ?";
$stmt = $conn->prepare($sqlloadinsurance);
$stmt->bind_param("ii", $user_id, $car_id); // "ii" indicates that both parameters are integers
$stmt->execute();
$result = $stmt->get_result();


// Check if any insurance data is found
if ($result->num_rows > 0) {
    $insurance = array();
    while ($row = $result->fetch_assoc()) {
        $insurancelist = array(
            'car_id' => $row['car_id'],
            'user_id' => $row['user_id'],
            'insurance_name' => $row['insurance_name'],
            'policy_number' => $row['policy_number'],
            'start_date' => $row['start_date'],
            'end_date' => $row['end_date']
        );
        array_push($insurance, $insurancelist);
    }
    $response = array('status' => 'success', 'data' => $insurance);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'message' => 'No insurance data found for the user');
    sendJsonResponse($response);
}

// Function to send JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

