module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
    end

    option :user_id
    option :geocoder_service, default: -> { GeocoderService::Client.new }

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)
      @ad.user_id = @user_id

      if @ad.valid?
        @ad.save
        @geocoder_service.geocode_later(@ad)
      else
        fail!(@ad.errors)
      end
    end

    protected
  end
end
