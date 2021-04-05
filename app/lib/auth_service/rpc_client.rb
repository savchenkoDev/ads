require_relative 'rpc_api'

module AuthService
  class RpcClient
    include RabbitMQ
    include RpcApi
    # See https://dry-rb.org/gems/dry-initializer/3.0/skip-undefined/
    extend Dry::Initializer[undefined: false]
  
    option :queue, default: -> { create_queue }
    option :reply_queue, default: -> { create_reply_queue }
    option :lock, default: -> { Mutex.new }
    option :condition, default: -> { ConditionVariable.new }

    attr_reader :user_id

    def self.fetch
      Thread.current['ads_service.rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe do |delivery_info, properties, payload|
        return unless properties[:correlation_id] == @correlation_id
        @user_id = payload.to_i
        @lock.synchronize {@condition.signal}
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMQ.channel
      channel.queue('auth', durable: true)
    end
  
    def create_reply_queue
      channel = RabbitMQ.channel
      channel.queue('amq.rabbitmq.reply-to')
    end

    def publish(payload, opts = {})
      self.correlation_id = SecureRandom.uuid

      @lock.synchronize do
        @queue.publish(
          payload,
          opts.merge(
            app_id: 'auth',
            correlation_id: @correlation_id,
            reply_to: @reply_queue.name
          )
        )
        @condition.wait(@lock)
      end
    end
  end
end