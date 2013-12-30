node mysql{
  include mysql
}

node postgresql {

  class {'postgresql::globals':
    version             => '9.3',
    manage_package_repo => true,
    encoding            => 'UTF8',
    locale              => 'it_IT.utf8',
  }->

  class { 'postgresql::server':
    ensure           => 'present',
    listen_addresses => '*',
    ipv4acls         => ['host all vagrant 0.0.0.0/0 md5'],
    manage_firewall  => true,
  }->
  postgresql::server::role { 'vagrant':
    createdb      => true,
    login         => true,
    superuser     => true,
    password_hash => postgresql_password("vagrant", "vagrant"),
  }

  # Install contrib modules
  class { 'postgresql::server::contrib':
    package_ensure => 'present',
  }
}

node oracle {
  include oracle::server
  include oracle::swap
  include oracle::xe

  user { "vagrant":
    groups  => "dba",
    require => Service["oracle-xe"],
  }
}

node ruby {
  Exec {
          path => ["/usr/bin", "/bin", "/usr/sbin", "/sbin", "/usr/local/bin", "/usr/local/sbin"]
      }

  # Ensure we are up to date
  exec { "apt-get update":
    command => "apt-get update",
  }

  # Common packages"
  $commonPackages = ["curl", "build-essential", "libxml2", "libxml2-dev", "libxslt1-dev", "python-software-properties", "vim"]
      package { $commonPackages:
        ensure => latest,
        require => Exec['apt-get update'],
  }

  # packages
  $packages = ["tklib", "zlib1g-dev", "libreadline-gplv2-dev", "libssl-dev", "nodejs"]
    package { $packages:
      ensure => latest,
      require => Exec['apt-get update'],
  }

  # RMagick system dependencies
  package { ['libmagickwand4', 'libmagickwand-dev', 'imagemagick', 'libmagickcore-dev']:
      ensure => installed,
      require => Exec['apt-get update'],
  }

  # DB
  package { ['sqlite3', 'libsqlite3-dev', 'mysql-client', 'libmysqlclient15-dev', 'libpq-dev']:
      ensure => installed,
      require => Exec['apt-get update'],
  }

  # Install git
  package { "git":
      ensure  => latest,
      require => Exec['apt-get update']
  }

  # Set the configuration
  file { "/home/vagrant/.gitconfig":
      ensure  => file,
      replace => false,
      owner   => "vagrant",
      group   => "vagrant",
      source  => "puppet:///modules/git/gitconfig"
  }

  include zsh, rails

}
