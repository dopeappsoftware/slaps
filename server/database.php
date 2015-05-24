<?php

class databaseConnection {

	private $database = 'Error';

	public function __construct() {
		if (!(include './config/database.conf.php'))
			exit('Error. No database config file.');
		if (empty($DATABASE_CONF['host']))
			exit('Error. No host specified in config file.');
		if (empty($DATABASE_CONF['user']))
			exit('Error. No user specified in config file.');
		if (empty($DATABASE_CONF['password']))
			exit('Error. No password specified in config file.');
		if (empty($DATABASE_CONF['database']))
			exit('Error. No database specified in config file.');

		$this->database = new mysqli($DATABASE_CONF['host'], $DATABASE_CONF['user'], $DATABASE_CONF['password'], $DATABASE_CONF['database']);

		if ($this->database->connect_errno > 0)
			exit('Unable to connect to database [' . $database->connect_error . ']');
	}

	public function getDatabase() {
		return $this->database;
	}
}

?>
