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
#   integer greater than or equal to 2 or `false` to disable replication.
#
# [*gluster_stripe*]
#   The number of stripes for a striped volume. If given, it must be an integer
#   greater than or equal to 2 or `false` to disable striping.
#
# [*postgres*]
#   If `true` xylem will manage postgres databases.
#
# [*postgres_host*]
#   XXX
#
# [*postgres_user*]
#   XXX
#
# [*postgres_password*]
#   XXX
#
# [*postgres_secret*]
#   XXX
#
# [*package_ensure*]
#   The ensure value for the seed-xylem package.
#
class xylem::node (
  $gluster           = false,
  $gluster_mounts    = [],
  $gluster_nodes     = [],
  $gluster_replica   = false,
  $gluster_stripe    = false,

  $postgres          = false,
  $postgres_host     = false,
  $postgres_user     = false,
  $postgres_password = false,
  $postgres_secret   = false,

  $repo_manage       = true,
  $repo_source       = 'p16n-seed',
  $package_ensure    = 'installed',
){
  validate_array($gluster_mounts)
  validate_array($gluster_nodes)
  validate_bool($repo_manage)

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
  file {'/etc/xylem/xylem.yml':
    ensure  => present,
    content => template('xylem/xylem.yml.erb'),
    mode    => '0644',
  }
  ~>
  service {'xylem':
    ensure => running,
  }

  if defined(Class['xylem::repo']) {
    Class['xylem::repo'] -> Package['seed-xylem']
  }
}
