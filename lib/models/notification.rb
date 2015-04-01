require 'json'

module G5HubApi
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
      if (@actions && @actions.is_a?(Array))
        @actions = @actions.map { |value| G5HubApi::Action.new(value) }
      end
      @client_id    = hash['client_id']
      @created_at   = hash['created_at']
      @modified_at  = hash['modified_at']
    end

    def as_json(_ = {})
      { id:          @id,
        product:     @product,
        locations:   @locations,
        notif_type:  @notif_type,
        description: @description,
        actions:     @actions,
        client_id:   @client_id,
        created_at:  @created_at,
        modified_at: @modified_at }
    end

    def to_json
      JSON.generate(as_json)
    end
  end
end
