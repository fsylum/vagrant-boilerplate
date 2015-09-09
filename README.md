Simple Vagrant setup for LEMP development environment.

[VVV](https://github.com/Varying-Vagrant-Vagrants/VVV) is a fantastic Vagrant setup, where much of the provisioning of this setup is based on. However, VVV provides lot of things out of the box which I don't necessarily require in my development workflow, plus is catered more on WordPress development. On the other hand, I would only need a simple LEMP stack, that also works well on my Windows machine. Strictly for my personal use only, please use with caution.

## Requirement

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)

## Usage

```
git clone https://github.com/fsylum/vagrant-base project-name
cd project-name
vagrant up
```

Basic Vagrant commands like `vagrant halt`, `vagrant destroy` and `vagrant suspend` is applicable.

## What's Included

* [nginx](http://nginx.org/)
* [php5-fpm](http://php-fpm.org/)
* [MySQL](https://www.mysql.com/)
* [phpMyAdmin](https://www.phpmyadmin.net/)
* [Git](https://git-scm.com/)
* [Composer](https://getcomposer.org/)
* [Node.js](https://nodejs.org/)


## Directory Structure

* `config` - Contains all services related configuration, please modify it accordingly to your usage.
* `logs` - Contains all the logs generated from nginx as well as PHP errors.
* `provision` - Hold the provision scripts, including the WordPress specific provisioning,
* `www` - The web root of your web application.

## Credits

[VVV](https://github.com/Varying-Vagrant-Vagrants/VVV) team for an awesome Vagrant setup.
