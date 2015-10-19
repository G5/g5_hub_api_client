require 'spec_helper'

describe G5HubApi::NotificationService do

  let(:host) { 'http://localhost:3000' }
  let(:user_id) { 'some_user_id' }
  let(:auth_token) { '6928b6d784e11f665b2f7b520f91734d735b99130b4f4014ab20ef561be34d21' }
  let(:client_id) { 'some_client_id' }
  let(:response_body) { {} }
  let(:response_code) { 200 }

  before do
    stub_request(:get, "#{host}/users/#{user_id}/notifications?access_token=#{auth_token}&page=0&size=1")
      .to_return(body: response_body.to_json, status: response_code)
    stub_request(:post, "#{host}/clients/#{client_id}/notifications?access_token=#{auth_token}")
      .to_return(body: response_body.to_json, status: response_code)
  end

  describe '#all_for_user' do

    subject do
      G5HubApi::NotificationService.new(host)
        .all_for_user('some_user_id', page: 0, page_size: 1, auth_token: auth_token)
    end

    context 'success' do

      let(:response_body) { {'notifications' => [{}], 'total_rows' => 25} }

      its('results.length') { is_expected.to eq(1) }
      it 'returns an ApiResponse' do
        expect(subject).to be_an_instance_of G5HubApi::ApiResponse
      end
      it { expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification  }
      it { expect(subject.error).to eq(nil) }

    end

    context 'failure' do
      let(:response_body) { {'notifications' => [], 'total_rows' => 0} }
      let(:response_code) { 404 }

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
                                 'actions' => [],
                                 'client_id' => client_id)
    end

    subject { G5HubApi::NotificationService.new(host).create(client_id, notification, auth_token: auth_token) }

    context 'success' do
      let(:response_body) { {} }
      let(:response_code) { 200 }

      its('results.length') { is_expected.to eq(1) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.error).to eq(nil) }
      it { expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification }

    end

    context 'failure' do

      let(:response_body) { {} }
      let(:response_code) { 500 }

      its('results.length') { is_expected.to eq(0) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.error).to_not eq(nil) }

    end

  end

  describe '#udpate' do
    let(:notification) do
      G5HubApi::Notification.new(
        'id' => 'blah',
        'product'=> 'blah',
        'locations'=> [],
        'notif_type' => 'Some notification',
        'description' => 'Bla blab albnskdj wlkjdkjd',
        'actions' => [],
        'client_id' => client_id)
    end

    before do
      stub_request(:put, "#{host}/users/#{user_id}/notifications/#{notification.id}?access_token=#{auth_token}")
        .to_return(body: response_body.to_json, status: response_code)
    end

    subject { G5HubApi::NotificationService.new(host).update(user_id, notification, auth_token: auth_token) }

    context 'success' do
      let(:response_body) { {} }
      let(:response_code) { 200 }

      its('results.length') { is_expected.to eq(1) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.error).to eq(nil) }
      it { expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification }

    end

    context 'failure' do

      let(:response_body) { {} }
      let(:response_code) { 500 }

      its('results.length') { is_expected.to eq(0) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.error).to_not eq(nil) }

    end
  end

end
