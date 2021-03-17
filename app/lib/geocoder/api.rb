module Geocoder
  module Api
    def get(city)
      response = connection.get('coordinates', city: city)

      response.body
    end
  end
end