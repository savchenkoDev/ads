require './app/controllers/ads_controller.rb'
require "spec_helper"

RSpec.describe AdsController do
  describe 'GET /' do
    before do
      create_list(:ad, 3, user_id: rand(1..3))
    end

    it 'returns a collection of ads' do
      get '/'

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(3)
    end
  end

  describe 'POST / (valid auth token)' do
    let(:body) { { ad: ad_params }.to_json }

    context 'missing parameters' do
      it 'returns an error' do
        post '/'
        expect(last_response.status).to eq(422)
      end
    end

    context 'invalid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: ''
        }
      end

      it 'returns an error' do
        post '/', body

        expect(last_response.status).to eq(422)
        expect(response_body['errors']).to include(
          {
            'detail' => 'Укажите город',
            'source' => {
              'pointer' => '/data/attributes/city'
            }
          }
        )
      end
    end

    context 'valid parameters' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City'
        }
      end
      let(:last_ad) { Ad.last }
      let(:body) { {ad: ad_params, user_id: 1}.to_json }

      it 'creates a new ad' do
        expect { post '/', body }.to change { Ad.count }.from(0).to(1)

        expect(last_response.status).to eq(201)
      end

      it 'returns an ad' do
        post '/', body

        expect(response_body['data']).to a_hash_including(
          'id' => last_ad.id.to_s,
          'type' => 'ad'
        )
      end
    end
  end

  # describe 'POST / (invalid auth token)' do
  #   let(:ad_params) do
  #     {
  #       title: 'Ad title',
  #       description: 'Ad description',
  #       city: 'City'
  #     }
  #   end

  #   it 'returns an error' do
  #     post '/', body: { ad: ad_params }.to_json

  #     expect(response).to have_http_status(:forbidden)
  #     expect(response_body['errors']).to include('detail' => 'Доступ к ресурсу ограничен')
  #   end
  # end
end
