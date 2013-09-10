# Class: memcached
#
# Install, enable and configure memcached.
#
# Parameters:
#  $other:
#    Optional other. Default: none
#
# Sample Usage :
#  include memcached
#
class memcached (
  $port      = '11211',
  $user      = 'nobody',
  $maxconn   = '1024',
  $cachesize = '512',
  $options   = ''
) {

  package { 'memcached': ensure => installed }

  service { 'memcached':
    enable    => true,
    ensure    => running,
    hasstatus => true,
    require   => Package['memcached'],
  }

  # Configuration
  file { '/etc/memcached.conf':
    content => template('memcached/memcached.conf.erb'),
    notify  => Service['memcached'],
    require => Package['memcached'],
  }

}

