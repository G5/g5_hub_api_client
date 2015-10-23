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
                  :modified_at,
                  :read_at

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
      @read_at      = hash['read_at']
    end

    def as_json(_ = {})
      result = { id:          @id,
        product:     @product,
        locations:   @locations,
        notif_type:  @notif_type,
        description: @description,
        actions:     @actions.map { |action| action.as_json },
        client_id:   @client_id,
        created_at:  @created_at,
        modified_at: @modified_at,
        read_at:     @read_at
      }
      result
    end

    def to_json(_ = {})
      JSON.generate(as_json)
    end
  end
end
