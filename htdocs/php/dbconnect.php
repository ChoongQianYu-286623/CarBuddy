<?php
$servername = "localhost";
$username   = "id22184484_carbuddyadmin";
$password   = "carBuddy@123";
$dbname		= "id22184484_carbuddy_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

?>