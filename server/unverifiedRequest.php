<?php

class unverifiedRequest {

	private $database;

	public function __construct($database) {
		$this->database = $database;
	}



	public function validateEmail($email) {
		if ($statement = $this->database->prepare("SELECT token FROM users WHERE email LIKE ?")) {
			$statement->bind_param("s", $email);
			$statement->execute();
			$statement->bind_result($result);

			$statement->fetch();
			$statement->close();
		}
		if ($result)
			echo '{"success":0,"message":"E-Mail ALready Registered"}';
		else
			echo '{"success":1,"message":"Unique E-Mail"}';

		return $result;
	}

	public function validateUsername($username) {
		if ($statement = $this->database->prepare("SELECT token FROM users WHERE username LIKE ?")) {
			$statement->bind_param("s", $username);
			$statement->execute();
			$statement->bind_result($result);

			$statement->fetch();
			$statement->close();
		}

		if ($result)
			echo '{"success":0,"message":"Username Already Taken"}';
		else
			echo '{"success":1,"message":"Unique Username"}';

		return $result;
	}

	public function validatePhone($phone, $TEMP_EMAIL) {

		if ($statement = $this->database->prepare("SELECT token FROM users WHERE phone LIKE ?")) {
			$statement->bind_param("s", $phone);
			$statement->execute();
			$statement->bind_result($result);

			$statement->fetch();
			$statement->close();
		}

		if ($result)
			echo '{"success":0,"message":"Phone Number Already In Use"}';
		else {

			$code = mt_rand(1,9);
			$codeSize = 4;

			for ($i = 0; $i < $codeSize - 1; $i++) {
				$code .= mt_rand(0,9);
			}

			//$TEMP_EMAIL = 'maxwellckellogg@gmail.com';	
			if (mail($TEMP_EMAIL, 'confirmation code', "Your confirmation code is $code. Enter this number in the app to activate account.")) {
				echo "{\"success\":1,\"code\":$code,\"message\":\"Unique Phone Number\"}";
			}
			else
				echo '{"success":0,"message":"Error Sending Confirmation E-Mail"}';

		}
		return $result;
	}

	public function login($token) {
		if ($statement = $this->database->prepare('SELECT token FROM users WHERE token = ?')) {
			$statement->bind_param("s", $token);
			$statement->execute();
			$statement->bind_result($result);

			$statement->fetch();
			$statement->close();
		}

		if ($result) {
			$query = "UPDATE users SET lastLogin = ? WHERE token = ?";
			if ($statement = $this->database->prepare($query)) {
				$time = time();
				$statement->bind_param("si", $time, $result);
				$statement->execute();

				$statement->close();
				echo '{"success":1,"message":"Login Succesful"}';
			}

		}
		else {
			echo '{"success":0,"message":"Username/Password Does Not Exist"}';
		}
		return $result;
	}

	public function createAccount($token, $username, $email, $phone, $deviceID) {
		if ($statement = $this->database->prepare("INSERT INTO users(token, username, email, phone, deviceID, creationDate, lastLogin) VALUES (?, ?, ?, ?, ?, ?, ?)")) {
			$time = time();
			$zero = 0;
			$statement->bind_param("sssssii", $token, $username, $email, $phone, $deviceID, $time, $zero);
			$statement->execute();

			//$statement->fetch();

			if (!$statement->error)
				echo '{"success":1,"message":"Account Creation Succesful"}';
				//code to invalidate phone number if found by different user
			else 
				echo '{"success":0,"message":"Database Error: ' . $statement->error  . '"}';

			$statement->close();

		}
		else 
			echo '{"success":0,"message":"Account Was Not Created"}';
	}
}
?>
