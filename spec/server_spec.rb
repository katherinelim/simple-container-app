describe '.server' do
  context 'when fetching / endpoint' do
    it 'returns 404' do
      get '/'
      expect(last_response.status).to eq 404
    end
  end
  context 'when fetching /healthcheck endpoint' do
    it 'returns healthcheck information' do
      get '/healthcheck'
      expect(last_response.status).to eq 200
      info = JSON.parse(last_response.body)
      expect(info.size).to eq 1
      expect(info['myapplication'][0]['version']).not_to be_empty
      expect(info['myapplication'][0]['description']).not_to be_empty
      expect(info['myapplication'][0]['lastcommitsha']).not_to be_empty
    end
  end
end
