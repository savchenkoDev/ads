module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
    end

    option :user_id

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)
      set_coordinates
      @ad.user_id = @user_id

      if @ad.valid?
        @ad.save
      else
        fail!(@ad.errors)
      end
    end

    protected

    def set_coordinates
      response = geo_service.get(@ad.city)

      if response.key?('data')
        @ad.set(response['data'])
      else
        fail!(response['errors'])
      end
    end

    def geo_service
      @geo_service ||= Geocoder::Client.new
    end
  end
end
