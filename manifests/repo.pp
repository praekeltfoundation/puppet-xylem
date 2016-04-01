# == Class: xylem::repo
#
# Manages the repository containing xylem packages.
#
# === Parameters
#
# [*manage*]
#   If true, the repo will be managed.
#
# [*source*]
#   Name of repo source to use. Valid values: p16n-seed
#
class xylem::repo (
  $manage = true,
  $source = 'p16n-seed',
) {
  if $manage {
    case $source {
      'p16n-seed': {
        include apt

        $urlbase = 'https://praekeltfoundation.github.io'

        apt::source{ 'p16n-seed':
          location => 'https://praekeltfoundation.github.io/packages/',
          repos    => 'main',
          release  => inline_template('<%= @lsbdistcodename.downcase %>'),
          include  => {
            src => false,
          },
          key      => {
            id     => '864DC0AA3139DFA3C332B9527EAFC9B3F996C16C',
            server => 'keyserver.ubuntu.com',
          },
        }

        # Ensure apt-get update runs as part of this class
        contain 'apt::update'
      }
      default: {
        fail("APT repository '${source}' is not supported.")
      }
    }
  }
}
