require 'spec_helper'

describe 'xylem::config::gluster' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      before(:each) do
        @gluster_params = {
          :gluster_mounts => ['/data/brick1', '/data/brick2'],
          :gluster_nodes => ['gfs1.local', 'gfs2.local'],
        }
      end

      describe 'with mandatory params' do
        let(:params) { @gluster_params }

        it { is_expected.to contain_xylem__config__plugin('gluster') }

        it do
          is_expected.to contain_concat__fragment(
            'xylem_config_plugin_gluster')
            .with_content(match_yaml([{
                  'name' => 'gluster',
                  'plugin' => 'seed.xylem.gluster',
                  'gluster_mounts' => ['/data/brick1', '/data/brick2'],
                  'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
                }]))
        end
      end

      describe 'with all params' do
        let(:params) do
          @gluster_params.merge(
            :gluster_replica => 2,
            :gluster_stripe => 3,
          )
        end

        it do
          is_expected.to contain_concat__fragment(
            'xylem_config_plugin_gluster')
            .with_content(match_yaml([{
                  'name' => 'gluster',
                  'plugin' => 'seed.xylem.gluster',
                  'gluster_mounts' => ['/data/brick1', '/data/brick2'],
                  'gluster_nodes' => ['gfs1.local', 'gfs2.local'],
                  'gluster_replica' => 2,
                  'gluster_stripe' => 3,
                }]))
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
  end
end
