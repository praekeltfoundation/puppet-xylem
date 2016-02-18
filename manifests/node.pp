class xylem::node (
    $gluster=false,
    $gluster_mounts=[],
    $gluster_nodes=[],
    $gluster_replica=false,
    $gluster_stripe=false,
    $postgres=false,
    $postgres_host=false,
    $postgres_user=false,
    $postgres_password=false,
    $postgres_secret=false
  ){

  if ! defined(Apt::Source['seed']) {
    apt::source{'seed':
      location    => 'https://praekeltfoundation.github.io/packages/',
      repos       => 'main',
      release     => inline_template('<%= @lsbdistcodename.downcase %>'),
      key_source  => 'https://praekeltfoundation.github.io/packages/conf/seed.gpg.key',
      include_src => false
    }
  }

  file {'/etc/xylem/xylem.yml':
    ensure  => present,
    content => template('xylem/xylem.yml.erb'),
    mode    => '0644',
  }

  package {'seed-xylem':
    ensure  => latest,
    require => Apt::Source['seed']
  }

  service {'xylem':
    ensure    => running,
    require   => Package['seed-xylem'],
    subscribe => File['/etc/xylem/xylem.yml'],
  }
}
