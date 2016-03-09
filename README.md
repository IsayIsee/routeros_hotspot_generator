# The Ultimate Hotspot PIN generator for RouterOS

There is a simple script writen in PHP to generate PINs to connect a Hotspot, using RouterOS using the routeros-api by **Denis Basta**: https://github.com/BenMenking/routeros-api/blob/master/routeros_api.class.php

## The script consist in two parts
* The Backend: PHP script for console that generate random PINs, store into a SQLite DB and add them as Hotspot username into the RouterOS. This is intended to be executed daily using a cronjob
* The Frontend: PHP script (either for www and console) that queries to the DB and outputs a random PIN from it

## Hotspot setup

* First, be sure to have connectivity between your manager machine and the device running RouterOS and add a strong password to the RouterOS admin account
* Create a Hotspot and set at least one profile for the clients
* Edit the HTML files by renaming the **Username** description field as **PIN** and remove the field **Password**
* Test by adding one user without password and connect

## RouterOS Scripts setup

Create a new User Script in the RouterOS with the following (assuming that the Hotspot profile is called "Clients"):

/ip hotspot user remove [find profile=Clients];
/ip hotspot active remove [find];

## PHP Scripts setup

* Copy **index.php** to your webserver
* Copy **lib** anywhere outside the www access and be sure to be writable by the Webserver user
* Edit **index.php** and set the **lib** path
* Edit **lib/manage.sh** and:
 * Set the PHP/cli path shebang if necessary
 * Set the IP, User and Password of your RouterBoard admin account
 * Set the Hotspot users according to your needs (100 should be enough)
 * Set the Hotspot Server and Profile that you used in the Hotspot setup
