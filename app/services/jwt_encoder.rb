class JwtEncoder
  SECRET_KEY = Rails.application.secret_key_base

  def self.call(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload,       Rails.application.secret_key_base,
    'HS256')
  end
end
