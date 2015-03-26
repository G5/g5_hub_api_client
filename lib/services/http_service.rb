require 'net/http'
require 'uri'
require 'json'
require 'openssl'

module G5HubApi
  class HttpService

    HTTPS             = 'https'
    CONTENT_TYPE      = 'Content-Type'
    APPLICATION_JSON  = 'application/json'
    ACCEPTS           = 'Accepts'

    # @param host - e.g. 'http(s)://www.google.com:8080'
    def initialize(host)
      @host = host
      return self
    end

    # @param endpoint     - e.g. '/context'
    # @param query_params - e.g. {a:1,b:2}
    def get(endpoint = '/', query_params = nil)
      make_request :get, endpoint, query_params
    end

    # @param endpoint     - e.g. '/context
    # @param query_params - e.g. {a:1,b:2}
    # @param body         - Any object that will respond to to_json
    def post(endpoint = '/', query_params = nil, body = {})
      make_request :post, endpoint, query_params, body
    end

    # @param type         - :get | :post
    # @param endpoint     - e.g. '/context
    # @param query_params - e.g. {a:1,b:2}
    # @param body         - Any object that will respond to to_json
    def make_request(type = :get, endpoint = '/', query_params = nil, body = nil)
      url = "#{@host}#{endpoint}"
      uri = URI.parse url

      uri.query = query_string(query_params) if query_params

      http = Net::HTTP.new(uri.host, uri.port)

      if uri.scheme.include? HTTPS
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      request = if type == :get
                  Net::HTTP::Get.new(uri.request_uri)
                else
                  Net::HTTP::Post.new(uri.request_uri)
                end

      if type == :post
        request.body = body.to_json if type == :post && body
        request[CONTENT_TYPE] = APPLICATION_JSON
      end

      request[ACCEPTS] = APPLICATION_JSON

      response = http.request(request)

      deserialize response
    end

    private

    def deserialize(response)
      response.body = JSON.parse(response.body) if response[CONTENT_TYPE].include?('json')
      response
    end

    def query_string(query_hash)
      URI::encode(query_hash.map { |k, v| "#{k}=#{v}" }.join('&'))
    end
  end
end
