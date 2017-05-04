<?hh
// Simple script to get a random PIN from the SQLite DB

$config = parse_ini_file('lib/hotspot.conf'); // Use absolute path!!!

// Open the database
if(!is_file($config['db_path'])) die('No database');

$db = new SQLite3($config['db_path']);

// Get a random field
$result = $db->querySingle("SELECT * FROM users WHERE used = 0 ORDER BY RANDOM() LIMIT 1;",true);

$id = $result['id'];
$pin = $result['pin'];

if(!empty($pin)) echo $pin;
else die('No more PIN available');

// And update the field as used
$db->exec("UPDATE users SET used = 1 WHERE id = $id");

$db->close();
