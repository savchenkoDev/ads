channel = RabbitMQ.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('ads', durable: true)

queue.subscribe do |delivery_info, properties, payload|
  payload = JSON(payload)
  byebug
  Thread.current[:request_id] = properties.headers['request_id']

  lat, lon = payload['coordinates']

  Ads::UpdateService.call(id: payload['id'], data: payload['coordinates'])

  exchange.publish(
    '',
    routing_key: properties.reply_to,
    headers: {
      request_id: Thread.current[:request_id]
    }
  )
end