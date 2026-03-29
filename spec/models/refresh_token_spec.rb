require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a user" do
      token = RefreshToken.create!(
        user: user,
        token_digest: "digest",
        expires_at: 7.days.from_now
      )

      expect(token.user).to eq(user)
    end
  end

  describe "#revoke!" do
    it "marks the token as revoked" do
      token = RefreshToken.create!(
        user: user,
        token_digest: "digest",
        expires_at: 7.days.from_now
      )

      token.revoke!

      expect(token.revoked).to be true
    end
  end

  describe ".active scope" do
    it "returns only non-revoked tokens that have not expired" do
      active = RefreshToken.create!(
        user: user,
        token_digest: "digest1",
        expires_at: 7.days.from_now
      )

      revoked = RefreshToken.create!(
        user: user,
        token_digest: "digest2",
        expires_at: 7.days.from_now,
        revoked: true
      )

      expired = RefreshToken.create!(
        user: user,
        token_digest: "digest3",
        expires_at: 1.day.ago
      )

      expect(RefreshToken.active).to include(active)
      expect(RefreshToken.active).not_to include(revoked)
      expect(RefreshToken.active).not_to include(expired)
    end
  end
end
