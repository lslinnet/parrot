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

  # Setup Elastic Search
  # openjdk-7-jre-headless is being required by the solr module.
  # If there is an old left over java6 on the machine remove it.
  package{ 'openjdk-6-jre-headless':
    ensure => absent,
  }

  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '1.5',
    status => enabled,
    require => Package['openjdk-7-jre-headless'],
    config => {
      'cluster.name' => 'elastic',
    }
  }
  elasticsearch::instance { 'elastic': }
  elasticsearch::plugin{'lmenezes/elasticsearch-kopf':
    module_dir => 'kopf',
    instances  => 'elastic'
  }
  elasticsearch::plugin{'elasticsearch/marvel/latest':
    module_dir => 'marvel',
    instances => 'elastic'
  }
  elasticsearch::plugin{'lukas-vlcek/bigdesk':
    module_dir => 'bigdesk',
    instances  => 'elastic'
  }
}
