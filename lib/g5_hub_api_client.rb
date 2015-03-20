require 'services/notifications_service'
require 'services/http_service'

# Implement our DI context here
class G5HubApiClient

  def initialize(host)
    @http_service = HttpService.new.inject(host)
    @notification_service = NotificationService.new.inject(@http_service)
  end

  def notification_service
    @notification_service
  end
end