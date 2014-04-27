# CREATE USER 'vagrant'@'%' IDENTIFIED BY 'password';
# GRANT ALL PRIVILEGES ON *.* TO 'vagrant'@'%' WITH GRANT OPTION;

class mysql_server {
  $root_password = 'root'

  $bin = '/usr/bin:/usr/sbin'

  exec { "apt-update":
    command => "/usr/bin/apt-get update"
  }

  if ! defined(Package['mysql-server']) {
    package { ['mysql-server']:
      ensure  => latest,
      require => Exec["apt-update"],
    }
  }

  package { 'libmysqlclient15-dev':
      ensure => installed,
      require => Package['mysql-server']
  }

  if ! defined(Package['mysql-client']) {
    package { 'mysql-client':
      ensure  => 'present',
      require => Exec["apt-update"],
    }
  }

  service { 'mysql':
    alias   => 'mysql::mysql',
    enable  => 'true',
    ensure  => 'running',
    require => Package['mysql-server'],
  }

  # Override default MySQL settings.
  file { '/etc/mysql/my.cnf':
    owner   => 'mysql',
    group   => 'mysql',
    source  => 'puppet:///modules/mysql/my.cnf',
    notify  => Service['mysql::mysql'],
    require => Package['mysql-server'],
  }

  # Set the root password.
  exec { 'mysql::set_root_password':
    unless  => "mysqladmin -uroot -p${root_password} status",
    command => "mysqladmin -uroot password ${root_password}",
    path    => $bin,
    require => Service['mysql::mysql'],
  }
}
