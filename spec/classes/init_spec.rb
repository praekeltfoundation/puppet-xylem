require 'spec_helper'

describe 'xylem' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      before(:each) do
        @redis_params = {
          :redis_host => 'redis.foo',
          :redis_port => 1234,
          :backend => 'awesome.backend'
        }
      end

      describe 'with default parameters' do
        it { is_expected.to contain_class('xylem') }

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
          is_expected.to contain_class('xylem::config').only_with(
            'name' => 'Xylem::Config',
          )
        end

        it do
          is_expected.to contain_service('xylem')
            .with_ensure('running')
            .that_subscribes_to('Concat[/etc/xylem/xylem.yml]')
        end
      end

      describe 'when redis is configured' do
        let(:params) do
          {
            :redis_host => 'redis.foo',
            :redis_port => 1234,
            :backend => 'awesome.backend'
          }
        end

        it do
          is_expected.to contain_class('xylem::config').only_with(
            'name' => 'Xylem::Config',
            'backend' => 'awesome.backend',
            'redis_host' => 'redis.foo',
            'redis_port' => 1234,
          )
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
