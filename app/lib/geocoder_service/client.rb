require_relative 'api'

module GeocoderService
  class Client
    include GeocoderService::Api
    # See https://dry-rb.org/gems/dry-initializer/3.0/skip-undefined/
    extend Dry::Initializer[undefined: false]
  
    option :queue, default: -> { create_queue }

    private

    def create_queue
      channel = RabbitMQ.channel
      channel.queue('geocoding', durable:true)
    end

    def publish(payload, opts = {})
      @queue.publish(
        payload,
        opts.merge(persistent: true, app_id: 'ads' )
      )
    end
  end
end