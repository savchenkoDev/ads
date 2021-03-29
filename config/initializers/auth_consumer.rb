channel = RabbitMQ.consumer_channel
queue = channel.queue('ads', durable: true)

queue.subscribe do |delivery_info, properties, payload|
  payload = JSON(payload)

  exchange.publish(
    '',
    routing_key: properties.reply_to,
    correlation_id: properties.correlation_id
  )
end