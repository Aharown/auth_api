class JwtDecoder
  def self.call(token)
    decoded = JWT.decode(token, SECRET_KEY, true,
    algorithm: 'HS256')[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
  :expired

  rescue JWT::DecodeError, JWT::VerificationError
  nil
  end
end
