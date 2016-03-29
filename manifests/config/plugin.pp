# == Define: xylem::config::plugin
#
define xylem::config::plugin($plugin, $plugin_config) {
  concat::fragment { "xylem_config_plugin_${name}":
    target  => '/etc/xylem/xylem.yml',
    content => template('xylem/xylem.config.queue.erb'),
    order   => '02',
  }
}
