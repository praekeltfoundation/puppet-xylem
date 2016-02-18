# == Class: xylem::docker
#
# Installs the Xylem Docker plugin and configured and manages the service.
#
# === Parameters
#
# [*backend*]
#   The xylem backend host to talk to.
#
# [*package_ensure*]
#   The ensure value for the docker-xylem package.
#
class xylem::docker (
  $backend,
  $package_ensure = 'installed',
) {
  package { 'docker-xylem':
    ensure => $package_ensure,
  }
  ->
  file { '/etc/docker/xylem-plugin.yml':
    ensure  => present,
    content => template('xylem/xylem-plugin.yml.erb'),
    mode    => '0644',
  }
  ~>
  service { 'docker-xylem':
    ensure => running,
  }
}
