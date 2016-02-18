# == Class: xylem
#
# Installs Xylem from a PPA and adds an Upstart definition.
#
# === Parameters
#
# [*package_ensure*]
#   The ensure value for the Xylem package.
#
# [*repo_manage*]
#   Whether or not to manage the repository for Xylem.
#
# [*repo_source*]
#   The repo source to use. Current valid values: 'p16n-seed'.
#
class xylem (
  $package_ensure  = 'installed',
  $repo_manage     = true,
  $repo_source     = 'p16n-seed',
) {
  validate_bool($repo_manage)

  class { 'xylem::repo':
    manage => $repo_manage,
    source => $repo_source,
  }
  ->
  package { 'seed-xylem':
    ensure  => $package_ensure,
  }
  # ->
  # file { '/etc/init/xylem.conf':
  #   content => template('xylem/init.conf.erb'),
  # }
  # ~>
  # service { 'xylem':
  #   ensure => running,
  # }
}
