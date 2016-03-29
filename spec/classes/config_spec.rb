require 'spec_helper'

describe 'xylem::config' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      describe 'with default parameters' do
        it { is_expected.to contain_class('xylem::config') }

        it { is_expected.to contain_concat('/etc/xylem/xylem.yml') }

        it do
          is_expected.to contain_concat__fragment('xylem_config_top')
            .with_content(match_yaml({'queues' => nil}))
        end
      end

      describe 'when redis is configured' do
        describe 'with mandatory params' do
          let(:params) do
            {
              :redis_host => 'redis.foo',
              :redis_port => 1234,
              :backend => 'awesome.backend'
            }
          end

          it { is_expected.to contain_class('xylem::config') }

          it { is_expected.to contain_concat('/etc/xylem/xylem.yml') }

          it do
            is_expected.to contain_concat__fragment('xylem_config_top')
              .with_content(match_yaml({
                  'redis_host' => 'redis.foo',
                  'redis_port'=> 1234,
                  'backend' => 'awesome.backend',
                  'queues' => nil,
                }))
          end
        end
      end
    end
  end
end
