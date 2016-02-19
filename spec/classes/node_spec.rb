require 'spec_helper'

describe 'xylem::node' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default parameters' do
        it { is_expected.to contain_class('xylem::node') }

        it do
          is_expected.to contain_class('xylem::repo')
            .with({'manage' => true, 'source' => 'p16n-seed'})
            .that_comes_before('Package[seed-xylem]')
        end

        it do
          is_expected.to contain_package('seed-xylem')
            .with_ensure('installed')
        end

        it do
          is_expected.to contain_file('/etc/xylem/xylem.yml')
            .with_content(match_yaml({'queues' => nil}))
        end

        it do
          is_expected.to contain_service('xylem')
            .with_ensure('running')
            .that_subscribes_to('File[/etc/xylem/xylem.yml]')
        end
      end

      describe 'when gluster is configured' do
        let(:params) { {:gluster => true} }

        it do
          is_expected.to contain_file('/etc/xylem/xylem.yml')
            .with_content(match_yaml({
                'queues' => [{
                    'name' => 'gluster',
                    'plugin' => 'seed.xylem.gluster',
                    'gluster_mounts' => nil,
                    'gluster_nodes' => nil,
                  }]
              }))
        end

        describe 'with mounts and nodes' do
          let(:params) do
            {
              :gluster => true,
              :gluster_mounts => ['/data/brick1', '/data/brick2'],
              :gluster_nodes => ['gfs1.local', 'gfs2.local'],
            }
          end

          it do
            is_expected.to contain_file('/etc/xylem/xylem.yml')
              .with_content(match_yaml({
                  'queues' => [{
                      'name' => 'gluster',
                      'plugin' => 'seed.xylem.gluster',
                      'gluster_mounts' => ['/data/brick1', '/data/brick2'],
                      'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
                    }]
                }))
          end
        end

        describe 'with all params' do
          let(:params) do
            {
              :gluster => true,
              :gluster_mounts => ['/data/brick1', '/data/brick2'],
              :gluster_nodes => ['gfs1.local', 'gfs2.local'],
              :gluster_replica => 2,
              :gluster_stripe => 3,
            }
          end

          it do
            is_expected.to contain_file('/etc/xylem/xylem.yml')
              .with_content(match_yaml({
                  'queues' => [{
                      'name' => 'gluster',
                      'plugin' => 'seed.xylem.gluster',
                      'gluster_mounts' => ['/data/brick1', '/data/brick2'],
                      'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
                      'gluster_replica' => 2,
                      'gluster_stripe' => 3,
                    }]
                }))
          end
        end
      end

      describe 'when postgres is configured' do
        let(:params) { {:postgres => true} }

        it do
          is_expected.to contain_file('/etc/xylem/xylem.yml')
            .with_content(match_yaml({
                'queues' => [{
                    'name' => 'postgres',
                    'plugin' => 'seed.xylem.postgres',
                    'key' => nil,
                    'servers' => [{
                        'hostname' => nil,
                        'username' => nil,
                      }]
                  }]
              }))
        end

        describe 'with all params' do
          let(:params) do
            {
              :postgres => true,
              :postgres_host => 'db.local',
              :postgres_user => 'pguser',
              :postgres_password => 'pgpass',
              :postgres_secret => 'pgsec',
            }
          end

          it do
            is_expected.to contain_file('/etc/xylem/xylem.yml')
              .with_content(match_yaml({
                  'queues' => [{
                      'name' => 'postgres',
                      'plugin' => 'seed.xylem.postgres',
                      'key' => 'pgsec',
                      'servers' => [{
                          'hostname' => 'db.local',
                          'username' => 'pguser',
                          'password' => 'pgpass',
                        }]
                    }]
                }))
          end
        end
      end

      describe 'when gluster and postgres are configured' do
        let(:params) { {:gluster => true, :postgres => true} }

        it do
          is_expected.to contain_file('/etc/xylem/xylem.yml')
            .with_content(match_yaml({
                'queues' => contain_exactly({
                    'name' => 'gluster',
                    'plugin' => 'seed.xylem.gluster',
                    'gluster_mounts' => nil,
                    'gluster_nodes' => nil,
                  }, {
                    'name' => 'postgres',
                    'plugin' => 'seed.xylem.postgres',
                    'key' => nil,
                    'servers' => [{
                        'hostname' => nil,
                        'username' => nil,
                      }]
                  })
              }))
        end

        describe 'with all params' do
          let(:params) do
            {
              :gluster => true,
              :gluster_mounts => ['/data/brick1', '/data/brick2'],
              :gluster_nodes => ['gfs1.local', 'gfs2.local'],
              :gluster_replica => 2,
              :gluster_stripe => 3,
              :postgres => true,
              :postgres_host => 'db.local',
              :postgres_user => 'pguser',
              :postgres_password => 'pgpass',
              :postgres_secret => 'pgsec',
            }
          end

          it do
            is_expected.to contain_file('/etc/xylem/xylem.yml')
              .with_content(match_yaml({
                  'queues' => contain_exactly({
                      'name' => 'gluster',
                      'plugin' => 'seed.xylem.gluster',
                      'gluster_mounts' => ['/data/brick1', '/data/brick2'],
                      'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
                      'gluster_replica' => 2,
                      'gluster_stripe' => 3,
                    }, {
                      'name' => 'postgres',
                      'plugin' => 'seed.xylem.postgres',
                      'key' => 'pgsec',
                      'servers' => [{
                          'hostname' => 'db.local',
                          'username' => 'pguser',
                          'password' => 'pgpass',
                        }]
                    })
                }))
          end
        end
      end

      describe 'when package_ensure is purged' do
        let(:params) { {:package_ensure => 'purged'} }
        it do
          is_expected.to contain_package('seed-xylem')
            .with_ensure('purged')
        end
      end

      describe 'when repo_manage is false' do
        let(:params) { {:repo_manage => false} }
        it do
          is_expected.not_to contain_class('xylem::repo')
        end
      end
    end
  end
end
