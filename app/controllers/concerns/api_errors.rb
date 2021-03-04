module ApiErrors
  private

  def handle_exception(e)
    case e
    when ActiveRecord::RecordNotFound
      error_response(I18n.t(:not_found, scope: 'api.errors'), 404)
    when ActiveRecord::RecordNotUnique
      error_response(I18n.t(:not_unique, scope: 'api.errors'), 422)
    when KeyError
      error_response(I18n.t(:missing_parameters, scope: 'api.errors'), 422)
    else
      raise
    end
  end

  def error_response(error_messages, resp_status)
    errors = case error_messages
    when ActiveRecord::Base
      ErrorSerializer.from_model(error_messages)
    else
      ErrorSerializer.from_messages(error_messages)
    end

    [resp_status, errors.to_json]
  end
end
