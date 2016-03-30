# == Define: xylem::config::marathon_sync
#
# [*group_json_files*]
#   List of paths to JSON files containing Marathon app group definitions.
#
# [*marathon_host*]
#   Host to send Marathon requests to.
#
# [*marathon_port*]
#   Port to send Marathon requests to.
#
class xylem::config::marathon_sync(
  $group_json_files,
  $marathon_host = undef,
  $marathon_port = undef,
) {
  unless is_array($group_json_files) and count($group_json_files) >= 1 {
    fail('group_json_files must be an array with at least one element')
  }

  xylem::config::plugin { 'marathon_sync':
    plugin        => 'seed.xylem.marathon_sync',
    plugin_config => template('xylem/xylem.config.marathon_sync.erb'),
  }
}
