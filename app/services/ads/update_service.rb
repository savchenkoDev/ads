module Ads
  class UpdateService
    prepend BasicService

    option :id
    option :data
    option :ad, default: -> { Ad.first(id: @id) }

    attr_reader :ad

    def call
      return fail!(I18n.t(:not_found, scope: 'services.ads.update_service')) if @ad.blank?

      @ad.update_fields(@data.deep_symbolize_keys, %i[lat lon])
      Application.logger.info(
        'coordinates updated',
        headers: {
          request_id: Thread.current[:request_id]
        }
      )
    end
  end
end
