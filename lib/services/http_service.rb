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
    # @param headers      - name value pairs for custom headers
    DEFAULT_GET_PARAMS = { endpoint: '/', query_params: nil, body: nil, headers: {} }
    def get(params = DEFAULT_GET_PARAMS)
      params[:type] = :get
      make_request params
    end

    # @param endpoint     - e.g. '/context
    # @param query_params - e.g. {a:1,b:2}
    # @param body         - Any object that will respond to to_json
    # @param headers      - name value pairs for custom headers
    DEFAULT_POST_PARAMS = { endpoint:'/', query_params:nil, body:{}, headers:{} }
    def post(params = DEFAULT_POST_PARAMS)
      params[:type] = :post
      make_request params
    end

    # @param type         - :get | :post
    # @param endpoint     - e.g. '/context
    # @param query_params - e.g. {a:1,b:2}
    # @param body         - Any object that will respond to to_json
    # @param headers      - name value pairs for custom headers
    DEFAULT_PARAMS = { type: :get, endpoint: '/', query_params: nil, body: nil, headers: {} }
    def make_request(params = DEFAULT_PARAMS)
      type          = get_param(params, :type)
      endpoint      = get_param(params, :endpoint)
      query_params  = get_param(params, :query_params)
      body          = get_param(params, :body)
      headers       = get_param(params, :headers)

      url = "#{@host}#{endpoint}"
      uri = URI.parse url

      uri.query = query_string(query_params) if query_params

      http = Net::HTTP.new(uri.host, uri.port)

      # http.set_debug_output $stderr


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

      if headers
        headers.each { |key,value| request[key] = value }
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

    def get_param(params, param)
      params[param] || DEFAULT_PARAMS[param]
    end
  end
end
