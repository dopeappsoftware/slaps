<?php
ini_set('display_errors',1);
ini_set('display_startup_errors',1);
error_reporting(-1);

include './database.php';
include './unverifiedRequest.php';

$method = isset($_POST['method']) ? $_POST['method'] : 'error';

$databaseConnection = new databaseConnection();
$database = $databaseConnection->getDatabase();

switch ($method) {
	case 'validateEmail':
		$server = new unverifiedRequest($database);
		$server->validateEmail($_POST['email']);
		break;
 
	case 'validateUsername':
		$server = new unverifiedRequest($database);
		$server->validateUsername($_POST['username']);
		break; 

	case 'validatePhone':
		$server = new unverifiedRequest($database);
		$server->validatePhone($_POST['phone'], 'maxwellckellogg@gmail.com');
		break; 
	
	case 'login':
		$server = new unverifiedRequest($database);
		$server->login($_POST['token']);
		break; 
	
	case 'createAccount':
		$server = new unverifiedRequest($database);
		//error checking on variables
		$server->createAccount($_POST['token'], $_POST['username'], $_POST['email'], $_POST['phone'], $_POST['deviceID']);
		break; 
	
	case 'error':
		echo '{"success":0,"message":"Method Specification Empty"}';
		break; 

	default:
		echo '{"success":0,"message":"Method Specification Empty"}';
		
}
?>
