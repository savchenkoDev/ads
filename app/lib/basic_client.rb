require 'dry/initializer'

module BasicClient
  def self.prepended(base)
    # See https://dry-rb.org/gems/dry-initializer/3.0/skip-undefined/
    base.extend Dry::Initializer[undefined: false]

    base.option :url
    base.option :connection, default: -> { build_connection }
  end
  
  

  private

  def build_connection
    Faraday.new(@url) do |connect|
      connect.request :json
      connect.response :json, content_type: /\bjson$/
      connect.adapter Faraday.default_adapter
    end
  end
end