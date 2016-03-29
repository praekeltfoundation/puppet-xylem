# == Class: xylem::config
#
# Provides tools for managing the Xylem config.
#
# === Parameters
#
# [*backend*]
#   Set the rhumba backend to use for job queue
#
# [*redis_host*]
#   Redis host to use when using the redis Rhumba backend
#
# [*redis_port*]
#   Redis port to use when using the redis Rhumba backend
#
class xylem::config (
  $backend           = undef,
  $redis_host        = undef,
  $redis_port        = undef,
){

  concat { '/etc/xylem/xylem.yml':
    mode    => '0644',
  }

  concat::fragment { 'xylem_config_top':
    target  => '/etc/xylem/xylem.yml',
    content => template('xylem/xylem.config.top.erb'),
    order   => '01',
  }
}
