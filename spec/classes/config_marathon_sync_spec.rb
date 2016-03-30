require 'spec_helper'

describe 'xylem::config::marathon_sync' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      before(:each) do
        @marathon_sync_params = {
          :group_json_files => ['/etc/m_apps/g1.json', '/etc/m_apps/g2.json'],
        }
      end

      describe 'with mandatory params' do
        let(:params) { @marathon_sync_params }

        it { is_expected.to contain_xylem__config__plugin('marathon_sync') }

        it do
          is_expected.to contain_concat__fragment(
            'xylem_config_plugin_marathon_sync')
            .with_content(match_yaml([{
                  'name' => 'marathon_sync',
                  'plugin' => 'seed.xylem.marathon_sync',
                  'group_json_files' => [
                    '/etc/m_apps/g1.json',
                    '/etc/m_apps/g2.json'],
                }]))
        end
      end

      describe 'with all params' do
        let(:params) do
          @marathon_sync_params.merge(
            :marathon_host => 'localhost',
            :marathon_port => 8080,
          )
        end

        it do
          is_expected.to contain_concat__fragment(
            'xylem_config_plugin_marathon_sync')
            .with_content(match_yaml([{
                  'name' => 'marathon_sync',
                  'plugin' => 'seed.xylem.marathon_sync',
                  'marathon_host' => 'localhost',
                  'marathon_port' => 8080,
                  'group_json_files' => [
                    '/etc/m_apps/g1.json',
                    '/etc/m_apps/g2.json'],
                }]))
        end
      end

      [:group_json_files].each do |param|
        [:undef, []].each do |value|
          describe "with #{param} = #{value.inspect}" do
            let(:params) { @marathon_sync_params.merge(param => value) }

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
