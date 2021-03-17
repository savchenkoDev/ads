RSpec.describe Geocoder::Client, type: :client do
  subject { described_class.new(connection: connection) }

  let(:status) { 200 }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:body) { {} }

  before do
    stubs.get('coordinates') { [status, headers, body.to_json] }
  end

  describe '#coordinates {valid city}' do
    let(:city) { "Екатеринбург" }
    let(:body) { {'data' => { 'lat' => 56.839104, 'lon' => 60.60825 }} }

    it 'returns coordinates' do
      expect(subject.get(city)).to eq(body)
    end
  end
  
  describe '#coordinates {invalid city}' do
    let(:status) { 400 }
    let(:city) { "Екатеринбург" }
    let(:body) { {'errors' => { 'detail' => 'Данного города не существует' }} }

    it 'returns errors' do
      expect(subject.get(city)).to eq(body)
    end
  end
end