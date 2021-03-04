module RequestHelpers
  def response_body
    JSON(last_response.body)
  end

  def auth_headers(user)
    session = user.sessions.create!
    token = JwtEncoder.encode(uuid: session.uuid)

    { 'Authorization' => "Bearer #{token}" }
  end
end
