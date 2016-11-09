require 'spec_helper'

describe 'xylem::config::postgres' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      before(:each) do
        @postgres_params = {
          :postgres_host => 'db.local',
          :postgres_user => 'pguser',
          :postgres_secret => 'pgsec',
        }
      end


      describe 'with mandatory params' do
        let(:params) { @postgres_params }

        it { is_expected.to contain_xylem__config__plugin('postgres') }

        it do
          is_expected.to contain_concat__fragment(
            'xylem_config_plugin_postgres')
            .with_content(match_yaml([{
                  'name' => 'postgres',
                  'plugin' => 'seed.xylem.postgres',
                  'key' => 'pgsec',
                  'servers' => [{
                      'hostname' => 'db.local',
                      'username' => 'pguser',
                    }]
                }]))
        end
      end

      describe 'with all params' do
        let(:params) do
          @postgres_params.merge(
            :postgres_password => 'pgpass',
            :postgres_connect_addr => 'localhost')
        end

        it do
          is_expected.to contain_concat__fragment(
            'xylem_config_plugin_postgres')
            .with_content(match_yaml([{
                  'name' => 'postgres',
                  'plugin' => 'seed.xylem.postgres',
                  'key' => 'pgsec',
                  'servers' => [{
                      'hostname' => 'db.local',
                      'username' => 'pguser',
                      'password' => 'pgpass',
                      'connect_addr' => 'localhost',
                    }]
                }]))
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
  end
end
