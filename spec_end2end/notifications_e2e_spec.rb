require 'spec_helper'

describe G5HubApi::Client, e2e: true do

  AUTH_TOKEN = '0419547595d6e36c7d9b7424ba4865ddba4bb662fbdd70e0815daaae311788b2'
  HUB_HOST = 'https://h5-hub-analytics.herokuapp.com'
  CLIENT_URN = 'g5-c-1slhp2tc-compass-rock-real-estate'

  let(:api_client) { G5HubApi::Client.new(HUB_HOST) }
  let(:service) { api_client.notification_service }

  describe '#all' do

    context 'success' do
      subject { service.all(CLIENT_URN, page: 0, page_size: 1, auth_token: AUTH_TOKEN) }
      its('results.length') { is_expected.to eq(1) }
      it ('returns an ApiResponse') { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification  }
      it { expect(subject.error).to eq(nil) }
    end

    context 'failure' do
      subject { service.all(CLIENT_URN, page: 0, page_size: 1) }
      its('results.length') { is_expected.to eq(0) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.error).not_to eq(nil) }
    end

  end

  describe '#create' do

    let(:notification) do
      G5HubApi::Notification.new('product'=> 'blah',
                                 'locations'=> [],
                                 'notif_type' => 'Some notification',
                                 'description' => 'Bla blab albnskdj wlkjdkjd',
                                 'actions' => [{label: 'Click Me', url:'http://getg5.com'}])
    end

    context 'success' do
      subject { service.create(CLIENT_URN, notification, auth_token: AUTH_TOKEN) }
      it do
        expect(subject.results.length).to eq(1)
        expect(subject).to be_an_instance_of G5HubApi::ApiResponse
        expect(subject.error).to eq(nil)
        expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification
      end
    end

    context 'failure' do
      subject { service.create(CLIENT_URN, notification) }
      its('results.length') do
         expect(subject.results.length).to eq(0)
         expect(subject).to be_an_instance_of G5HubApi::ApiResponse
         expect(subject.error).to_not eq(nil)
      end
    end
  end

end
