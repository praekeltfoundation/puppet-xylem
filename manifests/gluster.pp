# == Class: xylem::gluster
#
# Installs the Xylem glusterfs backend and configures and manages the service.
#
# === Parameters
#
# [*mounts*]
#   List of brick mounts on each glusterfs peer host.
#
# [*nodes*]
#   List of glusterfs peer hosts.
#
# [*replica*]
#   The number of replicas for a replicated volume. If given, it must be an
#   integer greater than or equal to 2 or `false` to disable replication.
#
# [*stripe*]
#   The number of stripes for a striped volume. If given, it must be an integer
#   greater than or equal to 2 or `false` to disable striping.
#
# [*package_ensure*]
#   The ensure value for the seed-xylem package.
#
class xylem::gluster (
  $mounts,
  $peers,
  $replica        = false,
  $stripe         = false,
  $package_ensure = 'installed',
) {

  validate_array($mounts)
  validate_array($peers)

  package { 'seed-xylem':
    ensure  => $package_ensure,
  }
  ->
  file { '/etc/xylem/xylem.yml':
    ensure  => present,
    content => template('xylem/xylem.yml.erb'),
    mode    => '0644',
  }
  ~>
  service { 'xylem':
    ensure => running,
  }
}
