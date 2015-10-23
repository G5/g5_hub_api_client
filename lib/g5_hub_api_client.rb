require 'services/notifications_service'

module G5HubApi
  class Client
    attr_reader :notification_service

    def initialize(host)
      @notification_service = NotificationService.new(host)
    end
  end
end
