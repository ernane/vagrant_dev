# Class: nginx_proxy
#
#
class nginx_proxy {
  Exec {
    path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
  }

  exec { "update-inicial":
    command => "apt-get update"
  }

  exec { "apt-key":
    command => "apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ABF5BD827BD9BF62",
    unless  => "service nginx status",
    require => Exec["update-inicial"],
  }

  exec { "precise-nginx":
    command => "echo 'deb http://nginx.org/packages/ubuntu/ precise nginx' >> /etc/apt/sources.list",
    unless  => "service nginx status",
    require => Exec["apt-key"],
  }

  exec { "update-nginx":
    command => "apt-get update",
    require => Exec["precise-nginx"],
  }

  if ! defined(Package['nginx']) {
    package { 'nginx':
      ensure  => 'present',
      require => Exec["update-nginx"],
    }
  }

  service { 'nginx':
    enable  => 'true',
    ensure  => 'running',
    require => Package['nginx'],
  }

}
