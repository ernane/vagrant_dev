class rails ($username = 'vagrant',  $rubyversion = '2.1.1') {

    $home_dir    = "/home/${username}"

    rbenv::install { $username:
        group => $username,
        user  => $username,
        home  => $home_dir,
    }

    file { "/home/vagrant/.gemrc":
        ensure  => file,
        replace => false,
        owner   => "vagrant",
        group   => "vagrant",
        source  => "puppet:///modules/rails/gemrc"
    }

    file { "/home/vagrant/.pryrc":
        ensure  => file,
        replace => false,
        owner   => "vagrant",
        group   => "vagrant",
        source  => "puppet:///modules/rails/pryrc"
    }

    file { "/home/vagrant/.irbrc":
        ensure  => file,
        replace => false,
        owner   => "vagrant",
        group   => "vagrant",
        source  => "puppet:///modules/rails/irbrc"
    }

    rbenv::plugin {
        'rbenv-gem-rehash':
            group  => $username,
            user   => $username,
            source => 'git://github.com/sstephenson/rbenv-gem-rehash.git';

        'rbenv-vars':
            group  => $username,
            user   => $username,
            source => 'git://github.com/sstephenson/rbenv-vars.git';

        'rbenv-each':
            group  => $username,
            user   => $username,
            source => 'git://github.com/chriseppstein/rbenv-each.git';

        'rbenv-update':
            group  => $username,
            user   => $username,
            source => 'git://github.com/rkh/rbenv-update.git';

        'rbenv-whatis':
            group  => $username,
            user   => $username,
            source => 'git://github.com/rkh/rbenv-whatis.git';

        'rbenv-use':
            group  => $username,
            user   => $username,
            source => 'git://github.com/rkh/rbenv-use.git';

        'rbenv-default-gems':
            group  => $username,
            user   => $username,
            source => 'git://github.com/sstephenson/rbenv-default-gems.git';
    }

    rbenv::compile { $rubyversion:
        group  => $username,
        user   => $username,
        home   => $home_dir,
        global => true
    }

    rbenv::gem { ['specific_install', 'pry-meta', 'bundle']:
        ensure  => latest,
        user    => $username,
        ruby    => $rubyversion,
        require => Rbenv::Compile[$rubyversion],
    }
}
