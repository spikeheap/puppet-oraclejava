class oraclejava( $ensure = 'present' ) {

  # Only support Ubuntu at the moment
  if $operatingsystem == 'Ubuntu'{
    include apt
    apt::ppa { 'ppa:webupd8team/java': }
    
    # TODO replace this with a responsefile call.
    exec {
      'accept_java7_license':
      command => "echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections",
      path => "/usr/bin/:/bin/",
      logoutput => true,
    }
    
    package {'oracle-java7-installer':
      ensure => $ensure,
      #responsefile => 'puppet:///workstation/files/oraclejavaresponsefile.txt'
    }
    
    package {'oracle-java7-set-default':
      ensure => $ensure,
    }
    
    Apt::Ppa['ppa:webupd8team/java'] -> Exec['accept_java7_license'] -> Package['oracle-java7-installer'] -> Package['oracle-java7-set-default']
    
  }
}