require 'spec_helper'
require 'yaml'

describe 'xylem::node' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default parameters' do
        it { is_expected.to contain_class('xylem::node') }

        it { is_expected.not_to contain_class('xylem::repo') }

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

      # describe 'when replica and stripe are provided' do
      #   let(:params) { {:replica => 2, :stripe => 3} }

      #   it do
      #     is_expected.to contain_file('/etc/xylem/xylem.yml')
      #       .with_content(match_yaml({
      #             'queues' => [include(
      #                 'name' => 'gluster',
      #                 'gluster_mounts' => ['/data/brick1', '/data/brick2'],
      #                 'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
      #                 'gluster_replica' => 2,
      #                 'gluster_stripe' => 3,
      #             )]
      #           }))
      #   end

      #   # it do
      #   #   is_expected.to contain_file('/etc/xylem/xylem.yml')
      #   #     .with_content(match_yaml({
      #   #         'queues' => [{
      #   #             'name' => 'gluster',
      #   #             'plugin' => 'seed.xylem.gluster',
      #   #             'gluster_mounts' => ['/data/brick1', '/data/brick2'],
      #   #             'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
      #   #             'gluster_replica' => 2,
      #   #             'gluster_stripe' => 3,
      #   #           }]
      #   #       }))
      #   # end

      #   it do
      #     is_expected.to contain_service('xylem')
      #       .with_ensure('running')
      #       .that_subscribes_to('File[/etc/xylem/xylem.yml]')
      #   end
      # end

      # describe 'when mounts is not given' do
      #   let(:params) { {:peers => []} }
      #   it { is_expected.to compile.and_raise_error(/Must pass mounts/) }
      # end

      # describe 'when peers is not given' do
      #   let(:params) { {:mounts => []} }
      #   it { is_expected.to compile.and_raise_error(/Must pass peers/) }
      # end

      describe 'when package_ensure is purged' do
        let(:params) { {:package_ensure => 'purged'} }
        it do
          is_expected.to contain_package('seed-xylem')
            .with_ensure('purged')
        end
      end
    end
  end
end
