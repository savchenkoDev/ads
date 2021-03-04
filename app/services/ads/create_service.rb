require './app/models/ad.rb'
require './app/services/basic_service.rb'

module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
    end

    # option :user
    option :user_id

    attr_reader :ad

    def call
      ad_params = @ad.to_h.merge!(user_id: @user_id)
      @ad = ::Ad.new(ad_params)
      # @ad = @user.ads.new(@ad.to_h)
      return fail!(@ad.errors) unless @ad.save

      # GeocodingJob.perform_later(@ad)
    end
  end
end
