require 'json'

class Notification
  attr_accessor :id,
                :product,
                :locations,
                :notif_type,
                :description,
                :actions,
                :client_id,
                :created_at,
                :modified_at


  def initialize(hash = {})
    @id           = hash['id']
    @product      = hash['product']
    @locations    = hash['locations']
    @notif_type   = hash['notif_type']
    @description  = hash['description']
    @actions      = hash['actions']
    @client_id    = hash['client_id']
    @created_at   = hash['created_at']
    @modified_at  = hash['modified_at']
  end

  def as_json(options={})
    {
        id: @id,
        product: @product,
        locations: @locations,
        notif_type: @notif_type,
        description: @description,
        actions: @actions,
        client_id: @client_id,
        created_at: @created_at,
        modified_at: @modified_at
    }
  end

  def to_json
    JSON.generate as_json
  end

end