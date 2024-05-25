<?php
if (!isset($_POST) ) {
    $response = array('status' => 'failed', 'message' => 'user_id or car_id is missing in the POST request');
    sendJsonResponse($response); 
}

include_once("dbconnect.php");

$user_id = $_POST['user_id'];
$car_id = $_POST['car_id'];


$sqlloadmaintenance = "SELECT * FROM `tbl_maintenance` WHERE `car_id` = '$car_id'";
$result = mysqli_query($conn, $sqlloadmaintenance);

if ($result === false) {
    $response = array('status' => 'failed', 'message' => 'Error executing SQL query: ' . mysqli_error($conn));
    sendJsonResponse($response);
}

    if ($result->num_rows > 0) {
        $maintenance = array(); 
        while ($row = $result->fetch_assoc()) {
            $maintenancelist = array(
                'car_id' => $row['car_id'],
                'user_id' => $row['user_id'],
				'maintenance_id' => $row['maintenance_id'],
                'maintenance_date' => $row['maintenance_date'],
                'maintenance_type' => $row['maintenance_type'],
                'maintenance_workshop' => $row['maintenance_workshop'],
                'maintenance_location' => $row['maintenance_location'],
                'maintenance_state' => $row['maintenance_state'],
            );
            $maintenance[] = $maintenancelist;
        }
        
        // Construct response with maintenance data
        $response = array('status' => 'success', 'data' => $maintenance);
    } else {
        // Construct response when no records are found
        $response = array('status' => 'failed', 'message' => 'No maintenance records found for the specified user and car');
    }


// Send JSON response
sendJsonResponse($response);

// Function to send JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>
