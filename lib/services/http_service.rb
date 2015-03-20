require 'net/http'
require 'uri'

class HttpService

  # @param host - e.g. 'http(s)://www.google.com:8080'
  def inject(host)
    @host = host
    return self
  end

  # @param endpoint - e.g. '/context?query=value'
  def get(endpoint)
    puts "Getting endpoint: #{endpoint}"
    url = "#{@host}#{endpoint}"
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme.include? 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # FIXME: Is this for real?
    request = Net::HTTP::Get.new(endpoint)
    http.request(request)
  end

  # @param endpoint - e.g. '/context?query=value
  # @param body     - Any object that will respond to to_json
  def post(endpoint, body)
    puts "Posting endpoint: #{endpoint}, body: #{body.to_json}"
    url = "#{@host}#{endpoint}"
    uri = URI.parse url
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme.include? 'https'
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE # FIXME: Is this for real?
    request = Net::HTTP::Get.new(endpoint)
    request.body = body.to_json
    request['Content-Type'] = 'application/json'
    http.request(request)
  end

end