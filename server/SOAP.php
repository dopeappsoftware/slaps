<?php
ini_set('display_errors',1);
ini_set('display_startup_errors',1);
error_reporting(-1);

include './database.php';
include './methods.php';
echo 'got to soap<br>'; 

$databaseConnection = new databaseConnection();
$database = $databaseConnection->getDatabase();
var_dump($database);
echo '<br><br>';
$server = new serverRequest($database, $_GET['username'], $_GET['password']);
var_dump($server);
echo '<br><br>';

$server->validateDevice();
?>
