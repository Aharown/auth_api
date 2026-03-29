require 'rails_helper'

RSpec.describe "Token Refresh", type: :request do
  let(:user) { create(:user) }

  it "rotates refresh tokens" do
    refresh_token = RefreshTokenService.create_for(user)

    post "/refresh", headers: {
      "Authorization" => "Bearer #{refresh_token}"
    }

    expect(response).to have_http_status(:ok)

    json = JSON.parse(response.body)

    expect(json["access_token"]).to be_present
    expect(json["refresh_token"]).to be_present

    expect(RefreshToken.active.count).to eq(1)
  end

  it "rejects invalid refresh tokens" do
    post "/refresh", headers: {
      "Authorization" => "Bearer invalidtoken"
    }

    expect(response).to have_http_status(:unauthorized)
  end
end
