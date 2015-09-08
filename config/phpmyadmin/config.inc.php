<?php
/**
 * Debian local configuration file
 *
 * This file overrides the settings made by phpMyAdmin interactive setup
 * utility.
 *
 * For example configuration see
 *   /usr/share/doc/phpmyadmin/examples/config.sample.inc.php
 * or
 *   /usr/share/doc/phpmyadmin/examples/config.manyhosts.inc.php
 *
 * NOTE: do not add security sensitive data to this file (like passwords)
 * unless you really know what you're doing. If you do, any user that can
 * run PHP or CGI on your webserver will be able to read them. If you still
 * want to do this, make sure to properly secure the access to this file
 * (also on the filesystem level).
 */

if (!function_exists('check_file_access')) {
	function check_file_access($path)
	{
	    if (is_readable($path)) {
		return true;
	    } else {
		error_log(
		    'phpmyadmin: Failed to load ' . $path
		    . ' Check group www-data has read access and open_basedir restrictions.'
		);
		return false;
	    }
	}
}

// Load secret generated on postinst
if (check_file_access('/var/lib/phpmyadmin/blowfish_secret.inc.php')) {
    require('/var/lib/phpmyadmin/blowfish_secret.inc.php');
}

// Load autoconf local config
if (check_file_access('/var/lib/phpmyadmin/config.inc.php')) {
    require('/var/lib/phpmyadmin/config.inc.php');
}

/**
 * Server(s) configuration
 */
$i = 0;
$i++;

// The $cfg['Servers'] array starts with $cfg['Servers'][1].  Do not use $cfg['Servers'][0].
// You can disable a server config entry by setting host to ''.
/* Authentication type */
$cfg['Servers'][$i]['auth_type']       = 'cookie';
$cfg['Servers'][$i]['host']            = 'localhost';
$cfg['Servers'][$i]['connect_type']    = 'tcp';
$cfg['Servers'][$i]['compress']        = false;
$cfg['Servers'][$i]['extension']       = 'mysqli';
$cfg['Servers'][$i]['AllowNoPassword'] = TRUE;

/*
 * End of servers configuration
 */

/*
 * Directories for saving/loading files from server
 */
$cfg['UploadDir'] = '';
$cfg['SaveDir']   = '';

/* Support additional configurations */
foreach (glob('/etc/phpmyadmin/conf.d/*.php') as $filename)
{
    include($filename);
}
