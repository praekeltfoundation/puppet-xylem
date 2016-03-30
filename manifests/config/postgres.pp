# == Define: xylem::config::postgres
#
# [*postgres_host*]
#   Host to create databases on.
#
# [*postgres_user*]
#   User to create databases with.
#
# [*postgres_secret*]
#   Secret key for storing generated credentials.
#
# [*postgres_password*]
#   Optional password for postgres user.
#
class xylem::config::postgres(
  $postgres_host,
  $postgres_user,
  $postgres_secret,
  $postgres_password = undef,
) {
  if $postgres_host == undef { fail('postgres_host must be provided') }
  if $postgres_user == undef { fail('postgres_user must be provided') }
  if $postgres_secret == undef { fail('postgres_secret must be provided') }

  xylem::config::plugin { 'postgres':
    plugin        => 'seed.xylem.postgres',
    plugin_config => template('xylem/xylem.config.postgres.erb'),
  }
}
