class drush () {
  exec {"install-drush":
    command => "/usr/local/bin/composer global require drush/drush:6.*",
    creates => "/home/vagrant/.composer/vendor/drush",
    user => 'vagrant',
  }

  exec {"add-composer-to-bashrc":
    path => '/bin/',
    command => 'echo \'export PATH="/home/vagrant/.composer/vendor/bin:$PATH"\' >> /home/vagrant/.bashrc',
    unless => 'grep -q \'composer\' /home/vagrant/.bashrc',
    user => 'vagrant',
  }
}