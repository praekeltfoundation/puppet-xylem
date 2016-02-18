require 'spec_helper'
describe 'xylem' do

  context 'with defaults for all parameters' do
    it { should contain_class('xylem') }
  end
end
