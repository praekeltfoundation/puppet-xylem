# == Class: xylem::repo
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
          location    => 'https://praekeltfoundation.github.io/packages/',
          repos       => 'main',
          release     => inline_template('<%= @lsbdistcodename.downcase %>'),
          key         => 'F996C16C',
          key_server  => 'keyserver.ubuntu.com',
          include_src => false,
        }

        # apt::source{ 'p16n-seed':
        #   location => "${urlbase}/packages/",
        #   repos    => 'main',
        #   release  => inline_template('<%= @lsbdistcodename.downcase %>'),
        #   key      => {
        #     id     => '864DC0AA3139DFA3C332B9527EAFC9B3F996C16C',
        #     source => "${urlbase}/packages/conf/seed.gpg.key",
        #   },
        # }

        # Ensure apt-get update runs as part of this class
        contain 'apt::update'
      }
      default: {
        fail("APT repository '${source}' is not supported.")
      }
    }
  }
}
