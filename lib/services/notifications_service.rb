require 'models/notification'
require 'models/api_response'

class NotificationService

  def initialize(http_service)
    @http_service = http_service
    return self
  end

  def all(client_urn, page=0, page_size=25)
    uri = "/clients/#{client_urn}/notifications?page=#{page}&size=#{page_size}"
    response = @http_service.get(uri)

    result = ApiResponse.new

    if response.code == '200'
      response.body['results'].each_index do |i|
        result.results.push(Notification.new(response.body['results'][i]))
      end

      result.total_rows = response.body['total_rows']
    else
      result[:error] = "Error: did not get 200 response from server: #{response.code}, #{response.message}"
    end

    result
  end

  def create(client_urn, notification)
    return @http_service.post("/clients/#{client_urn}/notifications", notification)
  end

end