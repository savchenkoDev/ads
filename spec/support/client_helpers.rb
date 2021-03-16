module ClientHelpers
  def connection
    Faraday.new do |connect|
      connect.request :json
      connect.response :json, content_type: /\bjson$/
      connect.adapter :test, stubs
    end
  end

  def stubs
    @stubs ||= Faraday::Adapter::Test::Stubs.new
  end
end
