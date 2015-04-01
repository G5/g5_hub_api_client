require 'spec_helper'

describe G5HubApi::Action do
  describe 'to_json' do
    let(:label) { 'Do Stuff!' }
    let(:url) { 'http://getg5.com' }
    let(:action) { G5HubApi::Action.new('label'=> label, 'url'=> url) }

    subject { action.to_json }
    it { expect( subject ).to be_an_instance_of String }
    it { expect( JSON.parse(subject)['label'] ).to eq(label) }
    it { expect( JSON.parse(subject)['url'] ).to eq(url) }
  end
end
