require_relative '../lib/services/notifications_service'
require_relative '../lib/services/http_service'
require 'rspec/its'
require 'rspec/mocks'
require 'rspec/expectations'

RSpec.describe NotificationService do

  # let(:httpService) do
  #   double('HttpService',
  #           :all => {
  #             'body' => {
  #                 'results' => [
  #                     {},
  #                     {},
  #                     {}
  #                 ],
  #                 'total_rows' => 25
  #             }
  #           })
  # end
  let(:httpService) { HttpService.new('http://localhost:3000') }

  describe '#all' do
    subject { NotificationService.new(httpService).all 'g5-c-6jxap99-blark',0,1 }
    # its('results.length') { is_expected.to eq(1) }
    # it { expect(subject.results[0]).to be_an_instance_of Notification  }

  end

end