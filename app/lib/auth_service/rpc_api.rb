module AuthService
  module RpcApi
    def auth(token)
      payload = { token: token }.to_json
      
      publish(payload, type: 'fetch_user')
      self
    end
  end
end