require 'rails_helper'

RSpec.describe AuthenticationController, type: :controller do
  describe '#authenticate' do
    let(:user) { create(:user) } # Assuming you have a FactoryBot definition for User

    before do
      allow(AuthenticateUser).to receive(:call).and_return(context_object)
      post :authenticate, params: { email: user.email, password: 'password' }
    end

    context 'when authentication is successful' do
      let(:context_object) { double(:context, success?: true, result: 'sample_token') }

      it 'returns auth token' do
        expect(response.body).to eq({ auth_token: 'sample_token' }.to_json)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when authentication fails' do
      let(:context_object) { double(:context, success?: false, errors: 'Invalid credentials') }

      it 'returns an error message' do
        expect(response.body).to eq({ error: 'Invalid credentials' }.to_json)
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end