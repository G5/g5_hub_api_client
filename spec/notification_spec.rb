require_relative '../lib/models/notification'

RSpec.describe G5HubApi::Notification do
  describe 'to_json' do
    let(:notification) { G5HubApi::Notification.new('product'=> 'blah',
                               'locations'=> [],
                               'notif_type' => 'Some notification',
                               'description' => 'Bla blab albnskdj wlkjdkjd',
                               'actions' => [],
                               'client_id' => '1234') }

    subject { notification.to_json }
    it { expect( subject ).to be_an_instance_of String }
    it { expect( JSON.parse(subject)['locations'] ).to eq([]) }
    it { expect( JSON.parse(subject)['notif_type'] ).to eq('Some notification') }
  end
end