module GeocoderService
  module Api
    def geocode_later(ad)
      payload = {id: ad.id, city: ad.city}.to_json

      publish(payload, type: 'geocode')
    end
  end
end