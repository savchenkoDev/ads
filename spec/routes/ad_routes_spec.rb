RSpec.describe AdRoutes, type: :routes do
  describe 'GET /v1' do
    let(:user_id) { 101 }

    before do
      create_list(:ad, 3, user_id: user_id)
    end

    it 'returns a collection of ads' do
      get '/v1'

      expect(last_response.status).to eq(200)
      expect(response_body['data'].size).to eq(3)
    end
  end

  describe 'POST /v1' do
    let(:user_id) { 101 }
    let(:coordinates) { {'data' => {'lat' => 1.11111, 'lon' => 2.22222}} }
    let(:auth_token) { 'valid_token' }
    let(:city) { 'City' }
    let(:auth_service) { instance_double('Auth service') }
    let(:geo_service) { instance_double('Geo service') }

    before do
      allow(auth_service).to receive(:auth)
        .with(auth_token)
        .and_return(user_id)
      allow(geo_service).to receive(:get)
        .with(city)
        .and_return(coordinates)

      allow(AuthService::Client).to receive(:new)
        .and_return(auth_service)
      allow(GeocoderService::Client).to receive(:new)
        .and_return(geo_service)

      header 'Authorization', "Bearer #{auth_token}"
    end

    context 'missing parameters' do
      it 'returns an error' do
        post '/v1'

        expect(last_response.status).to eq(422)
      end
    end

    context 'missing user_id' do
      let(:user_id) { nil }
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: 'City'
        }
      end

      it 'returns an error' do
        post '/v1', ad: ad_params

        expect(last_response.status).to eq(403)
        expect(response_body['errors']).to include(
          'detail' => 'Доступ к ресурсу ограничен'
        )
      end
    end

    context 'invalid city' do
      let(:ad_params) do
        {
          title: 'Ad title',
          description: 'Ad description',
          city: '123city'
        }
      end

      before do
        allow(geo_service).to receive(:get)
        .with(ad_params[:city])
        .and_return({'errors'=>{}})
      end

      it 'returns an error' do
        post '/v1', ad: ad_params

        expect(last_response.status).to eq(201)
        expect(Ad.last.lat).to be_nil
        expect(Ad.last.lon).to be_nil
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

      before do
        allow(geo_service).to receive(:get)
        .with(ad_params[:city])
        .and_return({'errors'=>{}})
      end

      it 'returns an error' do
        post '/v1', ad: ad_params

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

      it 'creates a new ad' do
        expect { post '/v1', ad: ad_params }
          .to change { Ad.count }.from(0).to(1)

        expect(last_response.status).to eq(201)
      end

      it 'returns an ad' do
        post '/v1', ad: ad_params

        expect(response_body['data']).to a_hash_including(
          'id' => last_ad.id.to_s,
          'type' => 'ad'
        )
      end
    end
  end
end
