require 'spec_helper'

describe G5HubApi::Notification do

  let(:action_hash) {  {'label'=>'Do Stuff!','url'=>'http://getg5.com'} }
  let(:notification_hash) do
    {'product'=> 'blah',
     'locations'=> [],
     'notif_type' => 'Some notification',
     'description' => 'Bla blab albnskdj wlkjdkjd',
     'actions' => [action_hash],
     'client_id' => '1234'}
  end

  describe 'to_json' do
    let(:notification) { G5HubApi::Notification.new(notification_hash) }

    subject { notification.to_json }
    it { expect( subject ).to be_an_instance_of String }
    it { expect( JSON.parse(subject)['locations'] ).to eq([]) }
    it { expect( JSON.parse(subject)['notif_type'] ).to eq('Some notification') }
    it { expect( JSON.parse(subject)['actions'] ).to eq([action_hash]) }
  end

  describe 'initialize' do
    subject { G5HubApi::Notification.new(notification_hash) }
    its(:product) { is_expected.to eq('blah') }
    its(:locations) { is_expected.to eq([]) }
    its(:notif_type) { is_expected.to eq('Some notification') }
    its(:description) { is_expected.to eq('Bla blab albnskdj wlkjdkjd') }
    its(:actions) { is_expected.to be_an_instance_of(Array) }
    its('actions.length') { is_expected.to eq(1)}
    it('actions are Action objects') do
      subject.actions.each { |val| expect(val).to be_an_instance_of(G5HubApi::Action) }
    end
  end
end
