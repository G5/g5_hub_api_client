require 'spec_helper'

describe G5HubApi::HttpService do

  shared_examples '#make_request' do |request_type|

    context 'Valid host and endpoint' do
      let(:service) { G5HubApi::HttpService.new('http://echo.jsontest.com') }
      subject { service.make_request(type: request_type, endpoint: '/a/1') }

      its(:body) { is_expected.to eq({'a'=>'1'}) }
      its(:code) { is_expected.to eq('200') }
      its(['Content-Type']) { is_expected.to include('application/json') }
    end

    context 'Invalid host' do
      let(:service) { G5HubApi::HttpService.new('http://boblablaslawblog.com') }
      it do
        expect{ service.make_request(type: request_type, endpoint:'/') }.to raise_error(SocketError)
      end
    end

    context 'Invalid path' do
      let(:service) { G5HubApi::HttpService.new('http://www.google.com') }
      subject { service.make_request(type: request_type, endpoint: '/blarg') }

      its(:code) { is_expected.to eq('404') }
      it { expect{ subject }.to_not raise_error (Exception) }
    end

    context 'Wrong content type' do
      let(:service) { G5HubApi::HttpService.new('http://www.google.com') }
      subject { service.make_request(type: request_type, endpoint: '/search') }

      its(['Content-Type']) { is_expected.to include('text/html') }
      its(:body) { is_expected.to be_a(String)}
      it { expect{ subject }.to_not raise_error (Exception) }
    end

    context 'Query string as part of endpoint' do
      let(:service) { G5HubApi::HttpService.new('http://validate.jsontest.com') }
      subject { service.make_request(type: request_type, endpoint: '/hello?json={}') }

      it { expect{ subject }.to raise_error(URI::InvalidURIError) }
    end

    context 'Using query params' do
      let(:service) { G5HubApi::HttpService.new('http://validate.jsontest.com') }
      subject { service.make_request(type: request_type, endpoint: '/', query_params: {json:'{}'}) }

      it { expect( subject.body['empty'] ).to eq(true) }
      its(:code) { is_expected.to eq('200') }
      its(['Content-Type']) { is_expected.to include('application/json') }
    end

    context 'with headers' do
      let(:token) { 'Bearer sometoken' }
      let(:service) { G5HubApi::HttpService.new('http://headers.jsontest.com') }
      subject { service.make_request(type: request_type, endpoint: '/', headers: {'Authorization' => token} ) }

      its(:code) { is_expected.to eq('200') }
      it 'body should contain header' do
        expect( subject.body['Authorization'] ).to eq( token )
      end
    end

    context 'Using Https' do
      let(:service) { G5HubApi::HttpService.new('https://www.google.com') }
      subject { service.make_request(type: request_type, endpoint: '/search') }
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
