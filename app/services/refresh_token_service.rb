class RefreshTokenService
  def self.create_for(user)
    token = SecureRandom.hex(64)

    digest = Digest::SHA256.hexdigest(token)

    RefreshToken.create!(
      user: user,
      token_digest: digest,
      expires_at: 7.days.from_now
    )

    token
  end

  def self.find(token)
    digest = Digest::SHA256.hexdigest(token)

    RefreshToken.active.find_by(token_digest: digest)
  end
end
