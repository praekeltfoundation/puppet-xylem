require 'spec_helper'
describe 'xylem::docker' do

  context 'with defaults for all parameters' do
    it { should contain_class('xylem::docker') }
  end
end
