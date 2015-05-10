<?php
$db = new mysqli('127.0.0.1', 'root', 'max&max9293', 'slaps');
if($db->connect_errno > 0){
	die('Unable to connect to database [' . $db->connect_error . ']');
}

$method = $_POST["method"];

if ($method == "createUser"){
	$username = $_POST["username"];
	$password = $_POST["password"];
	$phnum = $_POST["phnum"];

	if (empty($username))
		echo '{"success":0,"errorMessage":"Empty Username"}';
	if (empty($password))
		echo '{"success":0,"errorMessage":"Empty Password"}';
	if (empty($phnum))
		echo '{"success":0,"errorMessage":"Empty Phone Number"}';

	if ($statement = $db->prepare("SELECT username FROM users WHERE username = ? and password = ?")){
		$statement->bind_param("ss", $username, $password);
		$statement->execute();
		$statement->bind_result($r_username);

		$statement->fetch();
		$statement->close();
		if (!$r_username){
			$statement = $db->prepare("INSERT INTO users(username, password, phnum) VALUES (?, ?, ?)");
			$statement->bind_param('sss', $username, $password, $phnum);
			$statement->execute();
			echo '{"success":1}';
		}
		else
			echo '{"success":0,"errorMessage":"User Already Exists"}';
	}

	echo $result;
}
else if ($method == "validateUser"){
	$username = $_POST["username"];
        $password = $_POST["password"];
	if ($statement = $db->prepare("SELECT username FROM users WHERE username = ? and password = ?")){
		$statement->bind_param("ss", $username, $password);
		$statement->execute();
		$statement->bind_result($r_username);

		$statement->fetch();
		$statement->close();

		if ($r_username)
			echo '{"success":1}';
		else
			echo '{"success":0,"errorMessage":"Invalid Username/Password"}';

	}
	else
		echo '{"success":0,"errorMessage":"Database Error"}';

}
else {
	echo '{"success":0,"errorMessage":"Invalid Method Specified"}';
}

?>
