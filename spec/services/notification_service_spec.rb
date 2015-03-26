require_relative '../lib/services/notifications_service'
require_relative '../lib/services/http_service'
require 'rspec/its'
require 'rspec/mocks'
require 'rspec/expectations'

RSpec.describe G5HubApi::NotificationService do


  # let(:httpService) { HttpService.new('http://localhost:3000') }

  let(:httpService) do
    double('HttpService',
           :get => response,
           :post => response)
  end

  describe '#all' do

    subject { G5HubApi::NotificationService.new(httpService).all 'g5-c-6jxap99-blark', page: 0, page_size:1 }

    context 'success' do

      let(:response) do
        double('body' => {
                   'notifications' => [{}],
                   'total_rows' => 25
               },
               :code => '200',
               :message => 'OK')
      end

      its('results.length') { is_expected.to eq(1) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse}
      it { expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification  }
      it { expect(subject.error).to eq(nil) }

    end

    context 'failure' do
      let(:response) do
        double('body' => {
                   'notifications' => [],
                   'total_rows' => 0
               },
               :code => '404',
               :message => 'Resource Not Found')
      end

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
                       'client_id' => '1234')
    end

    subject { G5HubApi::NotificationService.new(httpService).create 'g5-c-6jxap99-blark', notification }

    context 'success' do
      let(:response) do
        double('body' => {},
               :code => '200',
               :message => 'OK')
      end

      its('results.length') { is_expected.to eq(1) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.error).to eq(nil) }
      it { expect(subject.results[0]).to be_an_instance_of G5HubApi::Notification }

    end

    context 'failure' do

      let(:response) do
        double('body' => {},
               :code => '500',
               :message => 'Server Error')
      end

      its('results.length') { is_expected.to eq(0) }
      it { expect(subject).to be_an_instance_of G5HubApi::ApiResponse }
      it { expect(subject.error).to_not eq(nil) }

    end

  end

end