# The Ultimate standalone Hotspot PIN generator for RouterOS

There is a simple script writen in PHP to generate PINs to connect a Hotspot, using RouterOS using the routeros-api by **Denis Basta**: https://github.com/BenMenking/routeros-api/blob/master/routeros_api.class.php without using User Manager.

An Appliance with Tiny Core Linux ready-to-use (after proper configuration) is included on OVA format (VMWare) configured with Bridged network device, as the PIN generator server. (You still need your device with RouterOS).

## The script consist in two parts

* The Backend: PHP script for console that generate random PINs, store into a SQLite DB and add them as Hotspot username into the RouterOS. This is intended to be executed daily using a cronjob. This can be easily ported to other languages using the other languages available at https://wiki.mikrotik.com/wiki/Manual:API

* The Frontend: PHP script (either for www and console) that queries to the DB and outputs a random PIN from it. This can also be ported to any other language that support SQLite.

## Requiriments

* php 5.5 or above (both cli and cgi/fpm/apache_mod)

## Setup

### Router setup

* Set a strong password for your admin account

* Create (and upload) a SSL certificate to allow login with SSL (not mandatory but recommended)

* Create a Bridge interface and add the interfaces intended to be used for the Hotspot

* Edit the Hotspot HTML files by renaming the **Username** description field as **PIN** and set the **Password** field as hidden (**don't** remove it!)

### Hotspot setup (using Winbox)

* Go to IP > Hotspot, and,

	* In Server tab, Create a Hotspot using the "Hotspot Setup" wizard. Check for the Profile and select the Profile (found at Server Profiles tab) set during the Hotspot Setup.
	
	* In Server Profiles tab open the Profile created during the Hotspot Setup, go to Login tab, and in Login By, enable only HTTP CHAP (enable HTTPS if you installed an SSL cert).

	* In the User Profile tab, 
		* Create a new User Profile using the Name difined in "manage.sh",
		* Select the Address Pool created during the Hotspot Setup (usually 'hs-pool-6'),
		* Set the Rate Limit (in bytes) according to your needs
		* Set the Session Timeout as you like (usually 00:30:00)
		* Set the Idle Timeout and Keepalive Timeout with the same value set for the Session Timeout,
		* Disable Add MAC Cookie,
		* In Open Status page select HTTP Login.

### RouterOS Scripts/Schedule setup

* Create the following User Scripts (set uptime according to the value set in "manage.sh"):

/system script add name=remove-active-clients source="ip hotspot user remove [find where uptime>=00:30:00];"

/system script add name=remove-clients source="/ip hotspot active remove [find]; /ip hotspot user remove [find profile=Clients];"

* Create a Scheduled Task called remove-clients (set start-time according to the end of the working day):

/system scheduler add name=remove-clients on-event=remove-clients start-time=21:00:00 interval=24h;

### Server setup

Everything is available in the Appliance, you just need to edit **index.php** and **lib/manage.sh**. If you want to install manually:

* Copy "index.php" to your webserver.

* Copy "lib" anywhere outside the www access and be sure to be writable by the Webserver user, but inaccessible form the web.

* Edit "index.php" and set the "lib" path if necessary. Is highly recommended to set it to the canonicalized absolute path.

* Edit "lib/manage.sh" and:

	* Set the PHP/cli path shebang if necessary.

	* Set the IP, User and Password for your RouterOS admin account.

	* Set $hotspot_server (string) as the Hotspot name created during the Hotspot Setup (usually 'hotspot1').
	
	* Set $hotspot_profile (string) as the name defined during the creation of the User profile (usually 'uprof1').
	
	* Set $hotspot_users according (integer) to the ammount of users who will connect during the Working Day (1000 by default)

Once the Router and Server configuration is done, you may set up the Scheduler (cron) to run the script every a certain time.
 
## License

* The scripts included in this project are licensed under the BSD 3-Clause License.
* The Appliance included in appliance/tiny_core uses Tiny Core Linux. The contents are licensed under several licenses, including the GNU General Public License (for Tiny Core Linux and other packages), the PHP License (for PHP5), and other licenses.
* The license for the routeros_api.class.php by Denis Basta is never disclosed. Asumming the distribution with this software is right
