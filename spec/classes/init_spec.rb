require 'spec_helper'

describe 'xylem' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile }

      describe 'with default parameters' do
        it do
          is_expected.to contain_class('xylem::repo')
            .with({
              :manage => true,
              :source => 'p16n-seed',
            })
        end

        it do
          is_expected.to contain_package('seed-xylem')
            .with_ensure('installed')
            .that_requires('Class[xylem::repo]')
        end

      #   it do
      #     is_expected.to contain_file('/etc/init/xylem.conf')
      #       .with_content(/--host 127\.0\.0\.1/)
      #       .with_content(/--port 7000/)
      #       .with_content(/--consul http:\/\/127\.0\.0\.1:8500/)
      #       .with_content(/--marathon http:\/\/127\.0\.0\.1:8080/)
      #       .with_content(/--registration-id foo/)
      #       .with_content(/--sync-interval 0/)
      #       .with_content(/--no-purge/)
      #       .that_requires('Package[python-xylem]')
      #   end

      #   it do
      #     is_expected.to contain_service('xylem')
      #       .with_ensure('running')
      #       .that_subscribes_to('File[/etc/init/xylem.conf]')
      #   end
      end

      # describe 'when purge is true' do
      #   let(:params) { { :purge => true } }
      #   it do
      #     is_expected.to contain_file('/etc/init/xylem.conf')
      #       .with_content(/--purge/)
      #   end
      # end

      # describe 'when repo_manage is false' do
      #   let(:params) { { :repo_manage => false } }
      #   it do
      #     is_expected.to contain_class('xylem::repo')
      #       .with_manage(false)
      #   end
      # end

      # describe 'when repo_source is a custom value' do
      #   let(:params) { { :repo_source => 'hello' } }
      #   it do
      #     is_expected.to raise_error(/APT repository 'hello' is not supported./)
      #   end
      # end

      # describe 'when package_ensure is purged' do
      #   let(:params) { { :package_ensure => 'purged' } }
      #   it do
      #     is_expected.to contain_package('python-xylem')
      #       .with_ensure('purged')
      #   end
      # end

      # describe 'with extra options' do
      #   let(:params) do
      #     {
      #       :extra_opts => {
      #         'debug' => '',
      #         'scheme' => 'https',
      #       }
      #     }
      #   end
      #   it do
      #     is_expected.to contain_file('/etc/init/xylem.conf')
      #       .with_content(/--debug/)
      #       .with_content(/--scheme https/)
      #   end
      # end

      # describe 'with extra options that are also default options' do
      #   let(:params) { { :extra_opts => { 'port' => '7001' } } }
      #   it 'should override the default options' do
      #     is_expected.to contain_file('/etc/init/xylem.conf')
      #       .with_content(/--port 7001/)
      #       .without_content(/--port 7000/)
      #   end
      # end
    end
  end
end
