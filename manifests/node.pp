# == Class: xylem::node
#
# Installs the Xylem glusterfs backend and configures and manages the service.
#
# === Parameters
#
# [*gluster*]
#   If `true` xylem will manage glusterfs volumes on this node.
#
# [*gluster_mounts*]
#   List of brick mounts on each glusterfs peer host.
#
# [*gluster_nodes*]
#   List of glusterfs peer hosts.
#
# [*gluster_replica*]
#   The number of replicas for a replicated volume. If given, it must be an
#   integer greater than or equal to 2.
#
# [*gluster_stripe*]
#   The number of stripes for a striped volume. If given, it must be an integer
#   greater than or equal to 2.
#
# [*postgres*]
#   If `true` xylem will manage postgres databases.
#
# [*postgres_host*]
#   Host to create databases on.
#
# [*postgres_user*]
#   User to create databases with.
#
# [*postgres_password*]
#   Optional password for postgres user.
#
# [*postgres_secret*]
#   Secret key for storing generated credentials.
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
class xylem::node (
  $gluster           = false,
  $gluster_mounts    = undef,
  $gluster_nodes     = undef,
  $gluster_replica   = undef,
  $gluster_stripe    = undef,

  $postgres          = false,
  $postgres_host     = undef,
  $postgres_user     = undef,
  $postgres_password = undef,
  $postgres_secret   = undef,

  $backend           = undef,
  $redis_host        = undef,
  $redis_port        = undef,

  $repo_manage       = true,
  $repo_source       = 'p16n-seed',
  $package_ensure    = 'installed',
){
  validate_bool($gluster)
  validate_bool($postgres)

  if $gluster {
    class { 'xylem::config::gluster':
      gluster_mounts  => $gluster_mounts,
      gluster_nodes   => $gluster_nodes,
      gluster_replica => $gluster_replica,
      gluster_stripe  => $gluster_stripe,
    }
  }

  if $postgres {
    class { 'xylem::config::postgres':
      postgres_host     => $postgres_host,
      postgres_user     => $postgres_user,
      postgres_password => $postgres_password,
      postgres_secret   => $postgres_secret,
    }
  }

  class { 'xylem::service':
    backend        => $backend,
    redis_host     => $redis_host,
    redis_port     => $redis_port,
    repo_manage    => $repo_manage,
    repo_source    => $repo_source,
    package_ensure => $package_ensure,
  }
}
