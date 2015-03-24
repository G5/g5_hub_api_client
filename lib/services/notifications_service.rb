require 'models/notification'
require 'models/api_response'

class NotificationService

  def initialize(http_service)
    @http_service = http_service
  end

  def all(client_urn, params={page: 0, page_size: 25})
    page      = params[:page]       || 0
    page_size = params[:page_size]  || 25

    uri = "/clients/#{client_urn}/notifications?page=#{page}&size=#{page_size}"
    response = @http_service.get(uri)
    get_api_response response.body['notifications'], response.body['total_rows'], response.code, response.message
  end

  def create(client_urn, notification)
    uri = "/clients/#{client_urn}/notifications"
    response = @http_service.post(uri, nil, notification)
    get_api_response [response.body], nil, response.code, response.message
  end

  private

  def get_api_response(results, total_rows, code, message)
    api_response = ApiResponse.new

    if code == '200'
      results.each_index do |i|
        api_response.results.push(Notification.new(results[i]))
      end

      api_response.total_rows = total_rows
    else
      api_response.error = "Error: did not get 200 response from server: #{code}, #{message}"
    end

    api_response
  end

end