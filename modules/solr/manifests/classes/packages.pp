class solr::packages {
  package { "tomcat6":
    ensure => present,
  }

  package { "java":
    ensure => present,
    name => $operatingsystem ? {
      'Centos' => $operatingsystemrelease ? {
        '6.0' => "java-1.7.0-openjdk.$hardwaremodel",
         '*' => 'openjdk-7-jre',
      },
      'Debian' => 'openjdk-7-jre-headless',
      'Ubuntu' => 'openjdk-7-jre-headless',
    },
  }
}
