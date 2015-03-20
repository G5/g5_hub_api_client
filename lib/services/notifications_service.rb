require 'models/notification'

class NotificationService

  def inject(http_service)
    @http_service = http_service
    return self
  end

  def all(client_urn)
    return @http_service.get("/clients/#{client_urn}/notifications")
  end

  def create(client_urn, notification)
    return @http_service.post("/clients/#{client_urn}/notifications", notification)
  end

end