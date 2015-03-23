require 'services/notifications_service'
require 'services/http_service'

# Implement our DI context here
class G5HubApiClient

  attr_reader :notification_service

  def initialize(host)
    @http_service = HttpService.new(host)
    @notification_service = NotificationService.new(@http_service)
  end

end