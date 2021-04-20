module RabbitMQ
  extend self

  @mutex = Mutex.new

  def connection
    @mutex.synchronize do
      @connection ||= Bunny.new(
        host: Settings.rabbit_mq.host,
        username: Settings.rabbit_mq.username,
        password: Settings.rabbit_mq.password
      ).start
    end
  end

  def channel
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  def consumer_channel
    Thread.current[:rabbitmq_consumer_channel] ||= connection.create_channel(
      nil,
      Settings.rabbit_mq.consumer_pool
    )
  end
end