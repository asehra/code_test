require 'leads_client'

RSpec.describe LeadsClient do
  describe '.enqueue' do
    context 'when successfully enqueued' do
      let(:success_response) { double(code: '201', body: '{"message":"Enqueue success","errors":[]}') }
      it 'responds with success and no errors' do
        allow(Net::HTTP).to receive(:post_form).and_return(success_response)
        response = LeadsClient.enqueue({})
        expect(response.success?).to eq(true)
        expect(response.errors).to eq([])        
      end
    end

    context 'when enqueue fails due to bad data' do
      let(:bad_data_errors) { ["Field business_name can't be blank"] }
      let(:bad_data_response) do
        double(code: '400', body: {
          errors: bad_data_errors
        }.to_json)
      end

      it 'responds with success and no errors' do
        allow(Net::HTTP).to receive(:post_form).and_return(bad_data_response)
        response = LeadsClient.enqueue({})
        expect(response.success?).to eq(false)
        expect(response.errors).to eq(bad_data_errors)        
      end
    end

    context 'when unable to connect to api' do
      it 'returns errors gracefully when SocketError' do
        allow(Net::HTTP).to receive(:post_form).and_raise(SocketError)
        response = LeadsClient.enqueue({})
        expect(response.success?).to eq(false)
        expect(response.errors).to eq(['Unable to register interest. Please try after some time'])
      end
      it 'returns errors gracefully when Errno::ECONNREFUSED' do
        allow(Net::HTTP).to receive(:post_form).and_raise(Errno::ECONNREFUSED)
        response = LeadsClient.enqueue({})
        expect(response.success?).to eq(false)
        expect(response.errors).to eq(['Unable to register interest. Please try after some time'])
      end
    end
  end
end