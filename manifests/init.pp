# == Class: xylem
#
# Installs Xylem and configures and manages the service.
#
# === Parameters
#
# [*repo_manage*]
#   If true, xylem::repo will be used to manage the package repository.
#
# [*repo_source*]
#   Repository source passed to xylem::repo.
#
# [*package_ensure*]
#   The ensure value for the seed-xylem package.
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
class xylem (
  $backend           = undef,
  $redis_host        = undef,
  $redis_port        = undef,

  $repo_manage       = true,
  $repo_source       = 'p16n-seed',
  $package_ensure    = 'installed',
){
  validate_bool($repo_manage)

  class { 'xylem::config':
    backend    => $backend,
    redis_host => $redis_host,
    redis_port => $redis_port,
  }

  if $repo_manage {
    class { 'xylem::repo':
      manage => $repo_manage,
      source => $repo_source,
    }
  }

  package { 'seed-xylem':
    ensure => $package_ensure,
  }
  ->
  Concat['/etc/xylem/xylem.yml']
  ~>
  service {'xylem':
    ensure => running,
  }

  if defined(Class['xylem::repo']) {
    Class['xylem::repo'] -> Package['seed-xylem']
  }
}
