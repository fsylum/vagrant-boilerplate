# Setup required database and user to connect with WordPress

CREATE DATABASE IF NOT EXISTS `wp`;
GRANT ALL PRIVILEGES ON `wp`.* TO 'wp'@'localhost' IDENTIFIED BY 'password';
