require "rails_helper"

RSpec.describe 'Protected endpoint', type: :request do
  let!(:user) do
    User.create!(
      email: 'test@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end

  let(:token) { JwtEncoder.call(user_id: user.id) }

  it 'returns user info with valid token' do
    get '/me', headers: auth_header(token)

    expect(response).to have_http_status(:ok)
    expect(json['email']).to eq(user.email)
    puts response.status
    puts response.body
  end

  it 'returns 401 without token' do
    get '/me'

    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns 401 with malformed token' do
    get '/me', headers: auth_header('bad.token.value')

    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns 401 with expired token' do
    expired_token = JwtEncoder.call(
      { user_id: user.id },
      1.hour.ago
    )

    get '/me', headers: auth_header(expired_token)

    expect(response).to have_http_status(:unauthorized)
  end
end
