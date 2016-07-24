# Vagrant Boilerplate

This is a personal Vagrant setup that I use for each project that I manage. It's basic LEMP stack on Ubuntu 14.04 with a few additions such as Composer, Node.js and WP-CLI ready at the get-go.

## Why another boilerplate?

[VVV](https://github.com/Varying-Vagrant-Vagrants/VVV) is a fantastic Vagrant setup, where much of the provisioning of this setup is based on. However, VVV provides lot of things out of the box which I don't necessarily require in my development workflow, plus it is catered more on WordPress development. On the other hand, I would only need a simple LEMP stack, that also works well on my Windows machine.

## Requirement

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)
* [Vagrant::Hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)

_Note: Vagrant::Hostsupdater is optional to automatically add the entry to the hosts file. If you skip that, you will need to manually edit the hosts file and add the related entry yourself._

## Usage

```
git clone https://github.com/fsylum/vagrant-boilerplate <project-name>
cd <project-name>
vagrant up
```

All Vagrant commands like `vagrant halt`, `vagrant destroy` and `vagrant suspend` is applicable.

## Credentials

MySQL root:

**User**: `root`
**Password**: `password`

Additional MySQL access:

**User**: `wp`
**Password**: `password`
**Database**: `wp`

## What's Included?

* [Ubuntu 14.04](http://www.ubuntu.com/)
* [nginx (mainline)](http://nginx.org/)
* [php-fpm 7.0.x](http://php-fpm.org/)
* [MySQL 5.5.x](https://www.mysql.com/)
* [phpMyAdmin](https://www.phpmyadmin.net/)
* [Git](https://git-scm.com/)
* [Subversion](https://subversion.apache.org/)
* [Composer](https://getcomposer.org/)
* [Node.js](https://nodejs.org/)
* [WP-CLI](http://wp-cli.org/)
* [MailHog](https://github.com/mailhog/MailHog)

## Directory Structure

* `config` - Contains all services related configuration, please modify it accordingly to your usage.
* `logs` - Contains all the logs generated from nginx as well as PHP errors.
* `www` - The web root of your web application.

## Credits

[VVV](https://github.com/Varying-Vagrant-Vagrants/VVV) team for an awesome Vagrant setup.
