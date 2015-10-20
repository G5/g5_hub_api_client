require_relative './spec_helper'
require 'g5_authentication_client'

describe G5HubApi::Client, e2e: true do

  AUTH_USER   = 'jonathan.samples@getg5.com'
  AUTH_PASS   = 'asdfasdf'
  HUB_HOST    = 'https://h5-hub-analytics.herokuapp.com' # http://5b189514.ngrok.com'
  CLIENT_URN  = 'g5-c-1slhp2tc-compass-rock-real-estate'
  AUTH_TOKEN  = ''
  USER_ID     = 1824 # jonathan.samples@getg5.com

  before do
    ENV['G5_AUTH_ENDPOINT']='https://dev-auth.g5search.com'
    ENV['G5_AUTH_CLIENT_ID']='cf9c6d37d85ae2b98078837ac76bf4c07911d04257c434be67cf4bef45b0fcf6'
    ENV['G5_AUTH_CLIENT_SECRET']='7b7169a60d40430f18508712a979be21065ca5609d057bc8e57e465efe8f9ac9'

    WebMock.allow_net_connect!
    AUTH_TOKEN = G5AuthenticationClient::Client.new(
      username: AUTH_USER,
      password: AUTH_PASS
    ).get_access_token
  end

  let(:api_client) { G5HubApi::Client.new(HUB_HOST) }
  let(:service) { api_client.notification_service }

  describe '#all_for_user' do

    context 'success' do
      subject { service.all_for_user(USER_ID, page: 0, page_size: 1, auth_token: AUTH_TOKEN) }
      its('results.length') { is_expected.to eq(1) }
      it('returns an ApiResponse', focus: true) { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it{ expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification  }
      it{ expect(subject.error).to eq(nil) }
    end

    context 'failure' do
      subject { service.all_for_user(USER_ID, page: 0, page_size: 1) }
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
