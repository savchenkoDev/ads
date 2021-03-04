require 'json'
require 'i18n'
require 'sinatra/url_for'
require './app/controllers/concerns/pagination_links.rb'
require './app/controllers/concerns/api_errors.rb'
require './config/localisation.rb'

class AdsController < Sinatra::Base
  include PaginationLinks
  include ApiErrors
  include Localisation
  
  helpers Sinatra::UrlForHelper
  disable :show_exceptions
  disable :raise_errors

  before do
    if request.post? && request.body.length.positive?
      request.body.rewind
      params.merge!(JSON.parse(request.body.read))
    end
    
    content_type :json
  end
  
  get '/' do
    ads = Ad.order(updated_at: :desc).page(params[:page])
    serializer = AdSerializer.new(ads, links: pagination_links(ads))

    serializer.serialized_json
  end

  post '/' do
    result = Ads::CreateService.call(
      ad: ad_params(params),
      user_id: params[:user_id]
      # user: current_user
    )

    if result.success?
      serializer = AdSerializer.new(result.ad)
      status 201
      serializer.serialized_json
    else
      error_response(result.ad, 422)
    end
  end

  error do
    e = env['sinatra.error']
    resp_status, errors = handle_exception(e)
    
    error(resp_status, errors.to_json)
  end

  private

  def ad_params(params)
    params.fetch(:ad).slice(:title, :description, :city)
  end
end