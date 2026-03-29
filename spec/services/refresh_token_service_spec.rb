require 'rails_helper'

RSpec.describe RefreshTokenService do
  let(:user) { create(:user) }

  describe ".create_for" do
    it "creates a refresh token for the user" do
      token = described_class.create_for(user)

      expect(token).to be_present
      expect(RefreshToken.count).to eq(1)
      expect(RefreshToken.first.user).to eq(user)
    end
  end

  describe ".find" do
    it "returns the refresh token record when valid" do
      raw_token = described_class.create_for(user)

      record = described_class.find(raw_token)

      expect(record).to be_present
      expect(record.user).to eq(user)
    end

    it "returns nil when token is invalid" do
      result = described_class.find("invalidtoken")

      expect(result).to be_nil
    end
  end
end
