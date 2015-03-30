require 'models/notification'
require 'models/action'
require 'models/api_response'

module G5HubApi
  class NotificationService

    def initialize(http_service)
      @http_service = http_service
    end

    def all(client_urn, params={page: 0, page_size: 25, auth_token: nil})
      page       = params[:page]       || 0
      page_size  = params[:page_size]  || 25
      auth_token = params[:auth_token] || nil


      uri = "/clients/#{client_urn}/notifications"
      response = @http_service.get(endpoint: uri,
                                   query_params: {page: page, size: page_size},
                                   headers: {'Authorization'=>"Bearer #{auth_token}"})

      get_api_response(response.body['notifications'], response.body['total_rows'], response.code, response.message)
    end

    def create(client_urn, notification, params={auth_token: nil})
      auth_token = params[:auth_token] || nil
      uri = "/clients/#{client_urn}/notifications"
      response = @http_service.post(endpoint: uri,
                                    body: notification,
                                    headers: {'Authorization'=>"Bearer #{auth_token}"})
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
end