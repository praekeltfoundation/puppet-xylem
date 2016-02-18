class xylem::docker($server){

    apt::source{'seed':
        location    => 'https://praekeltfoundation.github.io/packages/',
        repos       => 'main',
        release     => inline_template('<%= @lsbdistcodename.downcase %>'),
        key_source  => 'https://praekeltfoundation.github.io/packages/conf/seed.gpg.key',
        include_src => false
    }

    file {'/run/docker/plugins':
        ensure   => directory,
        mode     => 0755
    }

    file {'/etc/docker/xylem-plugin.yml':
        ensure   => present,
        content  => template('xylem/xylem-plugin.yml.erb'),
        mode     => 0644, 
    }

    package {'docker-xylem':
        ensure => latest,
        require => Apt::Source['seed']
    }

    service {'docker-xylem':
        ensure      => running,
        require     => [
            Package['docker-xylem'],
            File['/run/docker/plugins']
        ],
        subscribe   => File['/etc/docker/xylem-plugin.yml'],
    }
}
