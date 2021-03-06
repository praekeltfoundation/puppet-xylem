require 'spec_helper'

describe 'xylem::docker' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'when backend is given' do
        let(:params) { {:backend => 'gfs.local'} }

        it { is_expected.to contain_class('xylem::docker') }

        it do
          is_expected.to contain_class('xylem::repo')
            .with({'manage' => true, 'source' => 'p16n-seed'})
            .that_comes_before('Package[docker-xylem]')
        end

        it do
          is_expected.to contain_package('docker-xylem')
            .with_ensure('installed')
        end

        it do
          is_expected.to contain_file('/etc/docker/xylem-plugin.yml')
            .with_content(match_yaml({
                'host' => 'gfs.local',
                'port' => 7701,
                'mount_path' => '/var/lib/docker/volumes',
                'socket' => '/run/docker-xylem.sock',
              }))
            .that_requires('Package[docker-xylem]')
        end

        it do
          is_expected.to contain_file('/etc/docker/plugins/xylem.spec')
            .with_content('unix:///run/docker-xylem.sock')
        end

        it do
          is_expected.to contain_file('/etc/docker/plugins')
            .with_ensure('directory')
        end

        it do
          is_expected.to contain_service('docker-xylem')
            .with_ensure('running')
            .that_requires('File[/etc/docker/plugins/xylem.spec]')
            .that_subscribes_to('File[/etc/docker/xylem-plugin.yml]')
        end
      end

      describe 'when backend is not given' do
        it do
          is_expected.to compile.and_raise_error(missing_param('backend'))
        end
      end

      describe 'when package_ensure is purged' do
        let(:params) { {:backend => 'gfs.local', :package_ensure => 'purged'} }
        it do
          is_expected.to contain_package('docker-xylem')
            .with_ensure('purged')
        end
      end

      describe 'when repo_manage is false' do
        let(:params) { {:backend => 'gfs.local', :repo_manage => false} }
        it do
          is_expected.not_to contain_class('xylem::repo')
        end
      end
    end
  end
end
