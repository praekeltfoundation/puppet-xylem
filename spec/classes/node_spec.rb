require 'spec_helper'

describe 'xylem::node' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      before(:each) do
        @redis_params = {
          :redis_host => 'redis.foo',
          :redis_port => 1234,
          :backend => 'awesome.backend'
        }
        @gluster_params = {
          :gluster => true,
          :gluster_mounts => ['/data/brick1', '/data/brick2'],
          :gluster_nodes => ['gfs1.local', 'gfs2.local'],
        }
        @postgres_params = {
          :postgres => true,
          :postgres_host => 'db.local',
          :postgres_user => 'pguser',
          :postgres_secret => 'pgsec',
        }
      end

      describe 'with default parameters' do
        it { is_expected.to contain_class('xylem::node') }

        it do
          is_expected.to contain_class('xylem').only_with(
            'name' => 'Xylem',
            'repo_manage' => true,
            'repo_source' => 'p16n-seed',
            'package_ensure' => 'installed',
          )
        end
      end

      describe 'when redis is configured' do
        let(:params) { @redis_params }

        it do
          is_expected.to contain_class('xylem').only_with(
            'name' => 'Xylem',
            'backend' => 'awesome.backend',
            'redis_host' => 'redis.foo',
            'redis_port' => 1234,
            'repo_manage' => true,
            'repo_source' => 'p16n-seed',
            'package_ensure' => 'installed',
          )
        end
      end

      describe 'when gluster is configured' do
        describe 'with mandatory params' do
          let(:params) { @gluster_params }

          it { is_expected.to contain_class('xylem') }

          it do
            is_expected.to contain_class('xylem::config::gluster').only_with(
              'name' => 'Xylem::Config::Gluster',
              'gluster_mounts' => ['/data/brick1', '/data/brick2'],
              'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
            )
          end
        end

        describe 'with all params' do
          let(:params) do
            @gluster_params.merge(
              :gluster_replica => 2,
              :gluster_stripe => 3,
            ).merge(@redis_params)
          end

          it do
            is_expected.to contain_class('xylem').with(
              'backend' => 'awesome.backend',
              'redis_host' => 'redis.foo',
              'redis_port' => 1234,
            )
          end

          it do
            is_expected.to contain_class('xylem::config::gluster').only_with(
              'name' => 'Xylem::Config::Gluster',
              'gluster_mounts' => ['/data/brick1', '/data/brick2'],
              'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
              'gluster_replica' => 2,
              'gluster_stripe' => 3,
            )
          end
        end

        [:gluster_mounts, :gluster_nodes].each do |param|
          [:undef, []].each do |value|
            describe "with #{param} = #{value.inspect}" do
              let(:params) { @gluster_params.merge(param => value) }

              it do
                is_expected.to compile.and_raise_error(
                  /#{param} must be an array with at least one element/)
              end
            end
          end
        end
      end

      describe 'when postgres is configured' do
        describe 'with mandatory params' do
          let(:params) { @postgres_params }

          it { is_expected.to contain_class('xylem') }

          it do
            is_expected.to contain_class('xylem::config::postgres').only_with(
              'name' => 'Xylem::Config::Postgres',
              'postgres_host' => 'db.local',
              'postgres_user' => 'pguser',
              'postgres_secret' => 'pgsec',
            )
          end
        end

        describe 'with all params' do
          let(:params) do
            @postgres_params.merge(:postgres_password => 'pgpass'
                ).merge(@redis_params)
          end

          it do
            is_expected.to contain_class('xylem').with(
              'backend' => 'awesome.backend',
              'redis_host' => 'redis.foo',
              'redis_port' => 1234,
            )
          end

          it do
            is_expected.to contain_class('xylem::config::postgres').only_with(
              'name' => 'Xylem::Config::Postgres',
              'postgres_host' => 'db.local',
              'postgres_user' => 'pguser',
              'postgres_secret' => 'pgsec',
              'postgres_password' => 'pgpass',
            )
          end
        end

        [:postgres_host, :postgres_user, :postgres_secret].each do |param|
          describe "without #{param}" do
            let(:params) { @postgres_params.merge(param => :undef) }

            it do
              is_expected.to compile.and_raise_error(
                /#{param} must be provided/)
            end
          end
        end
      end

      describe 'when gluster and postgres are configured' do
        let(:params) { @gluster_params.merge(@postgres_params) }

        it { is_expected.to contain_class('xylem') }

        it do
          is_expected.to contain_class('xylem::config::gluster').only_with(
            'name' => 'Xylem::Config::Gluster',
            'gluster_mounts' => ['/data/brick1', '/data/brick2'],
            'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
          )
        end

        it do
          is_expected.to contain_class('xylem::config::postgres').only_with(
            'name' => 'Xylem::Config::Postgres',
            'postgres_host' => 'db.local',
            'postgres_user' => 'pguser',
            'postgres_secret' => 'pgsec',
          )
        end
      end

      describe 'when package_ensure is purged' do
        let(:params) { {:package_ensure => 'purged'} }
        it do
          is_expected.to contain_class('xylem')
            .with_package_ensure('purged')
        end
        it do
          is_expected.to contain_package('seed-xylem')
            .with_ensure('purged')
        end
      end

      describe 'when repo_manage is false' do
        let(:params) { {:repo_manage => false} }
        it do
          is_expected.to contain_class('xylem')
            .with_repo_manage(false)
        end
        it do
          is_expected.not_to contain_class('xylem::repo')
        end
      end
    end
  end
end
