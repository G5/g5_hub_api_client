require 'json'

module G5HubApi
  class Action
    attr_accessor :label,
                  :url

    def initialize(hash = {})
      @label  = hash['label'] || hash[:label]
      @url    = hash['url']   || hash[:url]
    end

    def as_json(_ = {})
      { label: @label, url: @url }
    end

    def to_json(_=nil)
      JSON.generate(as_json)
    end
  end
end
