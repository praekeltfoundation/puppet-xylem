require 'spec_helper'
describe 'xylem::node' do

  context 'with defaults for all parameters' do
    it { should contain_class('xylem::node') }
  end
end
