class Notification
  attr_accessor :product,
                :locations,
                :notif_type,
                :description,
                :actions,
                :client_id,
                :created_at,
                :modified_at

  def initialize(hash = {})
    @product      = hash[:product]
    @locations    = hash[:locations]
    @notif_type   = hash[:notif_type]
    @description  = hash[:description]
    @actions      = hash[:actions]
    @client_id    = hash[:client_id]
    @created_at   = hash[:created_at]
    @modified_at  = hash[:modified_at]
  end

end