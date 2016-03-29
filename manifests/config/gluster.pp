# == Define: xylem::config::gluster
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
class xylem::config::gluster(
  $gluster_mounts  = undef,
  $gluster_nodes   = undef,
  $gluster_replica = undef,
  $gluster_stripe  = undef,
) {
  unless is_array($gluster_mounts) and count($gluster_mounts) >= 1 {
    fail('gluster_mounts must be an array with at least one element')
  }
  unless is_array($gluster_nodes) and count($gluster_nodes) >= 1 {
    fail('gluster_nodes must be an array with at least one element')
  }

  xylem::config::plugin { 'gluster':
    plugin        => 'seed.xylem.gluster',
    plugin_config => template('xylem/xylem.config.gluster.erb'),
  }
}
