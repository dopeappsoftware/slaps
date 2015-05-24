<?php

class serverRequest {

	private $database;
	private $DID;
	private $email;
	private $username;
	private $password;
	private $phnum;	

	private $userID;

	public function __construct($database, $DID, $email) {
		$this->database = $database;
		$this->DID = $DID;
		$this->email = $email;

		if ($statement = $database->prepare("SELECT ID FROM users WHERE DID = ? and email = ?")) {
			$statement->bind_param("ss", $this->DID, $this->email);
			$statement->execute();
			$statement->bind_result($this->userID);

			$statement->fetch();
			$statement->close();
		}
	}

	public function validateDevice() {
		if ($this->userID)
			echo '{"success":1,"message":"Unique User"}';
		else
			echo '{"success":0,"message":"Invalid Device ID/E-Mail"}';
	}

	public function validateUsername($username) {
		$this->username = $username;

		if ($statement = $database->prepare("SELECT username FROM users WHERE username = ?")) {
			$statement->bind_param("s", $this->username);
			$statement->execute();
			$statement->bind_result($this->verifiedUsername);

			$statement->fetch();
			$statement->close();
		}

		if (!$this->verifiedUsername)
			echo '{"success":0,"message":"Username Already Taken"}';
		else
			echo '{"success":1,"message":"Username Available"}';
			
	}

	public function createAccount() {// all variables
		
	}
}

/*
$method = $_POST["method"];

if ($method == "validateDevice") {
	$DID = $_POST["DID"];
	$email = $_POST["email"];
	if ($statement = $db->prepare("SELECT DID FROM users WHERE DID = ?")){
		$statement->bind_param("s", $DID);
		$statement->execute();
		$statement->bind_result($r_DID);

		$statement->fetch();

		if ($statement = $db->prepare("SELECT email FROM users WHERE email = ?")){
			$statement->bind_param("s", $email);
			$statement->execute();
			$statement->bind_result($r_email);

			$statement->fetch();
			$statement->close();

			if ($r_DID)
				echo '{"success":0,"message":"That Device ID already exists for a user in the database"}';
			if ($r_email)
				echo '{"success":0,"message":"That email already exists for a user in the database"}';
			else
				echo '{"success":1,"message":"DID/email combo does not exist"}';

		}
		else
			echo '{"success":0,"errorMessage":"Database Error"}';
	}
	else if ($method == "validateUsername"){
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
	else if ($method == "createUser"){
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
	else {
		echo '{"success":0,"errorMessage":"Invalid Method Specified"}';
	}

	?>
*/
?>
