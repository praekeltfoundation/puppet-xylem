class xylem::node (
    $backend='rhumba.backends.redis',
    $redis_host='127.0.0.1',
    $redis_port=6379,
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
      key         => 'F996C16C',
      key_server  => 'keyserver.ubuntu.com',
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
