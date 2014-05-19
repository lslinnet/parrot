class drush () {
  exec {"install-drush":
    command => "/home/vagrant/bin/composer global require drush/drush:6.*",
    creates => "/home/vagrant/.composer/vendor/drush",
    user => "vagrant",
  }

  exec {"add-composer-to-bashrc":
    path => '/bin/',
    command => 'echo \'export PATH="/home/vagrant/.composer/vendor/bin:$PATH"\' >> /home/vagrant/.bashrc',
    unless => 'grep -q \'composer\' /home/vagrant/.bashrc',
  }

  file {"/usr/local/bin/drush":
    ensure => link,
    target => '/home/vagrant/.composer/vendor/bin/drush'
  }
}
