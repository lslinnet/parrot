node default {

  stage { 'final':
    require => Stage['main'],
  }

  class {apt: }
  class { parrot_repos: }
  class { solr_server:  }
  class { parrot_mysql:  }
  class { parrot_php:  }
  class { memcached: }
  class { oh_my_zsh:  }
  class { sudoers: }
  class { 'http_stack::without_varnish': }
  class { mailcollect: }

  package { 'vim': }
  package { 'vim-puppet': }
  package { 'curl': }
  package { 'subversion': }
  package { 'unzip': }
  package { 'htop': }

  # Ensure ntp is installed.
  class { ntp:
    ensure     => running,
    autoupdate => true,
  }

  file { "/home/vagrant/bin":
    ensure => directory,
    owner => "vagrant",
  }

  class { 'composer':
    auto_update => true,
    user => 'vagrant',
    command_name => 'composer',
    target_dir   => '/home/vagrant/bin',
  }
  class { drush: 
    stage => final,
  }

}
