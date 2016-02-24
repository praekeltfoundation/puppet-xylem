class xylem::docker($server){
  if ! defined(Apt::Source['seed']) {
    apt::source{'seed':
        location    => 'https://praekeltfoundation.github.io/packages/',
        repos       => 'main',
        release     => inline_template('<%= @lsbdistcodename.downcase %>'),
        key         => 'F996C16C',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false
    }
  }

  file {'/run/docker/plugins':
    ensure => directory,
    mode   => '0755'
  }

  file {'/etc/docker/xylem-plugin.yml':
    ensure  => present,
    content => template('xylem/xylem-plugin.yml.erb'),
    mode    => '0644',
  }

  package {'docker-xylem':
    ensure  => latest,
    require => Apt::Source['seed']
  }

  service {'docker-xylem':
    ensure    => running,
    require   => [
        Package['docker-xylem'],
        File['/run/docker/plugins']
    ],
    subscribe => File['/etc/docker/xylem-plugin.yml'],
  }
}
