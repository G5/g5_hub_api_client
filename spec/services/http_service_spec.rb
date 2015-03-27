require 'spec_helper'

describe G5HubApi::HttpService do

  shared_examples '#make_request' do |request_type|

    context 'Valid host and endpoint' do
      let(:service) { G5HubApi::HttpService.new('http://echo.jsontest.com') }
      subject { service.make_request(request_type, '/a/1') }

      its(:body) { is_expected.to eq({'a'=>'1'}) }
      its(:code) { is_expected.to eq('200') }
      its(['Content-Type']) { is_expected.to include('application/json') }
    end

    context 'Invalid host' do
      let(:service) { G5HubApi::HttpService.new('http://boblablaslawblog.com') }
      it do
        expect{ service.make_request(request_type, '/') }.to raise_error(SocketError)
      end
    end

    context 'Invalid path' do
      let(:service) { G5HubApi::HttpService.new('http://www.google.com') }
      subject { service.make_request(request_type, '/blarg') }

      its(:code) { is_expected.to eq('404') }
      it { expect{ subject }.to_not raise_error (Exception) }
    end

    context 'Wrong content type' do
      let(:service) { G5HubApi::HttpService.new('http://www.google.com') }
      subject { service.make_request(request_type, '/search') }

      its(['Content-Type']) { is_expected.to include('text/html') }
      its(:body) { is_expected.to be_a(String)}
      it { expect{ subject }.to_not raise_error (Exception) }
    end

    context 'Query string as part of endpoint' do
      let(:service) { G5HubApi::HttpService.new('http://validate.jsontest.com') }
      subject { service.make_request(request_type, '/hello?json={}') }

      it { expect{ subject }.to raise_error(URI::InvalidURIError) }
    end

    context 'Using query params' do
      let(:service) { G5HubApi::HttpService.new('http://validate.jsontest.com') }
      subject { service.make_request(request_type, '/', {json:'{}'}) }

      it { expect( subject.body['empty'] ).to eq(true) }
      its(:code) { is_expected.to eq('200') }
      its(['Content-Type']) { is_expected.to include('application/json') }
    end

    context 'Using Https' do
      let(:service) { G5HubApi::HttpService.new('https://www.google.com') }
      subject { service.make_request(request_type, '/search') }
      it { expect{ subject }.to_not raise_error (Exception) }
    end

  end

  describe '#get' do
    it_should_behave_like '#make_request', :get
  end

  describe '#post' do
    it_should_behave_like '#make_request', :post


  end
end
