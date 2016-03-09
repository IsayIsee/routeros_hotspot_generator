<?php

// Simple script to get a random PIN from the SQLite DB

define('LIB_PATH','lib'); // Absolute path. Leave this directory outside the www access!

// Open the database
$db = new SQLite3(LIB_PATH.'/users.db');

// Get a random field
$result = $db->querySingle("SELECT * FROM users WHERE used = 0 ORDER BY RANDOM() LIMIT 1;",true);

// Output the PIN
echo $result['pin'];

// And update the field as used
$db->exec('UPDATE users SET used = 1 WHERE id = '. $result['id'] . ';');

?>