require 'models/notification'
require 'models/action'
require 'models/api_response'
require 'rest-client'

module G5HubApi
  class NotificationService

    EMPTY_JSON = {}.to_json.freeze

    def initialize(host)
      @host = host
    end

    def all_for_user(user_id, params = { page: 0, page_size: 25, auth_token: nil, read_only: nil })
      page       = params[:page]       || 0
      page_size  = params[:page_size]  || 25
      auth_token = params[:auth_token] || nil
      read_only  = params[:read_only]  || nil

      response = RestClient.get(
        "#{@host}/users/#{user_id}/notifications",
        params: { access_token: auth_token, page: page, size: page_size, read_only: read_only },
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      )
    rescue => e
      response = e.response
    ensure
      body = JSON.parse(response.body)
      return get_api_response(body['notifications'], body['total_rows'], response.code)
    end

    def create(client_urn, notification, params = { auth_token: nil })
      auth_token = params[:auth_token] || nil
      response = RestClient.post(
        "#{@host}/clients/#{client_urn}/notifications",
        { notification: notification.as_json }.to_json,
        params: { access_token: auth_token },
        content_type: :json,
        accept: :json,
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      )
    rescue => e
      response = e.response
    ensure
      body = response.body.empty? ? EMPTY_JSON : JSON.parse(response.body)
      return get_api_response([body], nil, response.code)
    end

    def update(user_id, notification, params = { auth_token: nil })
      auth_token = params[:auth_token] || nil
      response = RestClient.put(
        "#{@host}/users/#{user_id}/notifications/#{notification.id}",
        { notification: notification }.to_json,
        params: { access_token: auth_token },
        verify_ssl: OpenSSL::SSL::VERIFY_NONE,
        content_type: :json
      )
    rescue => e
      response = e.response
    ensure
      body = JSON.parse(response.body)
      return get_api_response([body], nil, response.code)
    end

    private

    def get_api_response(results, total_rows, code)
      api_response = ApiResponse.new

      if code == 200
        results.each_index do |i|
          api_response.results.push(Notification.new(results[i]))
        end

        api_response.total_rows = total_rows
      else
        api_response.error = "Error: did not get 200 response from server: #{code}"
      end

      api_response
    end
  end
end
