require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  describe 'POST /login' do
    it 'returns a JWT with valid credentials' do
      post '/login', params: {
        email: 'test@example.com',
        password: 'password'
      }

      expect(response).to have_http_status(:ok)
      expect(json['token']).to be_present
    end

    it 'fails with invalid credentials' do
      post '/login', params: {
        email: 'test@example.com',
        password: 'wrong'
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
