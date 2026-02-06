require 'rails_helper'

RSpec.describe 'User Registration', type: :request do
  describe 'POST /register' do
    let(:valid_params) do
      {
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    end

    it 'registers a user successfully' do
      post '/register', params: valid_params

      expect(response).to have_http_status(:created)
      expect(User.count).to eq(1)
      expect(json['user']['email']).to eq('test@example.com')
      expect(json['token']).to be_present
      puts response.status
      puts response.body
    end

    it 'fails with missing params' do
      post '/register', params: { email: '' }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
