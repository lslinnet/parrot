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

  # Ensure ntp is installed.
  class { ntp:
    ensure     => running,
    autoupdate => true,
  }

  class { 'composer':
    auto_update => true,
    user => 'root',
    command_name => 'composer',
    target_dir   => '/usr/local/bin'
  }
  class { drush: 
    stage => final,
  }

}
